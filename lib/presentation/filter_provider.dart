import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/product_repository.dart';
import '../../domain/product.dart';
import '../../utils/product_sort_item.dart';

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
}

class FilterNotifier extends StateNotifier<ProductFilterState> {
  FilterNotifier() : super(ProductFilterState());

  void setCategory(String category) =>
      state = state.copyWith(category: category);
  void setSort(ProductSort sort) => state = state.copyWith(sort: sort);
}

final filterProvider =
    StateNotifierProvider<FilterNotifier, ProductFilterState>((ref) {
      return FilterNotifier();
    });

/// Fournisseur combinant l'état asynchrone des produits avec les filtres sélectionnés.
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsFutureProvider);
  final filter = ref.watch(filterProvider);

  return productsAsync.whenData((products) {
    List<Product> list = List.from(products);

    // 1. Logique de filtrage par catégorie
    if (filter.category != 'Tous') {
      list = list
          .where((product) => product.category == filter.category)
          .toList();
    }

    // 2. Logique de tri complète et robuste (Règle le problème de tri incomplet)
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

final productsFutureProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(productRepositoryProvider).fetchProducts();
});
