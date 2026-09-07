
import 'package:flutter_riverpod/legacy.dart';
import '../../data/local_storage_service.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final LocalStorageService _storageService;

  // Charge l'état initial depuis le disque dès la création du provider
  FavoritesNotifier(this._storageService)
    : super(_storageService.getFavorites());

  void toggleFavorite(String productId) {
    final newState = Set<String>.from(state);
    if (newState.contains(productId)) {
      newState.remove(productId);
    } else {
      newState.add(productId);
    }
    state = newState;
    _storageService.saveFavorites(
      state,
    ); // Sauvegarde automatique et persistante
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) {
    final storage = ref.watch(localStorageServiceProvider);
    return FavoritesNotifier(storage);
  },
);
