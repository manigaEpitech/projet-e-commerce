import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:my_shop/presentation/products_provider.dart';
import '../models/product.dart';
import '../utils/product_sort_item.dart';

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
