package net.sunjiao.renamer

import android.content.ContentProvider
import android.content.ContentValues
import android.content.Context
import android.content.pm.ProviderInfo
import android.database.Cursor
import android.database.MatrixCursor
import android.net.Uri
import android.os.Bundle
import android.os.Looper
import android.provider.DocumentsContract
import io.flutter.plugin.common.MethodChannel
import java.io.FileNotFoundException
import java.util.concurrent.CompletableFuture
import java.util.concurrent.TimeUnit
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config
import org.robolectric.shadows.ShadowContentResolver
import org.robolectric.util.ReflectionHelpers
import org.robolectric.util.ReflectionHelpers.ClassParameter

/** Exercise the actual picker handlers without starting a Flutter engine. */
@RunWith(RobolectricTestRunner::class)
@Config(manifest = Config.NONE, sdk = [29, 35])
class DocumentOperationsTest {
    private val authority = "net.sunjiao.renamer.test.documents"
    private lateinit var activity: MainActivity
    private lateinit var provider: RenamingProvider

    @Before
    fun setUp() {
        val context = RuntimeEnvironment.getApplication()
        provider = RenamingProvider()
        provider.attachInfo(context, ProviderInfo().apply { authority = this@DocumentOperationsTest.authority })
        ShadowContentResolver.registerProviderInternal(authority, provider)
        activity = MainActivity()
        ReflectionHelpers.callInstanceMethod<Any>(
            activity, "attachBaseContext", ClassParameter.from(Context::class.java, context)
        )
    }

    @Test
    fun renamedTreeCanBeReadRenamedAgainAndRolledBack() {
        provider.documents["Before"] = Document("Before")
        val tree = DocumentsContract.buildTreeDocumentUri(authority, "Before")
        assertTrue(supportsRename(tree))
        assertEquals("Before", metadata(tree)["name"])

        val first = rename(tree, "After")
        assertEquals("Before", DocumentsContract.getTreeDocumentId(first))
        assertEquals("After", DocumentsContract.getDocumentId(first))
        assertFalse(provider.documents.containsKey("Before"))
        assertTrue(supportsRename(first))
        assertEquals(
            mapOf("name" to "After", "size" to 123L, "modified" to 1_700_000_000_000L),
            metadata(first)
        )

        val second = rename(first, "Final")
        assertEquals("Final", metadata(second)["name"])
        val restored = rename(second, "Before")
        assertEquals("Before", metadata(restored)["name"])
        assertEquals(listOf("Before", "After", "Final"), provider.renamedIds)
        assertEquals(setOf("Before"), provider.documents.keys)
    }

    @Test
    fun childCapabilityMetadataAndRenameNeverUseTheTreeRoot() {
        provider.documents["Root"] = Document("Root", supportsRename = false)
        provider.documents["Child"] = Document("Child")
        val tree = DocumentsContract.buildTreeDocumentUri(authority, "Root")
        val child = DocumentsContract.buildDocumentUriUsingTree(tree, "Child")

        assertFalse(supportsRename(tree))
        assertTrue(supportsRename(child))
        assertEquals("Child", metadata(child)["name"])
        val renamed = rename(child, "NewChild")

        assertEquals("Root", DocumentsContract.getTreeDocumentId(renamed))
        assertEquals("NewChild", metadata(renamed)["name"])
        assertEquals(listOf("Child"), provider.renamedIds)
        assertEquals("Root", provider.documents["Root"]?.name)
    }

    @Test
    fun standaloneDocumentStillUsesItsOwnId() {
        provider.documents["Original"] = Document("Original")
        val uri = DocumentsContract.buildDocumentUri(authority, "Original")
        assertTrue(supportsRename(uri))
        val renamed = rename(uri, "Renamed")
        assertFalse(DocumentsContract.isTreeUri(renamed))
        assertEquals("Renamed", metadata(renamed)["name"])
    }

    private fun supportsRename(uri: Uri): Boolean = ReflectionHelpers.callInstanceMethod(
        activity, "checkSupportsRename", ClassParameter.from(Uri::class.java, uri)
    )

