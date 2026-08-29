package net.sunjiao.renamer

import android.app.Activity
import android.content.ContentValues
import android.content.Intent
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.util.Log
import android.provider.DocumentsContract
import androidx.exifinterface.media.ExifInterface
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.OpenableColumns
import android.os.Handler
import android.os.Looper

class MainActivity: FlutterActivity() {
    private val CHANNEL = "net.sunjiao.renamer/picker"
    private val REQUEST_CODE_OPEN_DOC = 1
    private val REQUEST_CODE_OPEN_TREE = 2
    private val REQUEST_CODE_MEDIA_WRITE = 3
    private val MEDIA_WRITE_BATCH_SIZE = 2_000

    private var pendingResult: MethodChannel.Result? = null
    private var pendingMediaWriteResult: MethodChannel.Result? = null
    private val pendingMediaWriteBatches = ArrayDeque<List<MediaWriteCandidate>>()
    private var activeMediaWriteBatch: List<MediaWriteCandidate> = emptyList()
    private val approvedMediaWriteUris = mutableListOf<String>()

    private data class MediaWriteCandidate(
        val documentUri: String,
        val mediaUri: Uri,
    )

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "fileAccess" -> {
                    val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                        addCategory(Intent.CATEGORY_OPENABLE)
                        type = "*/*"
                        putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
                        addFlags(
                            Intent.FLAG_GRANT_READ_URI_PERMISSION or
                                Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                                Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                        )
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
                "requestMediaWritePermission" -> {
                    val uriStrings = call.argument<List<String>>("uris")
                    if (uriStrings != null) {
                        requestMediaWritePermission(uriStrings, result)
                    } else {
                        result.error("ARGS_ERROR", "Uris is null", null)
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
                "getEmbeddedMetadata" -> {
                    val uriString = call.argument<String>("uri")
                    if (uriString != null) {
                        getEmbeddedMetadata(uriString, result)
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

        if (requestCode == REQUEST_CODE_MEDIA_WRITE) {
            handleMediaWritePermissionResult(resultCode)
            return
        }

        if (pendingResult == null) return

        if (resultCode != Activity.RESULT_OK || data == null) {
            pendingResult?.success(null)
            pendingResult = null
            return
        }

        val resultList = mutableListOf<String>()
        var hasUnsupportedFiles = false

        if (requestCode == REQUEST_CODE_OPEN_DOC) {
            // get all selected URI
            val uris = mutableListOf<Uri>()
            if (data.clipData != null) {
                val count = data.clipData!!.itemCount
                for (i in 0 until count) {
                    uris.add(data.clipData!!.getItemAt(i).uri)
                }
            } else if (data.data != null) {
                uris.add(data.data!!)
            }

            val takeFlags = data.flags and
                (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)

            // Keep documents that can be renamed through SAF and media documents
            // that can be renamed through MediaStore after an explicit user grant.
            for (uri in uris) {
                if (checkSupportsRename(uri) || mediaUriFor(uri) != null) {
                    persistUriPermission(uri, takeFlags)
                    resultList.add(uri.toString())
                } else {
                    Log.w("Renamer", "Filtered unsupported document: $uri")
                    hasUnsupportedFiles = true
                }
            }
        } else if (requestCode == REQUEST_CODE_OPEN_TREE) {
            val treeUri = data.data
            if (treeUri != null) {
                if (checkSupportsRename(treeUri)) {
                    val takeFlags = data.flags and
                        (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                    persistUriPermission(treeUri, takeFlags)
                    resultList.add(treeUri.toString())
                } else {
                    Log.w("Renamer", "Filtered unsupported tree: $treeUri")
                    hasUnsupportedFiles = true
                }
            }
        }

        val resultMap = mapOf(
            "paths" to resultList,
            "hasUnsupportedFiles" to hasUnsupportedFiles
        )
        pendingResult?.success(resultMap)
        pendingResult = null
    }

    private fun persistUriPermission(uri: Uri, flags: Int) {
        if (flags == 0) return

        try {
            contentResolver.takePersistableUriPermission(uri, flags)
        } catch (e: Exception) {
            // The temporary grant remains usable for the current process. Some
            // third-party providers do not offer persistent grants.
            Log.w("Renamer", "Failed to persist permission for $uri", e)
        }
    }

    private fun checkSupportsRename(uri: Uri): Boolean {
        var supportsRename = false
        try {
            val docUri = if (DocumentsContract.isTreeUri(uri)) {
                DocumentsContract.buildDocumentUriUsingTree(uri, DocumentsContract.getTreeDocumentId(uri))
            } else {
                uri
            }

            contentResolver.query(docUri, arrayOf(DocumentsContract.Document.COLUMN_FLAGS), null, null, null)?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val flags = cursor.getInt(0)
                    supportsRename = (flags and DocumentsContract.Document.FLAG_SUPPORTS_RENAME) != 0
                }
            }
        } catch (e: Exception) {
            Log.e("Renamer", "Failed to check rename support for $uri", e)
        }

        return supportsRename
    }

    private fun renameDocument(uriString: String, newName: String, result: MethodChannel.Result) {
        Log.d("Renamer", "renameDocument called for: $uriString to: $newName")

        Thread {
            try {
                val originalUri = Uri.parse(uriString)

                val documentUri = if (DocumentsContract.isTreeUri(originalUri)) {
                    DocumentsContract.buildDocumentUriUsingTree(
                        originalUri,
                        DocumentsContract.getTreeDocumentId(originalUri)
                    )
                } else {
                    originalUri
                }

                val newUri = if (checkSupportsRename(documentUri)) {
                    DocumentsContract.renameDocument(contentResolver, documentUri, newName)
                } else {
                    renameMediaDocument(documentUri, newName)
                }

                // go back to main thread and return values
                Handler(Looper.getMainLooper()).post {
                    if (newUri != null) {
                        Log.d("Renamer", "Rename success: $newUri")
                        try {
                            contentResolver.takePersistableUriPermission(newUri,
                                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                        } catch (e: Exception) {
                            Log.e("Renamer", "Failed to take persistable permission for new URI", e)
                        }
                        result.success(newUri.toString())
                    } else {
                        Log.e("Renamer", "DocumentsContract.renameDocument returned null")
                        result.error("RENAME_FAILED", "Provider returned null (May not support renaming, or name is invalid)", null)
                    }
                }
            } catch (e: Exception) {
                Log.e("Renamer", "Rename error for $uriString", e)
                Handler(Looper.getMainLooper()).post {
                    result.error("RENAME_ERROR", "${e.javaClass.simpleName}: ${e.localizedMessage}", null)
                }
            }
        }.start()
    }

    /**
     * Requests a user-approved MediaStore write grant for documents whose
     * provider does not expose FLAG_SUPPORTS_RENAME. This covers media selected
     * from collection views such as Images, Videos, and Recent on Android 12+.
     */
    private fun requestMediaWritePermission(uriStrings: List<String>, result: MethodChannel.Result) {
        if (pendingMediaWriteResult != null) {
            result.error("PENDING_MEDIA_WRITE", "A media write request is already pending", null)
            return
        }

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            result.success(mapOf("candidates" to emptyList<String>(), "approved" to emptyList<String>()))
            return
        }

        val candidates = uriStrings.distinct().mapNotNull { uriString ->
            val documentUri = Uri.parse(uriString)
            if (checkSupportsRename(documentUri)) {
                null
            } else {
                mediaUriFor(documentUri)?.let { mediaUri ->
                    MediaWriteCandidate(uriString, mediaUri)
                }
            }
        }.distinctBy { it.mediaUri }

        if (candidates.isEmpty()) {
            result.success(mapOf("candidates" to emptyList<String>(), "approved" to emptyList<String>()))
            return
        }

        pendingMediaWriteResult = result
        approvedMediaWriteUris.clear()
        pendingMediaWriteBatches.clear()
        candidates.chunked(MEDIA_WRITE_BATCH_SIZE).forEach(pendingMediaWriteBatches::addLast)
        startNextMediaWriteRequest()
    }

    private fun startNextMediaWriteRequest() {
        if (pendingMediaWriteBatches.isEmpty()) {
            finishMediaWriteRequest()
            return
        }

        activeMediaWriteBatch = pendingMediaWriteBatches.removeFirst()
        try {
            val request = MediaStore.createWriteRequest(
                contentResolver,
                activeMediaWriteBatch.map { it.mediaUri }
            )
            startIntentSenderForResult(
                request.intentSender,
                REQUEST_CODE_MEDIA_WRITE,
                null,
                0,
                0,
                0
            )
        } catch (e: Exception) {
            Log.e("Renamer", "Failed to request MediaStore write access", e)
            finishMediaWriteRequest()
        }
    }

    private fun handleMediaWritePermissionResult(resultCode: Int) {
        if (pendingMediaWriteResult == null) return

        if (resultCode == Activity.RESULT_OK) {
            approvedMediaWriteUris.addAll(activeMediaWriteBatch.map { it.documentUri })
            startNextMediaWriteRequest()
        } else {
            finishMediaWriteRequest()
        }
    }

    private fun finishMediaWriteRequest() {
        val allCandidates = activeMediaWriteBatch.map { it.documentUri } +
            pendingMediaWriteBatches.flatten().map { it.documentUri } +
            approvedMediaWriteUris
        val response = mapOf(
            "candidates" to allCandidates.distinct(),
            "approved" to approvedMediaWriteUris.distinct()
        )

        pendingMediaWriteResult?.success(response)
        pendingMediaWriteResult = null
        activeMediaWriteBatch = emptyList()
        pendingMediaWriteBatches.clear()
        approvedMediaWriteUris.clear()
    }

    private fun mediaUriFor(documentUri: Uri): Uri? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return null

        return try {
            MediaStore.getMediaUri(this, documentUri)
        } catch (e: Exception) {
            Log.w("Renamer", "No MediaStore URI for $documentUri", e)
            null
        }
    }

    private fun renameMediaDocument(documentUri: Uri, newName: String): Uri? {
        val mediaUri = mediaUriFor(documentUri) ?: return null
        val changed = contentResolver.update(
            mediaUri,
            ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, newName)
            },
            null,
            null
        )

        return if (changed > 0) documentUri else null
    }

