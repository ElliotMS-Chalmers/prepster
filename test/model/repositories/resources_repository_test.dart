import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepster/model/repositories/resources_repository.dart';

void main() {
  group('ResourcesRepository Tests', () {

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            MethodChannel('logger'),
            (MethodCall methodCall) async => null,
          );
    });

    test('ResourcesRepository loads English files', () async {
      final repository = await ResourcesRepository.create('en');
      expect(repository.data.isNotEmpty, true);

      for (final item in repository.data) {
        expect(item.length, 2); // Each item should be [name, filepath]
        final name = item[0];
        final filepath = item[1];

        expect(filepath.contains('_en_'), true);
        expect(filepath.startsWith('assets/resources/'), true);
        expect(filepath.endsWith('.pdf'), true);
        expect(name, isNotNull);
        expect(name.isNotEmpty, true);
      }
    });

    test('ResourcesRepository loads Swedish files', () async {
      final repository = await ResourcesRepository.create('sv');
      expect(repository.data.isNotEmpty, true);

      for (final item in repository.data) {
        expect(item.length, 2); // Each item should be [name, filepath]
        final filepath = item[1];

        expect(filepath.contains('_sv_'), true);
        expect(filepath.startsWith('assets/resources/'), true);
        expect(filepath.endsWith('.pdf'), true);
      }
    });

    test('ResourcesRepository can change language', () async {
      final repository = await ResourcesRepository.create('en');

      final englishCount = repository.data.length;
      final englishFirstFilepath =
          repository.data.isNotEmpty ? repository.data[0][1] : '';

      await repository.changeLanguage('sv');
      final swedishCount = repository.data.length;

      expect(swedishCount, greaterThan(0));

      for (final item in repository.data) {
        final filepath = item[1];
        expect(filepath.contains('_sv_'), true);
      }

      // If we had English data, verify it actually changed
      if (englishFirstFilepath.isNotEmpty) {
        // Either the file path changed or the count is different
        if (repository.data.isNotEmpty) {
          expect(
            repository.data[0][1] != englishFirstFilepath ||
                englishCount != swedishCount,
            true,
          );
        }
      }
    });

    test('ResourcesRepository extracts file names correctly', () async {
      final repository = await ResourcesRepository.create('en');

      for (final item in repository.data) {
        final name = item[0];

        expect(name.contains('_en_'), false);
        expect(name.contains('.pdf'), false);

        // Should not contain the numeric prefix
        expect(RegExp(r'^\d+_').hasMatch(name), false);
      }
    });
  });
}