    private fun metadata(uri: Uri): Map<*, *> {
        val result = ChannelResult()
        ReflectionHelpers.callInstanceMethod<Any>(
            activity, "getMetaData",
            ClassParameter.from(String::class.java, uri.toString()),
            ClassParameter.from(MethodChannel.Result::class.java, result)
        )
        return result.await() as Map<*, *>
    }

    private fun rename(uri: Uri, name: String): Uri {
        val result = ChannelResult()
        ReflectionHelpers.callInstanceMethod<Any>(
            activity, "renameDocument",
            ClassParameter.from(String::class.java, uri.toString()),
            ClassParameter.from(String::class.java, name),
            ClassParameter.from(MethodChannel.Result::class.java, result)
        )
        return Uri.parse(result.await() as String)
    }

    private class ChannelResult : MethodChannel.Result {
        private val completion = CompletableFuture<Any?>()
        override fun success(result: Any?) { completion.complete(result) }
        override fun error(code: String, message: String?, details: Any?) {
            completion.completeExceptionally(AssertionError("$code: $message"))
        }
        override fun notImplemented() {
            completion.completeExceptionally(AssertionError("Channel method not implemented"))
        }

        fun await(): Any? {
            val deadline = System.nanoTime() + TimeUnit.SECONDS.toNanos(5)
            while (!completion.isDone && System.nanoTime() < deadline) {
                shadowOf(Looper.getMainLooper()).idle()
                Thread.sleep(1)
            }
            return completion.get(1, TimeUnit.SECONDS)
        }
    }

    private data class Document(val name: String, val supportsRename: Boolean = true)

    /** Changes IDs on rename and retains the tree scope; does not model URI grants. */
    private class RenamingProvider : ContentProvider() {
        val documents = mutableMapOf<String, Document>()
        val renamedIds = mutableListOf<String>()
        override fun onCreate() = true

        override fun query(uri: Uri, projection: Array<out String>?, selection: String?,
                           selectionArgs: Array<out String>?, sortOrder: String?): Cursor {
            val id = DocumentsContract.getDocumentId(uri)
            val document = documents[id] ?: throw FileNotFoundException(id)
            val columns = projection ?: arrayOf(
                DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                DocumentsContract.Document.COLUMN_FLAGS,
                DocumentsContract.Document.COLUMN_SIZE,
                DocumentsContract.Document.COLUMN_LAST_MODIFIED
            )
            return MatrixCursor(columns).apply {
                addRow(columns.map { column ->
                    when (column) {
                        DocumentsContract.Document.COLUMN_DISPLAY_NAME -> document.name
                        DocumentsContract.Document.COLUMN_FLAGS ->
                            if (document.supportsRename) DocumentsContract.Document.FLAG_SUPPORTS_RENAME else 0
                        DocumentsContract.Document.COLUMN_SIZE -> 123L
                        DocumentsContract.Document.COLUMN_LAST_MODIFIED -> 1_700_000_000_000L
                        else -> null
                    }
                })
            }
        }

        @Suppress("DEPRECATION")
        override fun call(method: String, arg: String?, extras: Bundle?): Bundle {
            check(method == "android:renameDocument")
            val uri = extras!!.getParcelable<Uri>("uri")!!
            val name = extras.getString(DocumentsContract.Document.COLUMN_DISPLAY_NAME)!!
            val id = DocumentsContract.getDocumentId(uri)
            check(documents[id]?.supportsRename == true)
            check(!documents.containsKey(name))
            documents[name] = documents.remove(id)!!.copy(name = name)
            renamedIds.add(id)
            val renamed = if (DocumentsContract.isTreeUri(uri)) {
                DocumentsContract.buildDocumentUriUsingTree(uri, name)
            } else {
                DocumentsContract.buildDocumentUri(uri.authority!!, name)
            }
            return Bundle().apply { putParcelable("uri", renamed) }
        }

        override fun getType(uri: Uri) = DocumentsContract.Document.MIME_TYPE_DIR
        override fun insert(uri: Uri, values: ContentValues?): Uri? = error("Unexpected insert")
        override fun delete(uri: Uri, selection: String?, selectionArgs: Array<out String>?) =
            error("Unexpected delete")
        override fun update(uri: Uri, values: ContentValues?, selection: String?,
                            selectionArgs: Array<out String>?) = error("Unexpected MediaStore update")
    }
}
