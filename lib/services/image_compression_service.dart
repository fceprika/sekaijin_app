import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressionService {
  static const int maxWidth = 1920;
  static const int maxHeight = 1920;
  static const int quality = 80;

  Future<File?> compressImage(File file) async {
    final dir = file.parent;
    final targetPath = '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.webp';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: maxWidth,
      minHeight: maxHeight,
      quality: quality,
      format: CompressFormat.webp,
    );

    if (result != null) {
      return File(result.path);
    }
    return null;
  }

  Future<List<File>> compressImages(List<File> files) async {
    final compressedFiles = <File>[];

    for (final file in files) {
      final compressed = await compressImage(file);
      if (compressed != null) {
        compressedFiles.add(compressed);
      }
    }

    return compressedFiles;
  }
}
