import 'package:flutter_riverpod/legacy.dart';
import '../../domain/product.dart';

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

  void clearCart() => state = {};
}

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, CartItem>>(
  (ref) {
    return CartNotifier();
  },
);
