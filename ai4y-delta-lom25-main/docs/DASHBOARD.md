# Dashboard Web (SmartHosp)

## Objectif
Permettre aux hôpitaux de s’inscrire, publier leurs disponibilités (lits, services, médecins), et envoyer les mises à jour en temps réel vers l’application.

## Structure
- Dossier: `DASHBOARD WEB PULSEAI/`
- Pages: `public/*.html`, `public/src/*.js`, `src/*.js`
- Config: `public/src/config.js`, `src/config.js` (Supabase, endpoints)
- Déploiement: Netlify (`netlify.toml`)

## Fonctionnalités
- Authentification (Supabase)
- Formulaires d’inscription établissement
- Publication des disponibilités en temps réel
- Liste des hôpitaux triée par distance et capacité

## Installation
```bash
cd "DASHBOARD WEB PULSEAI"
npm install
npm run dev
```

## Configuration
- Renseigner `SUPABASE_URL`, `SUPABASE_ANON_KEY` dans `config.js`
- Définir règles de sécurité côté Supabase (RLS)

## Déploiement Netlify
- Branch principale: `main`
- Fichier `netlify.toml` pour redirections et builds

## Sécurité
- Valider et assainir les formulaires
- RLS et politiques de tables (lecture publique, écriture limitée)
