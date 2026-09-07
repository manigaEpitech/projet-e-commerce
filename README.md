# 🛒 Application E-Commerce Flutter (Riverpod Certifié)

Ce projet est une application mobile de commerce électronique hautement découplée et robuste intégrant la persistance des données locales et une architecture moderne.

## 📐 Architecture Applicative (Layer-First)
Le projet applique le modèle architectural en couches strictes :
- **`domain/`** : Définition des entités métier pures (`Product`, `CartItem`, `UserProfile`) avec immuabilité intégrée.
- **`data/`** : Couche de persistance et communication (Dépôt JSON simulé avec images dynamiques réelles et service de stockage asynchrone `SharedPreferences`).
- **`presentation/`** : Logique d'état centralisée et composants UI réactifs.

## 📊 Solution de Gestion d'État (Providers mis en place)
1. **`profileProvider`** : Gère l'affichage dynamique et la mutation du profil utilisateur.
2. **`productsProvider`** : Récupère et expose la liste brute des produits sous forme asynchrone (`AsyncValue`).
3. **`filterProvider`** : Mémorise et orchestre les critères de tri (prix, nom) et de filtrage (catégories).
4. **`filteredProductsProvider`** : Combine les produits et filtres de façon réactive.
5. **`cartProvider`** : Gère les articles du panier de façon réactive.
6. **`favoritesProvider`** : Aligne l'état en mémoire avec une persistance sur disque.
