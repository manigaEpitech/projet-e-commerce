import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../utils/product_sort_item.dart';






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

