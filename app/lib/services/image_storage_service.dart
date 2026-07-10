import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SavedImagePaths {
  final String originalPath;
  final String thumbnailPath;
  const SavedImagePaths({
    required this.originalPath,
    required this.thumbnailPath,
  });
}

/// Persists cropped punch PNGs under the app's documents directory (F5.1)
/// and derives a downscaled thumbnail for grid views (F2.6).
class ImageStorageService {
  static const int _thumbnailWidth = 320;

  Future<Directory> _imagesDir(String subfolder) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'images', subfolder));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<SavedImagePaths> saveCroppedImage(
    Uint8List pngBytes,
    String itemId,
  ) async {
    final originalsDir = await _imagesDir('originals');
    final originalFile = File(p.join(originalsDir.path, '$itemId.png'));
    await originalFile.writeAsBytes(pngBytes, flush: true);

    final thumbsDir = await _imagesDir('thumbnails');
    final thumbFile = File(p.join(thumbsDir.path, '$itemId.png'));
    final decoded = img.decodePng(pngBytes);
    final thumbBytes = decoded == null
        ? pngBytes
        : Uint8List.fromList(
            img.encodePng(img.copyResize(decoded, width: _thumbnailWidth)),
          );
    await thumbFile.writeAsBytes(thumbBytes, flush: true);

    return SavedImagePaths(
      originalPath: originalFile.path,
      thumbnailPath: thumbFile.path,
    );
  }

  Future<void> deleteImages(SavedImagePaths paths) async {
    for (final path in [paths.originalPath, paths.thumbnailPath]) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
