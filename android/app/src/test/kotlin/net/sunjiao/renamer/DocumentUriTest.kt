package net.sunjiao.renamer

import android.net.Uri
import android.provider.DocumentsContract
import org.junit.Assert.assertEquals
import org.junit.Assert.assertSame
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(manifest = Config.NONE, sdk = [29, 35])
class DocumentUriTest {
    private val authority = "net.sunjiao.renamer.test.documents"

    @Test
    fun bareTreeTargetsItsRootDocument() {
        val tree = DocumentsContract.buildTreeDocumentUri(authority, "primary:Photos")
        val document = resolveDocumentUri(tree)

        assertEquals("primary:Photos", DocumentsContract.getTreeDocumentId(document))
        assertEquals("primary:Photos", DocumentsContract.getDocumentId(document))
        assertSame(document, resolveDocumentUri(document))
    }

    @Test
    fun renamedDocumentKeepsNewIdAndOriginalTreeScope() {
        val tree = DocumentsContract.buildTreeDocumentUri(authority, "primary:Before")
        val renamed = DocumentsContract.buildDocumentUriUsingTree(tree, "primary:After")

        assertSame(renamed, resolveDocumentUri(renamed))
        assertEquals("primary:After", DocumentsContract.getDocumentId(resolveDocumentUri(renamed)))
        assertEquals("primary:Before", DocumentsContract.getTreeDocumentId(resolveDocumentUri(renamed)))
    }

    @Test
    fun nestedDocumentKeepsEncodedIdAndQueryParameters() {
        val tree = DocumentsContract.buildTreeDocumentUri(authority, "primary:照片")
        val child = DocumentsContract.buildDocumentUriUsingTree(tree, "primary:照片/子目录/a #%.jpg")
            .buildUpon().appendQueryParameter("provider-token", "a+b/c").build()

        assertSame(child, resolveDocumentUri(child))
        assertEquals("primary:照片/子目录/a #%.jpg", DocumentsContract.getDocumentId(resolveDocumentUri(child)))
    }

    @Test
    fun standaloneDocumentIsUnchanged() {
        val uri = DocumentsContract.buildDocumentUri(authority, "opaque-id-123")
        assertSame(uri, resolveDocumentUri(uri))
    }

    @Test
    fun mediaStoreUriIsUnchanged() {
        val uri = Uri.parse("content://media/external/images/media/123")
        assertSame(uri, resolveDocumentUri(uri))
    }

    @Test
    fun childrenCollectionIsNotReinterpretedAsRootDocument() {
        val tree = DocumentsContract.buildTreeDocumentUri(authority, "primary:Photos")
        val uri = DocumentsContract.buildChildDocumentsUriUsingTree(tree, "primary:Photos/Child")
        assertSame(uri, resolveDocumentUri(uri))
    }
}
