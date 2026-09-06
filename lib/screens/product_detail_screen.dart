import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/products_provider.dart';
import '../models/product.dart';

// --- lib/presentation/screens/product_detail_screen.dart ---
class ProductDetailScreen extends ConsumerWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(product.imageUrl, height: 200),
            const SizedBox(height: 20),
            Text(
              '${product.price} €',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 20),
            Text(product.description),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Ajouter au panier'),
              onPressed: () =>
                  ref.read(cartProvider.notifier).addProduct(product),
            ),
          ],
        ),
      ),
    );
  }
}

// --- lib/presentation/screens/cart_screen.dart ---
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
                return ListTile(
                  title: Text(item.product.title),
                  subtitle: Text(
                    '${(item.product.price * item.quantity).toStringAsFixed(2)} €',
                  ),
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
              },
            ),
    );
  }
}

// --- lib/presentation/screens/profile_screen.dart ---
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),
            Text(
              profile.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(profile.email),
          ],
        ),
      ),
    );
  }
}
