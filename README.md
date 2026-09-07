# 🛒 Flutter Riverpod E-Commerce Application

Application mobile d'e-commerce moderne conçue avec **Flutter** et s'appuyant sur **Riverpod** comme solution de gestion d'état centralisée et découplée.

## 📐 Architecture du Projet

Le projet respecte une architecture en couches stricte de type **Layer-First** afin de garantir la testabilité, la maintenabilité et une séparation claire des responsabilités :

- **`data/`** : Gestion des sources de données de l'application (Dépôt distant simulé via désérialisation JSON, gestionnaire de stockage persistant sur le disque local `SharedPreferences`).
- **`domain/`** : Contient les entités métiers pures de confiance (`Product`, `CartItem`, `UserProfile`) découplées de toute logique applicative.
- **`utils/`** : Outils partagés, structures de données transverses et énumérations (`ProductSort`).
- **`presentation/`** :
  - **`providers/`** : Couche logique métier intermédiaire via la mise en place de 5 fournisseurs d'état exclusifs Riverpod interconnectés.
  - **`screens/`** : Déclaration des composants graphiques UI sans état interne.

## 📊 Gestion de l'état (Mise en œuvre de 5 Fournisseurs)

1. **`productsFutureProvider`** (`FutureProvider`) : Effectue l'acquisition asynchrone des données produits depuis l'API simulée et expose l'état via un wrapper sécurisé `AsyncValue`.
2. **`filterProvider`** (`StateNotifierProvider`) : Orchestre l'état des filtres sélectionnés (Catégorie courante et stratégie de tri sélectionnée).
3. **`filteredProductsProvider`** (`Provider`) : Fournisseur de calcul combiné. Il réagit instantanément aux mutations conjointes du catalogue de produits et des filtres de tris pour exposer une liste ordonnée en temps réel.
4. **`cartProvider`** (`StateNotifierProvider`) : Pilote le dictionnaire d'articles du panier d'achat (Ajout de produits, calculs des sommes totales, modifications incrémentales des volumes).
5. **`favoritesProvider`** (`StateNotifierProvider`) : Gère la collection d'identifiants de produits marqués comme favoris par l'utilisateur.

## 💾 Persistance des données locales

Le système de favoris de l'application bénéficie d'une **persistance locale intégrale et transparente**. L'état est sauvegardé de manière asynchrone sur le disque de l'appareil hôte en tirant parti du package `shared_preferences`. Lors de l'initialisation de l'application, l'état initial du `favoritesProvider` est automatiquement extrait du stockage physique.

## 🛠️ Lancement du Projet

```bash
# Récupération des dépendances requises
flutter pub get

# Lancement des tests unitaires et d'interface
flutter test

# Exécution de l'application en mode développement
flutter run
```