    private fun getMetaData(uriString: String, result: MethodChannel.Result) {
        val originalUri = Uri.parse(uriString)
        val uri = if (DocumentsContract.isTreeUri(originalUri)) {
            DocumentsContract.buildDocumentUriUsingTree(
                originalUri,
                DocumentsContract.getTreeDocumentId(originalUri)
            )
        } else {
            originalUri
        }
        val metadata = HashMap<String, Any?>()
        var name: String? = null

        try {
            contentResolver.query(uri, null, null, null, null)?.use { cursor ->
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

    private fun getEmbeddedMetadata(uriString: String, result: MethodChannel.Result) {
        Thread {
            try {
                val uri = Uri.parse(uriString)
                val metadata = linkedMapOf<String, String>()
                readExifMetadata(uri, metadata)
                readAudioMetadata(uri, metadata)
                runOnUiThread {
                    result.success(metadata)
                }
            } catch (e: Exception) {
                Log.w("Renamer", "Failed to read embedded metadata for $uriString", e)
                runOnUiThread {
                    result.success(emptyMap<String, String>())
                }
            }
        }.start()
    }

    private fun readExifMetadata(uri: Uri, metadata: MutableMap<String, String>) {
        try {
            contentResolver.openFileDescriptor(uri, "r")?.use { descriptor ->
                addExifMetadata(ExifInterface(descriptor.fileDescriptor), metadata)
                return
            }
        } catch (e: Exception) {
            Log.d("Renamer", "File descriptor EXIF read failed; trying stream", e)
        }

        try {
            contentResolver.openInputStream(uri)?.use { inputStream ->
                addExifMetadata(ExifInterface(inputStream), metadata)
            }
        } catch (e: Exception) {
            Log.d("Renamer", "EXIF is unavailable for $uri", e)
        }
    }

    private fun addExifMetadata(exif: ExifInterface, metadata: MutableMap<String, String>) {
        val dateTime = exif.getAttribute(ExifInterface.TAG_DATETIME_ORIGINAL)
            ?: exif.getAttribute(ExifInterface.TAG_DATETIME)
            ?: exif.getAttribute(ExifInterface.TAG_DATETIME_DIGITIZED)
        if (dateTime != null) {
            metadata["Photo:Date"] = dateTime.substringBefore(' ')
            metadata["Photo:Time"] = dateTime
        }

        val make = exif.getAttribute(ExifInterface.TAG_MAKE).orEmpty()
        val model = exif.getAttribute(ExifInterface.TAG_MODEL).orEmpty()
        if (make.isNotEmpty() || model.isNotEmpty()) {
            metadata["Photo:CamName"] = if (model.contains(make)) model else "$make $model"
        }
        putAttribute(metadata, "Photo:LensName", exif, ExifInterface.TAG_LENS_MODEL)
        putDoubleAttribute(metadata, "Photo:FocalLength", exif, ExifInterface.TAG_FOCAL_LENGTH)
        exif.getAttributeDouble(ExifInterface.TAG_F_NUMBER, Double.NaN).takeIf { !it.isNaN() }?.let {
            metadata["Photo:Aperture"] = "f/$it"
        }
        putAttribute(metadata, "Photo:Shutter", exif, ExifInterface.TAG_EXPOSURE_TIME)
        putAttribute(metadata, "Photo:ISO", exif, ExifInterface.TAG_PHOTOGRAPHIC_SENSITIVITY)
        if (!metadata.containsKey("Photo:ISO")) {
            putAttribute(metadata, "Photo:ISO", exif, ExifInterface.TAG_ISO_SPEED_RATINGS)
        }

        exif.getLatLong()?.let { coordinates ->
            metadata["Photo:Latitude"] = formatCoordinate(coordinates[0], 'N', 'S')
            metadata["Photo:Longitude"] = formatCoordinate(coordinates[1], 'E', 'W')
        }
        exif.getAltitude(Double.NaN).takeIf { !it.isNaN() }?.let {
            metadata["Photo:Altitude"] = it.toString()
        }
        exif.getAttributeDouble(ExifInterface.TAG_GPS_IMG_DIRECTION, Double.NaN)
            .takeIf { !it.isNaN() }
            ?.let { direction ->
                val reference = exif.getAttribute(ExifInterface.TAG_GPS_IMG_DIRECTION_REF).orEmpty()
                metadata["Photo:Direction"] = "$direction°$reference"
            }
        putAttribute(metadata, "Photo:Photographer", exif, ExifInterface.TAG_ARTIST)
        putAttribute(metadata, "Photo:Copyright", exif, ExifInterface.TAG_COPYRIGHT)
    }

    private fun putAttribute(metadata: MutableMap<String, String>, key: String, exif: ExifInterface, tag: String) {
        exif.getAttribute(tag)?.let { metadata[key] = it }
    }

    private fun putDoubleAttribute(metadata: MutableMap<String, String>, key: String, exif: ExifInterface, tag: String) {
        exif.getAttributeDouble(tag, Double.NaN).takeIf { !it.isNaN() }?.let { metadata[key] = it.toString() }
    }

    private fun formatCoordinate(value: Double, positiveRef: Char, negativeRef: Char): String {
        val absolute = kotlin.math.abs(value)
        val degrees = absolute.toInt()
        val minutesWithFraction = (absolute - degrees) * 60
        val minutes = minutesWithFraction.toInt()
        val seconds = (minutesWithFraction - minutes) * 60
        val reference = if (value >= 0) positiveRef else negativeRef
        return "$degrees°$minutes′$seconds″$reference"
    }

    private fun readAudioMetadata(uri: Uri, metadata: MutableMap<String, String>) {
        val retriever = MediaMetadataRetriever()
        try {
            retriever.setDataSource(this, uri)
            putMediaMetadata(metadata, "Music:AlbumName", retriever, MediaMetadataRetriever.METADATA_KEY_ALBUM)
            putMediaMetadata(metadata, "Music:Year", retriever, MediaMetadataRetriever.METADATA_KEY_YEAR)
            putMediaMetadata(metadata, "Music:TrackName", retriever, MediaMetadataRetriever.METADATA_KEY_TITLE)
            putMediaMetadata(metadata, "Music:TrackNumber", retriever, MediaMetadataRetriever.METADATA_KEY_CD_TRACK_NUMBER)
            putMediaMetadata(metadata, "Music:DiscNumber", retriever, MediaMetadataRetriever.METADATA_KEY_DISC_NUMBER)
            putMediaMetadata(metadata, "Music:Genres", retriever, MediaMetadataRetriever.METADATA_KEY_GENRE)
            putMediaMetadata(metadata, "Music:Author", retriever, MediaMetadataRetriever.METADATA_KEY_ARTIST)
            retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull()?.let {
                metadata["Music:TrackDuration"] = formatDuration(it)
            }
        } catch (e: Exception) {
            Log.d("Renamer", "Audio metadata is unavailable for $uri", e)
        } finally {
            retriever.release()
        }
    }

    private fun putMediaMetadata(metadata: MutableMap<String, String>, key: String, retriever: MediaMetadataRetriever, metadataKey: Int) {
        retriever.extractMetadata(metadataKey)?.let { metadata[key] = it }
    }

    private fun formatDuration(milliseconds: Long): String {
        val centiseconds = milliseconds / 10
        val seconds = milliseconds / 1_000
        val minutes = milliseconds / 60_000
        val hours = milliseconds / 3_600_000
        return when {
            hours > 0 -> "$hours:${twoDigits(minutes)}:${twoDigits(seconds)}.${twoDigits(centiseconds)}"
            minutes > 0 -> "${twoDigits(minutes)}:${twoDigits(seconds)}.${twoDigits(centiseconds)}"
            seconds > 0 -> "${twoDigits(seconds)}.${twoDigits(centiseconds)}sec"
            else -> "${milliseconds}ms"
        }
    }

    private fun twoDigits(value: Long): String = if (value >= 10) "$value" else "0$value"

}
