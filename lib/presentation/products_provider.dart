import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/product_repository.dart';
import '../domain/product.dart';
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
