# 🛒 Flutter E-Commerce - Riverpod

Une application e-commerce moderne et performante développée avec **Flutter** et entièrement gérée par la solution d'état **Riverpod**. Ce projet respecte une architecture en couches stricte pour séparer proprement la logique métier de l'interface utilisateur.

---

## 📋 Table des matières

- [Fonctionnalités](#-fonctionnalités)
- [Architecture du projet](#-architecture-du-projet)
- [Gestion des fournisseurs (Providers)](#-gestion-des-fournisseurs-providers)
- [Prérequis](#-prérequis)
- [Installation et lancement](#-installation-et-lancement)

---

## ✨ Fonctionnalités

- **Catalogue complet :** Affichage d'une liste de produits avec gestion fine des états de chargement et d'erreur via `AsyncValue`.
- **Détails produit :** Vue détaillée pour chaque article.
- **Panier dynamique :** Ajout, modification des quantités et suppression d'articles en temps réel.
- **Favoris locaux :** Sauvegarde et gestion du système de favoris directement sur l'appareil.
- **Tri et filtrage :** Filtrage avancé des produits pour affiner la recherche.
- **Profil utilisateur :** Écran de profil utilisateur complet (maquette).

---

## 🏗️ Architecture du projet

Le projet applique les principes de la séparation des préoccupations à travers la structure de dossiers suivante :

```text
lib/
├── main.dart
├── data/
│   └── product_repository.dart       # Simulation des données et appels API/JSON
├── domain/
│   └── product.dart                  # Modèles de données (Produit, Catégorie, etc.)
└── presentation/
    ├── providers/                    # Logique métier et gestion d'état (Riverpod)
    │   ├── cart_provider.dart
    │   ├── favorites_provider.dart
    │   ├── filter_provider.dart
    │   ├── products_provider.dart
    │   └── profile_provider.dart
    └── screens/                      # Widgets UI et Écrans de l'application
        ├── catalog_screen.dart
        ├── product_detail_screen.dart
        ├── cart_screen.dart
        └── profile_screen.dart
```

---

## 📊 Gestion des fournisseurs (Providers)

L'application utilise **5 fournisseurs distincts** pour orchestrer l'état global sans coupler les widgets à la logique de données :

1. **`productsProvider` (`FutureProvider`)** : Récupère de manière asynchrone la liste des produits depuis le dépôt de données et expose un état `AsyncValue` (Loading / Data / Error).
2. **`cartProvider` (`StateNotifierProvider`)** : Encapsule la logique du panier d'achats (calcul des totaux, incrémentation et suppression).
3. **`favoritesProvider` (`StateNotifierProvider`)** : Assure la gestion locale de la liste de souhaits.
4. **`filterProvider` (`StateProvider` / `NotifierProvider`)** : Stocke et propage les critères de filtrage et de tri appliqués au catalogue.
5. **`profileProvider` (`StateNotifierProvider`)** : Gère les informations de la maquette du profil utilisateur.

---

## 📌 Prérequis

Avant de lancer le projet, vérifiez que votre environnement dispose de :

- **Flutter SDK** : `>=3.0.0`
- **Dart SDK** : `>=3.0.0`
- Un émulateur (iOS/Android) ou un appareil physique connecté.

---

## 🛠️ Installation et lancement

1. **Cloner le dépôt**
   ```bash
   git clone https://github.com
   cd votre-projet-ecommerce
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Générer le code (si utilisation de riverpod_generator)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Lancer l'application**
   ```bash
   flutter run
   ```
