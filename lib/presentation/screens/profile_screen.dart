import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/filter_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profile.avatarUrl),
              ),
              const SizedBox(height: 20),
              Text(
                profile.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(profile.email, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => ref
                    .read(profileProvider.notifier)
                    .updateName('Maniga Tokpa (Édité)'),
                child: const Text('Modifier le nom'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
