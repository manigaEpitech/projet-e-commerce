import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_shop/data/local_storage_service.dart';
import 'package:my_shop/presentation/providers/filter_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tests d\'état Riverpod', () {
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

    test('Le filtre par défaut doit être à Tous et aucun tri', () {
      final state = container.read(filterProvider);
      expect(state.category, 'Tous');
      expect(state.sort, isNotNull);
    });

    test('Changer la catégorie doit modifier correctement l\'état', () {
      container.read(filterProvider.notifier).setCategory('Sport');
      expect(container.read(filterProvider).category, 'Sport');
    });
  });
}
