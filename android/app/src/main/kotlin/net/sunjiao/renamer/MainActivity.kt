package net.sunjiao.renamer

import android.content.Context
import android.database.Cursor
import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "net.sunjiao.renamer/picker"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "getRealPathFromURI") {
                val uriArg = call.argument<String>("uri")

                getRealPathFromURI(this, Uri.parse(uriArg), result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getRealPathFromURI(context: Context, contentUri: Uri, result: MethodChannel.Result) {
        var cursor: Cursor? = null
        try {
            val proj = arrayOf(MediaStore.Images.Media.DATA)
            cursor = context.contentResolver.query(contentUri, proj, null, null, null)
            val columnIndex: Int? = cursor?.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            if (columnIndex == null) {
                result.error("Cannot get column index", null, null)
                return
            }

            cursor?.moveToFirst()
            val absolute = cursor?.getString(columnIndex)
            if (!absolute.isNullOrEmpty()) {
                result.success(absolute)
                return
            }

            result.error("Cannot get absolute path", null, null)
        } catch (e: Exception) {
            Log.e("net.sunjiao.renamer", "getRealPathFromURI Exception : $e")
            result.error(e.message.toString(), e.localizedMessage, null)
        } finally {
            cursor?.close()
        }
    }
}
