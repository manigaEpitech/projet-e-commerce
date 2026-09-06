import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(
    // Indispensable pour initialiser Riverpod
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Riverpod Shop',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const CatalogScreen(),
    );
  }
}
