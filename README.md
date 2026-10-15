# GESTAVI mobile

Application Flutter des éleveurs : relevés quotidiens, ventes, stocks et alertes, utilisable
sans réseau et synchronisée avec l'API v1 de GESTAVI (`/api/v1`).

## Pile

| Composant | Rôle |
|---|---|
| Flutter 3.47 / Dart 3.13 | Android d'abord, iOS ensuite (compilation sur Mac) |
| flutter_riverpod | État (session, contexte de travail) |
| go_router | Navigation et redirections selon la session |
| dio | Appels API, jeton porteur, erreurs traduites (`ApiException`) |
| flutter_secure_storage | Jeton d'appareil (Keystore / Keychain) |
| drift | Base locale SQLite : file de synchronisation, caches, réglages |

## Démarrer

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # après toute modification de lib/core/db/app_database.dart
flutter run --dart-define=API_URL=http://10.0.2.2:8000       # émulateur Android vers le poste de développement
flutter run --dart-define=API_URL=http://192.168.1.20:8000   # téléphone réel : adresse Wi-Fi du poste
```

Côté serveur, `php artisan serve --host=0.0.0.0` écoute sur le réseau local. Le manifeste Android
autorise le trafic en clair pour le développement ; en production l'API est en HTTPS.

## Architecture

- `lib/app` : application, thème (charte GESTAVI : vert `#15803D`, Figtree embarquée, thèmes Sous-bois et Nuit), routeur.
- `lib/core/api` : client HTTP et erreurs. `lib/core/storage` : jeton. `lib/core/db` : base locale (Drift).
  `lib/core/sync` : file des saisies hors-ligne, envoi par lots idempotent (`client_uuid`).
- `lib/features/auth` : connexion, profil et appartenances, contrôleur de session.
  `features/farm` : choix de la ferme (seulement s'il y en a plusieurs). `features/home` : accueil à onglets.

Un utilisateur appartient à une seule organisation, choisie automatiquement. Les rôles à accès global
peuvent travailler sur « toutes les fermes ».

## Tests

```bash
flutter analyze
flutter test
```

Les tests n'ont besoin ni de réseau ni d'appareil : API simulée, base locale en mémoire.

## Prochains écrans

Bandes et relevé du jour, ventes avec encaissement, stocks et sorties, alertes.
