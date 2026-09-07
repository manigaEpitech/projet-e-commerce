import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop/presentation/providers/filter_provider.dart';

import '../../../domain/product.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Votre Panier')),
      body: cart.isEmpty
          ? const Center(child: Text('Le panier est vide.'))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart.values.toList()[index];
                return CartItemTile(
                  item: item,
                ); // Utilisation du composant extrait
              },
            ),
    );
  }
}

/// Widget réutilisable extrait pour l'affichage d'un élément du panier
class CartItemTile extends ConsumerWidget {
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(item.product.title),
      subtitle: Text('${item.totalPrice.toStringAsFixed(2)} €'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => ref
                .read(cartProvider.notifier)
                .updateQuantity(item.product.id, item.quantity - 1),
          ),
          Text('${item.quantity}'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => ref
                .read(cartProvider.notifier)
                .updateQuantity(item.product.id, item.quantity + 1),
          ),
        ],
      ),
    );
  }
}
