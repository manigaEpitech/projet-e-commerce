import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop/presentation/favorites_provider.dart';
import 'package:my_shop/presentation/profile_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_shop/data/local_storage_service.dart';


void main() {
  // Nécessaire pour initialiser l'environnement de test Flutter avant d'appeler les mocks
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tests Unitaires - Favoris & Profil', () {
    late ProviderContainer container;

    setUp(() async {
      // Configure les valeurs par défaut de SharedPreferences en mémoire (ici un dictionnaire vide)
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      container = ProviderContainer(
        overrides: [
          localStorageServiceProvider.overrideWithValue(LocalStorageService(sharedPreferences)),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Le favorisProvider doit être initialement vide', () {
      final favorites = container.read(favoritesProvider);
      expect(favorites.isEmpty, true);
    });

    test('Activer un favori doit l\'ajouter à l\'état', () {
      // Ajouter le produit 'prod_abc' en favori
      container.read(favoritesProvider.notifier).toggleFavorite('prod_abc');
      
      // Vérification de l'état en mémoire
      final favorites = container.read(favoritesProvider);
      expect(favorites.contains('prod_abc'), true);
    });

    test('Modifier le nom du profil doit mettre à jour correctement l\'état UserProfile', () {
      final initialProfile = container.read(profileProvider);
      expect(initialProfile.name, 'Maniga Tokpa');

      // Déclenchement de la modification
      container.read(profileProvider.notifier).updateName('Jean Dupont');
      
      final updatedProfile = container.read(profileProvider);
      expect(updatedProfile.name, 'Jean Dupont');
      expect(updatedProfile.email, 'maniga.tokpa@example.com');
    });
  });
}
