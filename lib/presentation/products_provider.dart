import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../utils/product_sort_item.dart';

// 1. provider products (FutureProvider)
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchProducts();
});

// 2 provider filter (stateProvider & provider combined)
class ProductFilterState {
  final String? category;
  final ProductSort sort;

  ProductFilterState({this.category = 'Tous', this.sort = ProductSort.none});

  ProductFilterState copyWith({String? category, ProductSort? sort}) {
    return ProductFilterState(
      category: category ?? this.category,
      sort: sort ?? this.sort,
    );
  }
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

// flitrage logique comnbine
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final filter = ref.watch(filterProvider);

  return productsAsync.whenData((products) {
    List<Product> list = List.from(products);

    if (filter.category != null && filter.category != 'Tous') {
      list = list
          .where((product) => product.category == filter.category)
          .toList();
    }

    if (filter.sort == ProductSort.priceAsc) {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (filter.sort == ProductSort.priceDesc) {
      list.sort((a, b) => b.price.compareTo(a.price));
    } else if (filter.sort == ProductSort.nameAsc) {
      list.sort((a, b) => a.title.compareTo(b.title));
    } else if (filter.sort == ProductSort.nameDesc) {
      list.sort((a, b) => b.title.compareTo(a.title));
    }
    return list;
  });
});

// 3. provider panier (StateNotifierProvider)
class CartNotifier extends StateNotifier<Map<String, CartItem>> {
  CartNotifier() : super({});

  void addProduct(Product product) {
    if (state.containsKey(product.id)) {
      state = {
        ...state,
        product.id: CartItem(
          product: product,
          quantity: state[product.id]!.quantity + 1,
        ),
      };
    } else {
      state = {...state, product.id: CartItem(product: product, quantity: 1)};
    }
  }

  void removeFromCart(String productId) {
    if (state.containsKey(productId)) {
      final currentQuantity = state[productId]!.quantity;
      if (currentQuantity > 1) {
        state = {
          ...state,
          productId: CartItem(
            product: state[productId]!.product,
            quantity: currentQuantity - 1,
          ),
        };
      } else {
        final newState = Map<String, CartItem>.from(state);
        newState.remove(productId);
        state = newState;
      }
    }
  }

  void updateQuantity(String productId, int quantity) {
    if (state.containsKey(productId)) {
      if (quantity > 0) {
        state = {
          ...state,
          productId: state[productId]!.copyWith(quantity: quantity),
        };
      }
    }
  }

  void clearCart() {
    state = {};
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, CartItem>>(
  (ref) => CartNotifier(),
);

// 4. FOURNISSEUR FAVORIS LOCAL (StateNotifierProvider)
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = Set.from(state)..remove(productId);
    } else {
      state = Set.from(state)..add(productId);
    }
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);

// 5. Profil PROOVIDER (stateProvider)
class UserProfile {
  final String name;
  final String email;

  UserProfile({required this.name, required this.email});
}

final userProfileProvider = StateProvider<UserProfile>((ref) {
  return UserProfile(name: 'Maniga Tokpa', email: 'maniga.tokpa@example.com');
});
