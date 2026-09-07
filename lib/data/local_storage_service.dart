import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service responsable de la persistance locale des données de l'application.
class LocalStorageService {
  final SharedPreferences _prefs;
  static const String _favKey = 'favorite_products';

  LocalStorageService(this._prefs);

  /// Récupère la liste des IDs favoris sauvegardés.
  Set<String> getFavorites() {
    final List<String>? favList = _prefs.getStringList(_favKey);
    return favList?.toSet() ?? {};
  }

  /// Sauvegarde la liste mise à jour des IDs favoris.
  Future<void> saveFavorites(Set<String> favorites) async {
    await _prefs.setStringList(_favKey, favorites.toList());
  }
}

/// Fournisseur d'accès synchrone au stockage local.
/// Initialisé dans le main.dart avant le lancement de l'application.
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('Le service doit être surchargé dans le ProviderScope');
});
