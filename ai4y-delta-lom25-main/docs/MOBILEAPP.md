# Application Mobile (Flutter)

## Aperçu
Application multiplateforme pour accéder aux fonctionnalités: RuralDiag, SmartHosp, Lyra, MedScan (à venir).

## Structure
- Dossier: `MOBILEAPP/pulseai/`
- `lib/` — UI, navigation, services
- `android/`, `ios/`, `web/` — plateformes

## Prérequis
- Flutter 3+
- Android SDK, iOS SDK (optionnel)

## Lancement
```bash
cd MOBILEAPP/pulseai
flutter pub get
flutter run
```

## Configuration
- Intégrer clés Firebase/Supabase selon plateformes
- Mettre à jour `local.properties` Android

## Fonctionnalités
- Onboarding, Auth, Accueil, Diagnostic, Hôpitaux, Lyra, Paramètres

## Build Release
```bash
flutter build apk --release
```
