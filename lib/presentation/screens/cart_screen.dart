import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Panier')),
      body: cart.isEmpty
          ? const Center(child: Text('Panier vide'))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart.values.toList()[index];
                return ListTile(
                  title: Text(item.product.title),
                  subtitle: Text('${item.totalPrice.toStringAsFixed(2)} €'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.remove), onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity - 1)),
                      Text('${item.quantity}'),
                      IconButton(icon: const Icon(Icons.add), onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity + 1)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
