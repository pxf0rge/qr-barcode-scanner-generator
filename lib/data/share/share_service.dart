import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/app_failure.dart';

class ShareService {
  static const _downloadsChannel =
      MethodChannel('com.smartapps.vectorqr/downloads');

  /// Writes [bytes] then opens the system share sheet.
  Future<Result<void>> shareBytes({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) async {
    try {
      final resolvedMime = _resolveMimeType(fileName, mimeType);
      final file = await _writeExportFile(bytes: bytes, fileName: fileName);
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(
              file.path,
              mimeType: resolvedMime,
              name: fileName,
            ),
          ],
        ),
      );

      unawaited(_delayedDelete(file));

      if (result.status == ShareResultStatus.unavailable) {
        return const Err(AppFailure(AppFailureCode.shareFailed));
      }
      return const Ok(null);
    } catch (_) {
      return const Err(AppFailure(AppFailureCode.shareFailed));
    }
  }

  /// Saves into the public Downloads folder (MediaStore on Android 10+).
  /// Falls back to app Documents/exports if needed.
  ///
  /// SVG exports must use [mimeType] `image/svg+xml` so MediaStore indexes
  /// them correctly for file managers and SVG-capable viewers.
  Future<Result<String>> saveBytes({
    required Uint8List bytes,
    required String fileName,
    String mimeType = 'application/octet-stream',
  }) async {
    final safeName = fileName.replaceAll(RegExp(r'[^\w.\-]+'), '_');
    final resolvedMime = _resolveMimeType(safeName, mimeType);

    // Prefer real public Downloads via platform channel (Android).
    if (Platform.isAndroid) {
      final mediaStore = await _saveViaMediaStore(
        bytes: bytes,
        fileName: safeName,
        mimeType: resolvedMime,
      );
      if (mediaStore.isOk) return mediaStore;
    }

    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (status.isGranted || status.isLimited) {
          final downloads = Directory('/storage/emulated/0/Download');
          if (await downloads.exists()) {
            final publicFile = File('${downloads.path}/$safeName');
            await publicFile.writeAsBytes(bytes, flush: true);
            return Ok(publicFile.path);
          }
        }
      }

      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir != null) {
        final publicFile = File('${downloadsDir.path}/$safeName');
        await publicFile.writeAsBytes(bytes, flush: true);
        return Ok(publicFile.path);
      }

      final file = await _writeExportFile(
        bytes: bytes,
        fileName: safeName,
        durable: true,
      );
      return Ok(file.path);
    } catch (_) {
      return const Err(AppFailure(AppFailureCode.saveFailed));
    }
  }

  /// Force correct MIME for SVG even if a caller passes a generic type.
  String _resolveMimeType(String fileName, String mimeType) {
    if (fileName.toLowerCase().endsWith('.svg')) {
      return 'image/svg+xml';
    }
    return mimeType;
  }

  Future<Result<String>> _saveViaMediaStore({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
  }) async {
    try {
      final path = await _downloadsChannel.invokeMethod<String>(
        'saveToDownloads',
        <String, dynamic>{
          'fileName': fileName,
          'bytes': bytes,
          'mimeType': mimeType,
        },
      );
      if (path == null || path.isEmpty) {
        return const Err(AppFailure(AppFailureCode.saveFailed));
      }
      return Ok(path);
    } on PlatformException {
      return const Err(AppFailure(AppFailureCode.saveFailed));
    } on MissingPluginException {
      return const Err(AppFailure(AppFailureCode.saveFailed));
    } catch (_) {
      return const Err(AppFailure(AppFailureCode.saveFailed));
    }
  }

  Future<File> _writeExportFile({
    required Uint8List bytes,
    required String fileName,
    bool durable = false,
  }) async {
    final Directory base;
    if (durable) {
      base = await getApplicationDocumentsDirectory();
    } else {
      base = await getTemporaryDirectory();
    }
    final folder = Directory(
      durable ? '${base.path}/exports' : '${base.path}/shares',
    );
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    final safeName = fileName.replaceAll(RegExp(r'[^\w.\-]+'), '_');
    final path = durable
        ? '${folder.path}/$safeName'
        : '${folder.path}/${const Uuid().v4()}_$safeName';
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> _delayedDelete(File file) async {
    try {
      await Future<void>.delayed(const Duration(minutes: 5));
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  Future<Result<void>> shareText(String text) async {
    try {
      await SharePlus.instance.share(ShareParams(text: text));
      return const Ok(null);
    } catch (_) {
      return const Err(AppFailure(AppFailureCode.shareFailed));
    }
  }
}

class GallerySaveService {
  Future<Result<void>> saveImageBytes(
    Uint8List bytes, {
    required String name,
  }) async {
    try {
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: true);
        if (!granted) {
          return const Err(AppFailure(AppFailureCode.saveFailed));
        }
      }
      // Gal.putImageBytes appends its own extension — pass stem only.
      await Gal.putImageBytes(bytes, name: _galleryNameStem(name));
      return const Ok(null);
    } catch (_) {
      return const Err(AppFailure(AppFailureCode.saveFailed));
    }
  }

  /// Strips a known image extension so Gal does not produce `file.png.png`.
  static String _galleryNameStem(String name) {
    final lower = name.toLowerCase();
    for (final ext in const ['.png', '.jpg', '.jpeg', '.webp', '.gif', '.heic']) {
      if (lower.endsWith(ext)) {
        return name.substring(0, name.length - ext.length);
      }
    }
    return name;
  }
}
