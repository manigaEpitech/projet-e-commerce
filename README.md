# 🛒 Application E-Commerce Flutter - Certification Riverpod

Ce projet est une application mobile de commerce électronique hautement découplée appliquant les principes de clean architecture et de gestion d'état réactive.

## 📐 Architecture du Projet (Layer-First)
- **`domain/`** : Entités et modèles métiers immuables (`Product`, `CartItem`, `UserProfile`) avec surcharges d'égalité.
- **`data/`** : Gestion des services d'infrastructure et dépôts. L'accès au stockage local est abstrait via l'interface contractuelle `ILocalStorageService`.
- **`presentation/`** : Logique d'état unifiée Riverpod et composants d'interface Flutter réactifs.

## 📊 Gestion des Fournisseurs d'État
1. **`profileProvider`** : Pilotage du compte utilisateur persistant.
2. **`productsProvider`** : Récupération asynchrone sécurisée.
3. **`filterProvider`** : Mémorisation des tris et critères.
4. **`filteredProductsProvider`** : Combinaison et transformation synchrone des états de données.
5. **`cartProvider`** : Gestion du panier d'achat.
6. **`favoritesProvider`** : Système de favoris persistant couplé au dépôt de stockage local.
