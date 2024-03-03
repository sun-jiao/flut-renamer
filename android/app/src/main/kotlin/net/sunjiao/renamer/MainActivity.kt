package net.sunjiao.renamer

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.DocumentsContract
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/** Seems not work. the uri path cannot be reused */
class MainActivity : FlutterActivity() {
    private val CHANNEL = "net.sunjiao.renamer/picker"
    private val DIR_ACCESS = 14289
    private val FILE_ACCESS = 78967
    private var currentFR: MethodChannel.Result? = null

    /** Modified based on this link:
     * https://docs.flutter.dev/platform-integration/platform-channels#step-3-add-an-android-platform-specific-implementation
     * Flutter (C) BSD */
    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "dirAccess" -> {
                    currentFR = result
                    val startPath: String = if (call.hasArgument("startPath")) {
                        call.argument<String>("startPath").toString()
                    } else {
                        Environment.getExternalStorageDirectory().path
                    }
                    openDirectory(Uri.parse(startPath))
                }

                "fileAccess" -> {
                    currentFR = result
                    val startPath: String = if (call.hasArgument("startPath")) {
                        call.argument<String>("startPath").toString()
                    } else {
                        Environment.getExternalStorageDirectory().path
                    }
                    openFile(Uri.parse(startPath.replace(":/", ":///")))
                }

                else -> result.notImplemented()
            }
        }
    }

    /** Modified based on this link: https://developer.android.com/training/data-storage/shared/documents-files?hl=zh-cn
     * Android (C) Apache 2.0 */
    @RequiresApi(Build.VERSION_CODES.O)
    fun openDirectory(pickerInitialUri: Uri) {
        // Choose a directory using the system's file picker.
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
            // Optionally, specify a URI for the directory that should be opened in
            // the system file picker when it loads.
            putExtra(DocumentsContract.EXTRA_INITIAL_URI, pickerInitialUri)
        }

        startActivityForResult(intent, DIR_ACCESS)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onActivityResult(
        requestCode: Int, resultCode: Int, resultData: Intent?
    ) {
        if (requestCode == DIR_ACCESS) {
            if (resultCode == Activity.RESULT_OK) {
                // The result data contains a URI for the document or directory that
                // the user selected.
                resultData?.data?.also { uri ->
                    openFile(uri)
                    currentFR?.success(listOf(uri.path))
                    return
                }
                currentFR?.error("NO_DATA", "resultData or resultData.data is null 74", null)
            }
            currentFR?.error("RESULT_ERROR", "resultCode is not OK 76", null)
        } else if (requestCode == FILE_ACCESS) {
            if (resultCode == Activity.RESULT_OK) {
                // The result data contains a URI for the document or directory that
                // the user selected.
                resultData?.clipData?.also { clipData ->
                    val list = mutableListOf<String>()
                    for (i in 0 until clipData.itemCount) {
                        val uri = clipData.getItemAt(i).uri
                        if (uri.path != null) {
                            list.add(uri.path!!)
                        }
                    }
                    currentFR?.success(list.toList())
                    return
                }
                currentFR?.error("NO_DATA", "resultData or resultData.data is null 92", null)
            }
            currentFR?.error("RESULT_ERROR", "resultCode is not OK 94", null)
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun openFile(pickerInitialUri: Uri) {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
            // Optionally, specify a URI for the file that should appear in the
            // system file picker when it loads.
            putExtra(DocumentsContract.EXTRA_INITIAL_URI, pickerInitialUri)
        }

        startActivityForResult(intent, FILE_ACCESS)
    }
}
