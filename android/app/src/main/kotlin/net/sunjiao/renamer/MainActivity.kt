package net.sunjiao.renamer

import android.app.Activity
import android.content.Context
import android.database.Cursor
import android.content.Intent
import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import android.provider.DocumentsContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.provider.OpenableColumns
import java.io.ByteArrayOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "net.sunjiao.renamer/picker"
    private val REQUEST_CODE_OPEN_DOC = 1
    private val REQUEST_CODE_OPEN_TREE = 2

    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "fileAccess" -> {
                    val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                        addCategory(Intent.CATEGORY_OPENABLE)
                        type = "*/*"
                        putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
                    }
                    startActivityForResult(intent, REQUEST_CODE_OPEN_DOC, result)
                }
                "dirAccess" -> {
                    val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
                    startActivityForResult(intent, REQUEST_CODE_OPEN_TREE, result)
                }
                "rename" -> {
                    val uriString = call.argument<String>("uri")
                    val newName = call.argument<String>("newName")
                    if (uriString != null && newName != null) {
                        renameDocument(uriString, newName, result)
                    } else {
                        result.error("ARGS_ERROR", "Uri or newName is null", null)
                    }
                }
                "changeScopedAccess" -> {
                    result.success(true)
                }
                "getMetaData" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString != null) {
                        getMetaData(uriString, result)
                    } else {
                        result.error("ARGS_ERROR", "Uri is null", null)
                    }
                }
                "readFile" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString != null) {
                        readFile(uriString, result)
                    } else {
                        result.error("ARGS_ERROR", "Uri is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startActivityForResult(intent: Intent, requestCode: Int, result: MethodChannel.Result) {
        if (pendingResult != null) {
            result.error("PENDING_RESULT", "A request is already pending", null)
            return
        }
        pendingResult = result
        try {
            startActivityForResult(intent, requestCode)
        } catch (e: Exception) {
            pendingResult = null
            result.error("ACTIVITY_ERROR", e.message, null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (pendingResult == null) return

        if (resultCode != Activity.RESULT_OK || data == null) {
            pendingResult?.success(null)
            pendingResult = null
            return
        }

        val resultList = mutableListOf<String>()

        if (requestCode == REQUEST_CODE_OPEN_DOC) {
            if (data.clipData != null) {
                val count = data.clipData!!.itemCount
                for (i in 0 until count) {
                    val uri = data.clipData!!.getItemAt(i).uri
                    contentResolver.takePersistableUriPermission(uri,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                    resultList.add(uri.toString())
                }
            } else if (data.data != null) {
                val uri = data.data!!
                contentResolver.takePersistableUriPermission(uri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                resultList.add(uri.toString())
            }
        } else if (requestCode == REQUEST_CODE_OPEN_TREE) {
            val treeUri = data.data
            if (treeUri != null) {
                contentResolver.takePersistableUriPermission(treeUri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                resultList.add(treeUri.toString())
            }
        }

        pendingResult?.success(resultList)
        pendingResult = null
    }

    private fun renameDocument(uriString: String, newName: String, result: MethodChannel.Result) {
        try {
            val uri = Uri.parse(uriString)
            val newUri = DocumentsContract.renameDocument(contentResolver, uri, newName)
            if (newUri != null) {
                result.success(newUri.toString())
            } else {
                result.error("RENAME_FAILED", "DocumentsContract returned null", null)
            }
        } catch (e: Exception) {
            result.error("RENAME_ERROR", e.localizedMessage, null)
        }
    }

    private fun getMetaData(uriString: String, result: MethodChannel.Result) {
        val uri = Uri.parse(uriString)
        val metadata = HashMap<String, Any?>()
        var name: String? = null

        try {
            val proj = arrayOf(MediaStore.Images.Media.DATA)
            contentResolver.query(uri, proj, null, null, null)?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                    if (nameIndex != -1) {
                        name = cursor.getString(nameIndex)
                    }

                    val sizeIndex = cursor.getColumnIndex(OpenableColumns.SIZE)
                    if (sizeIndex != -1) {
                        metadata["size"] = cursor.getLong(sizeIndex)
                    }

                    val dateIndex = cursor.getColumnIndex(DocumentsContract.Document.COLUMN_LAST_MODIFIED)
                    if (dateIndex != -1) {
                        metadata["modified"] = cursor.getLong(dateIndex)
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("Renamer", "Failed to query metadata for $uriString", e)
        }

        if (name.isNullOrEmpty()) {
            val path = uri.path
            val lastSegment = uri.lastPathSegment

            if (!lastSegment.isNullOrEmpty()) {
                name = lastSegment.substringAfterLast('/').substringAfterLast(':')
            } else if (!path.isNullOrEmpty()) {
                name = path.substringAfterLast('/')
            }
        }

        metadata["name"] = name ?: "unknown_${System.currentTimeMillis()}"

        if (!metadata.containsKey("modified")) {
            metadata["modified"] = System.currentTimeMillis()
        }

        result.success(metadata)
    }

    private fun readFile(uriString: String, result: MethodChannel.Result) {
        Thread {
            try {
                val uri = Uri.parse(uriString)
                val inputStream = contentResolver.openInputStream(uri)
                val bytes = inputStream?.readBytes()
                inputStream?.close()
                runOnUiThread {
                    if (bytes != null) {
                        result.success(bytes)
                    } else {
                        result.error("READ_ERROR", "Could not read bytes", null)
                    }
                }
            } catch (e: Exception) {
                runOnUiThread {
                    result.error("READ_ERROR", e.localizedMessage, null)
                }
            }
        }.start()
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
