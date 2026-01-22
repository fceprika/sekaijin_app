import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/services/image_compression_service.dart';

void main() {
  group('ImageCompressionService', () {
    late ImageCompressionService service;

    setUp(() {
      service = ImageCompressionService();
    });

    test('has correct max width setting', () {
      expect(ImageCompressionService.maxWidth, 1920);
    });

    test('has correct max height setting', () {
      expect(ImageCompressionService.maxHeight, 1920);
    });

    test('has correct quality setting', () {
      expect(ImageCompressionService.quality, 80);
    });

    test('compressImages returns empty list for empty input', () async {
      final result = await service.compressImages([]);
      expect(result, isEmpty);
    });
  });
}
