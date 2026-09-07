import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_shop/data/local_storage_service.dart';
import 'package:my_shop/presentation/providers/filter_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tests Unitaires - Providers', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      container = ProviderContainer(
        overrides: [
          localStorageServiceProvider.overrideWithValue(
            LocalStorageService(prefs),
          ),
        ],
      );
    });

    tearDown(() => container.dispose());

    test(
      'Le profil doit initialiser son état par défaut et se mettre à jour',
      () {
        expect(container.read(profileProvider).name, 'Maniga Tokpa');
        container.read(profileProvider.notifier).updateName('Jean');
        expect(container.read(profileProvider).name, 'Jean');
      },
    );

    test('Le filtre doit réagir aux modifications', () {
      expect(container.read(filterProvider).category, 'Tous');
      container.read(filterProvider.notifier).setCategory('Sport');
      expect(container.read(filterProvider).category, 'Sport');
    });
  });
}
