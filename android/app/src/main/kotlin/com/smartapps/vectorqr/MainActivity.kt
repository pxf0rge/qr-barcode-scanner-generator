package com.smartapps.vectorqr

import android.content.ContentValues
import android.media.MediaScannerConnection
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    private val downloadsChannel = "com.smartapps.vectorqr/downloads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, downloadsChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveToDownloads" -> {
                        val fileName = call.argument<String>("fileName")
                        val bytes = call.argument<ByteArray>("bytes")
                        val requestedMime = call.argument<String>("mimeType")
                        if (fileName.isNullOrBlank() || bytes == null) {
                            result.error("bad_args", "fileName and bytes are required", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val mimeType = resolveMimeType(fileName, requestedMime)
                            val saved = saveToDownloads(fileName, bytes, mimeType)
                            result.success(saved)
                        } catch (e: Exception) {
                            result.error("save_failed", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /** Prefer image/svg+xml for .svg so MediaStore / viewers classify correctly. */
    private fun resolveMimeType(fileName: String, requested: String?): String {
        if (fileName.endsWith(".svg", ignoreCase = true)) {
            return "image/svg+xml"
        }
        return requested?.takeIf { it.isNotBlank() } ?: "application/octet-stream"
    }

    private fun saveToDownloads(fileName: String, bytes: ByteArray, mimeType: String): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            saveViaMediaStore(fileName, bytes, mimeType)
        } else {
            saveViaLegacyDownloads(fileName, bytes, mimeType)
        }
    }

    private fun saveViaMediaStore(fileName: String, bytes: ByteArray, mimeType: String): String {
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
            put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
            put(MediaStore.MediaColumns.IS_PENDING, 1)
        }
        val resolver = applicationContext.contentResolver
        val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
            ?: throw IllegalStateException("Unable to create Downloads entry")
        try {
            resolver.openOutputStream(uri)?.use { stream ->
                stream.write(bytes)
                stream.flush()
            } ?: throw IllegalStateException("Unable to write Downloads file")

            values.clear()
            values.put(MediaStore.MediaColumns.IS_PENDING, 0)
            values.put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
            values.put(MediaStore.MediaColumns.SIZE, bytes.size.toLong())
            resolver.update(uri, values, null, null)
            resolver.notifyChange(uri, null)
            return uri.toString()
        } catch (e: Exception) {
            resolver.delete(uri, null, null)
            throw e
        }
    }

    @Suppress("DEPRECATION")
    private fun saveViaLegacyDownloads(
        fileName: String,
        bytes: ByteArray,
        mimeType: String,
    ): String {
        val dir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        if (!dir.exists()) {
            dir.mkdirs()
        }
        val file = File(dir, fileName)
        FileOutputStream(file).use { it.write(bytes) }

        val latch = CountDownLatch(1)
        var scannedUri: String? = null
        MediaScannerConnection.scanFile(
            applicationContext,
            arrayOf(file.absolutePath),
            arrayOf(mimeType),
        ) { _, uri ->
            scannedUri = uri?.toString()
            latch.countDown()
        }
        latch.await(3, TimeUnit.SECONDS)
        return scannedUri ?: file.absolutePath
    }
}
