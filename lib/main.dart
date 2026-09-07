import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/local_storage_service.dart';

import 'presentation/screens/catalog_screen.dart';

void main() async {
  // Garantir l'initialisation des liaisons Flutter avant le chargement asynchrone des SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Surcharge du fournisseur pour injecter la vraie instance de stockage persistante native
        localStorageServiceProvider.overrideWithValue(
          LocalStorageService(sharedPreferences),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const CatalogScreen(),
    );
  }
}
 