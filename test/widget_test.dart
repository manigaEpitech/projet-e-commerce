import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_shop/data/local_storage_service.dart';
import 'package:my_shop/presentation/screens/catalog_screen.dart';

void main() {
  testWidgets('CatalogScreen doit afficher les boutons dropdown UI', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStorageServiceProvider.overrideWithValue(
            LocalStorageService(prefs),
          ),
        ],
        child: const MaterialApp(home: CatalogScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byKey(const Key('categoryDropdown')), findsOneWidget);
    expect(find.byKey(const Key('sortDropdown')), findsOneWidget);
  });
}
