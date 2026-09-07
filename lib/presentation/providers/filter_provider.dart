import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/local_storage_service.dart';
import '../../data/product_repository.dart';
import '../../domain/product.dart';
import '../../domain/user_profile.dart';
import '../../utils/product_sort_item.dart';

// 1. Profil Utilisateur
class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier()
    : super(
        UserProfile(
          name: 'Maniga Tokpa',
          email: 'maniga.tokpa@example.com',
          avatarUrl: 'assets/images/profile.jpg',
        ),
      );

  void updateName(String newName) {
    state = UserProfile(
      name: newName,
      email: state.email,
      avatarUrl: state.avatarUrl,
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>(
  (ref) => ProfileNotifier(),
);

// 2. Récupération des Produits (Nom standard unique : productsProvider)
final productsProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(productRepositoryProvider).fetchProducts();
});

// 3. Gestion de l'état des filtres
class ProductFilterState {
  final String category;
  final ProductSort sort;

  ProductFilterState({this.category = 'Tous', this.sort = ProductSort.none});

  ProductFilterState copyWith({String? category, ProductSort? sort}) {
    return ProductFilterState(
      category: category ?? this.category,
      sort: sort ?? this.sort,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductFilterState &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          sort == other.sort;

  @override
  int get hashCode => category.hashCode ^ sort.hashCode;
}

class FilterNotifier extends StateNotifier<ProductFilterState> {
  FilterNotifier() : super(ProductFilterState());

  void setCategory(String category) =>
      state = state.copyWith(category: category);
  void setSort(ProductSort sort) => state = state.copyWith(sort: sort);
}

final filterProvider =
    StateNotifierProvider<FilterNotifier, ProductFilterState>(
      (ref) => FilterNotifier(),
    );

// 4. Combinaison synchrone Filtrée et Triée
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final filter = ref.watch(filterProvider);

  return productsAsync.whenData((products) {
    List<Product> list = List.from(products);

    if (filter.category != 'Tous') {
      list = list.where((p) => p.category == filter.category).toList();
    }

    switch (filter.sort) {
      case ProductSort.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSort.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSort.nameAsc:
        list.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case ProductSort.nameDesc:
        list.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        break;
      case ProductSort.none:
        break;
    }
    return list;
  });
});

// 5. Gestionnaire du Panier
class CartNotifier extends StateNotifier<Map<String, CartItem>> {
  CartNotifier() : super({});

  void addProduct(Product product) {
    if (state.containsKey(product.id)) {
      state = {
        ...state,
        product.id: state[product.id]!.copyWith(
          quantity: state[product.id]!.quantity + 1,
        ),
      };
    } else {
      state = {...state, product.id: CartItem(product: product, quantity: 1)};
    }
  }

  void updateQuantity(String productId, int quantity) {
    if (!state.containsKey(productId)) return;
    if (quantity <= 0) {
      final newState = Map<String, CartItem>.from(state)..remove(productId);
      state = newState;
    } else {
      state = {
        ...state,
        productId: state[productId]!.copyWith(quantity: quantity),
      };
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, CartItem>>(
  (ref) => CartNotifier(),
);

// 6. Gestionnaire des Favoris avec persistance
class FavoritesNotifier extends StateNotifier<Set<String>> {
  final LocalStorageService _storageService;

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
    ); // Sauvegarde persistante immédiate sur disque
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) {
    final storage = ref.watch(localStorageServiceProvider);
    return FavoritesNotifier(storage);
  },
);
