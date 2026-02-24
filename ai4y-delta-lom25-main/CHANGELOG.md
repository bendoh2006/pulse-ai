# 📝 Changelog — PulseAI

Toutes les modifications notables de ce projet sont documentées ici.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère à [Semantic Versioning](https://semver.org/lang/fr/).

---

## [Version 1.0.0] - 2025-12-10

### ✨ Ajouté

#### Documentation
- 📖 README.md professionnel avec badges, emojis, sections détaillées
- 📚 Documentation technique complète dans `docs/`
  - `BACKEND_ARCHITECTURE.md` — Architecture backend détaillée
  - `DASHBOARD_ARCHITECTURE.md` — Architecture dashboard web
  - `MOBILEAPP_ARCHITECTURE.md` — Architecture Flutter
  - `API_REFERENCE.md` — Référence API complète
  - `DEMO_HACKATHON.md` — Guide présentation jury
  - `INDEX.md` — Index documentation
- 🔧 Fichiers `.env.example` pour backend et dashboard
- 📋 Templates GitHub professionnels
  - Bug report, Feature request, Documentation
  - Pull request template
- 📄 `CONTRIBUTING.md`, `SECURITY.md`, `CODEOWNERS`
- 📊 `CHANGELOG.md` (ce fichier)

#### Fonctionnalités Principales

##### 1. RuralDiag (Diagnostic Intelligent)
- ✅ Sélection de symptômes (liste + vocal)
- ✅ Analyse IA avec RAG (Retrieval-Augmented Generation)
- ✅ FAISS vector search pour contexte médical
- ✅ Génération diagnostic via Mistral API
- ✅ Synthèse vocale (TTS) des résultats
- ✅ Historique des consultations

##### 2. SmartHosp (Recherche d'Hôpitaux)
- ✅ Géolocalisation automatique
- ✅ Liste hôpitaux triée par distance
- ✅ Dashboard web pour hôpitaux
- ✅ Mise à jour temps réel (Supabase Realtime)
- ✅ Affichage disponibilités (lits, services, médecins)
- ✅ Itinéraires via Maps

##### 3. Lyra (Assistant Mental Virtuel)
- ✅ Chat conversationnel empathique
- ✅ Gestion sessions persistées
- ✅ Détection émotions basique
- ✅ Synthèse vocale des réponses
- ✅ Historique conversations
- ✅ Prompt système optimisé

##### 4. MedScan (Phase 2)
- 🔄 En développement — Détection médicaments contrefaits

#### Backend (FastAPI)
- ✅ API REST unifiée (`app/main.py`)
- ✅ Service Diagnostic (`diagnostic_service.py`)
- ✅ Service Lyra (`lyra_service.py`)
- ✅ CORS configuré pour multiples origins
- ✅ Lazy loading (embedder, FAISS index)
- ✅ Tests unitaires (`test_backend.py`)
- ✅ Dockerfile production
- ✅ Configuration Render (`render.yaml`)

#### Dashboard Web
- ✅ Authentification Supabase (signup/login/logout)
- ✅ CRUD hôpitaux avec Row Level Security
- ✅ Dashboard statistiques en temps réel
- ✅ Gestion disponibilités (lits, services, médecins)
- ✅ Géolocalisation et geocoding
- ✅ Responsive design (mobile/tablet/desktop)
- ✅ Déploiement Netlify (`netlify.toml`)

#### Application Mobile (Flutter)
- ✅ Architecture Clean + Provider
- ✅ Multiplateforme (Android, iOS, Web)
- ✅ Authentification Supabase
- ✅ Navigation bottom bar
- ✅ Onboarding screens
- ✅ Location services (Geolocator)
- ✅ Text-to-Speech (Flutter TTS)
- ✅ Speech-to-Text pour diagnostic
- ✅ Build APK release

#### Déploiement
- ✅ Backend : Render (Docker)
- ✅ Dashboard : Netlify (auto-deploy)
- ✅ DB/Auth : Supabase Cloud
- ✅ Mobile : APK téléchargeable sur site

### 🔄 Modifié

- 🎨 Refonte complète UI/UX mobile
- ⚡ Optimisation performance backend (lazy loading)
- 🔒 Amélioration sécurité (RLS Supabase)
- 📱 Responsive design dashboard amélioré
- 🌐 CORS étendu pour Firebase Hosting

### 🗑️ Supprimé

- ❌ Fichiers `.md` obsolètes (archive, backups)
- ❌ Scripts de développement non nécessaires
- ❌ Fichiers `.backup`, `.tmp`, `.old`
- ❌ Documentation legacy

### 🐛 Corrigé

- 🔧 Sessions Lyra persistées correctement
- 🔧 Géolocalisation permissions Android
- 🔧 CORS issues pour domaines Firebase
- 🔧 Rate limiting implémenté
- 🔧 Validation inputs utilisateurs

### 🔐 Sécurité

- ✅ Row Level Security (RLS) Supabase
- ✅ Input validation (Pydantic, validators)
- ✅ XSS prevention (sanitization)
- ✅ Variables d'environnement pour secrets
- ✅ HTTPS only (Netlify auto)

---

## [Version 0.9.0-beta] - 2025-11-15

### ✨ Ajouté

- 🎉 Première version beta publique
- 🤖 Intégration Mistral API
- 🔍 Système RAG basique
- 📱 Prototype mobile Flutter
- 🌐 Landing page statique

### 🐛 Corrigé

- 🔧 Problèmes de performance FAISS
- 🔧 Bugs authentification

---

## [Version 0.5.0-alpha] - 2025-10-01

### ✨ Ajouté

- 🚀 POC (Proof of Concept) initial
- 🧠 Modèle diagnostic simple
- 💬 Chatbot basique
- 📊 Dashboard prototype

---

## 📋 Roadmap Prochaines Versions

### [Version 1.1.0] - Q1 2026

#### MedScan (Phase 2)
- [ ] Scan médicaments par caméra
- [ ] Détection contrefaçons IA
- [ ] Base de données médicaments certifiés
- [ ] Alertes en temps réel

#### Améliorations
- [ ] Authentification JWT backend
- [ ] Rate limiting avancé (Redis)
- [ ] Cache embeddings (Redis)
- [ ] Websockets pour chat temps réel
- [ ] Notifications push (FCM)
- [ ] Support langues locales (Bambara, Wolof, Swahili)

#### Tests & QA
- [ ] Tests end-to-end (Playwright)
- [ ] Tests de charge (Locust)
- [ ] Couverture code > 80%
- [ ] CI/CD GitHub Actions

### [Version 1.2.0] - Q2 2026

#### Fonctionnalités
- [ ] Téléconsultation vidéo
- [ ] E-prescriptions
- [ ] Historique médical cloud
- [ ] Partage dossiers entre hôpitaux
- [ ] Mode offline partiel (PWA)

#### Infrastructure
- [ ] Kubernetes deployment
- [ ] Monitoring Prometheus/Grafana
- [ ] Logs centralisés (ELK)
- [ ] Backup automatisé DB

### [Version 2.0.0] - Q3 2026

#### Expansion
- [ ] iOS App Store release
- [ ] Multi-pays (10+ pays africains)
- [ ] API publique pour partenaires
- [ ] Intégration assurances santé
- [ ] Programme gouvernements

---

## 🏷️ Versions et Tags

| Version | Date | Tag Git | Notes |
|---------|------|---------|-------|
| 1.0.0 | 2025-12-10 | `v1.0.0` | Release hackathon |
| 0.9.0-beta | 2025-11-15 | `v0.9.0-beta` | Beta publique |
| 0.5.0-alpha | 2025-10-01 | `v0.5.0-alpha` | POC initial |

---

## 📞 Contact

Pour questions sur ce changelog ou proposer des fonctionnalités :
- 🐙 [GitHub Issues](https://github.com/neuractif-initiatives/ai4y-delta-lom25/issues)
- 📧 Email : contact@neuractif.org

---

## 📄 Licence

Ce projet est sous licence **MIT** — voir [LICENSE](LICENSE) pour détails.

---

<div align="center">

**PulseAI — Fait avec ❤️ pour l'Afrique**

[⬆ Retour en haut](#-changelog--pulseai)

</div>
