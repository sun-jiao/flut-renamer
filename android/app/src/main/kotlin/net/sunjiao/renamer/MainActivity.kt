package net.sunjiao.renamer

import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "net.sunjiao.renamer/picker"
    private var sharedFiles: ArrayList<String> = ArrayList()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "getRealPathFromURI" -> {
                    val uriArg = call.argument<String>("uri")
                    getRealPathFromURI(this, Uri.parse(uriArg), result)
                }
                "getSharedFiles" -> {
                    result.success(sharedFiles)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        sharedFiles.clear()
        when (intent.action) {
            Intent.ACTION_SEND -> {
                intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)?.let { uri ->
                    getRealPathFromURI(this, uri)?.let { path ->
                        sharedFiles.add(path)
                    }
                }
            }
            Intent.ACTION_SEND_MULTIPLE -> {
                intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)?.forEach { uri ->
                    getRealPathFromURI(this, uri)?.let { path ->
                        sharedFiles.add(path)
                    }
                }
            }
        }
    }

    private fun getRealPathFromURI(context: Context, contentUri: Uri): String? {
        var cursor: Cursor? = null
        try {
            val proj = arrayOf(MediaStore.Images.Media.DATA)
            cursor = context.contentResolver.query(contentUri, proj, null, null, null)
            val columnIndex: Int? = cursor?.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            if (columnIndex == null) {
                return null
            }

            cursor?.moveToFirst()
            val absolute = cursor?.getString(columnIndex)
            return if (!absolute.isNullOrEmpty()) absolute else null
        } catch (e: Exception) {
            Log.e("net.sunjiao.renamer", "getRealPathFromURI Exception : $e")
            return null
        } finally {
            cursor?.close()
        }
    }

    private fun getRealPathFromURI(context: Context, contentUri: Uri, result: MethodChannel.Result) {
        val path = getRealPathFromURI(context, contentUri)
        if (path != null) {
            result.success(path)
        } else {
            result.error("Cannot get absolute path", null, null)
        }
    }
}
