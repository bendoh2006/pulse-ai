# 📚 Documentation PulseAI — Index

Bienvenue dans la documentation technique complète de PulseAI.

---

## 📖 Guides Principaux

### 🏠 [README Principal](../README.md)
Vue d'ensemble du projet, problématique, solutions, tech stack, installation rapide.

### 🎯 [Guide Démo Hackathon](DEMO_HACKATHON.md)
Script de présentation, structure de pitch, scénario de démo, Q&A, checklist.

---

## 🏗️ Architecture Technique

### 🐍 [Backend Architecture](BACKEND_ARCHITECTURE.md)
**FastAPI + RAG + FAISS**
- Architecture globale et composants
- API Endpoints (Diagnostic + Lyra)
- Pipeline RAG détaillé
- Déploiement Docker/Render
- Tests et performance
- Sécurité

**Points clés** :
- Service Diagnostic (RuralDiag)
- Service Lyra (Assistant Mental)
- FAISS vector search
- Mistral API intégration

### 🌐 [Dashboard Web Architecture](DASHBOARD_ARCHITECTURE.md)
**Vanilla JS + Supabase + Netlify**
- Architecture frontend
- Authentification et gestion sessions
- CRUD hôpitaux avec RLS
- Temps réel (Supabase Realtime)
- Géolocalisation et geocoding
- Déploiement Netlify

**Points clés** :
- Dashboard hôpitaux
- Gestion disponibilités temps réel
- Liste publique hôpitaux
- Responsive design

### 📱 [Mobile App Architecture](MOBILEAPP_ARCHITECTURE.md)
**Flutter 3.x (Android, iOS, Web)**
- Clean Architecture + Provider
- Navigation et routing
- Authentification Supabase
- RuralDiag, SmartHosp, Lyra
- Location services
- Text-to-Speech
- Build & déploiement

**Points clés** :
- Multiplateforme (Android/iOS/Web)
- Provider state management
- Geolocation native
- TTS/STT intégration

---

## 📝 Documentation par Composant

### Backend

#### [Backend Général](BACKEND.md)
Aperçu rapide, structure, variables d'environnement, lancement local, tests.

#### [Backend Architecture Détaillée](BACKEND_ARCHITECTURE.md)
Documentation technique complète (voir ci-dessus).

### Dashboard Web

#### [Dashboard Général](DASHBOARD.md)
Objectif, structure, fonctionnalités, installation, configuration.

#### [Dashboard Architecture Détaillée](DASHBOARD_ARCHITECTURE.md)
Documentation technique complète (voir ci-dessus).

### Mobile App

#### [Mobile App Général](MOBILEAPP.md)
Aperçu, structure, prérequis, lancement, configuration, build release.

#### [Mobile App Architecture Détaillée](MOBILEAPP_ARCHITECTURE.md)
Documentation technique complète (voir ci-dessus).

### IA & Data

#### [Chatbot Lyra](CHATBOT_LYRA.md)
Assistant de soutien mental, prompts, notebook, intégration backend.

#### [Modèle Diagnostic](DIAGNOSTIC_MODEL.md)
RAG + FAISS, corpus médical, pipeline, limitations, mise à jour données.

---

## 🔌 API Reference

### [API Reference Complète](API_REFERENCE.md)
Documentation exhaustive des endpoints backend :
- Health check
- Diagnostic Service (symptômes, analyse)
- Lyra Service (session, chat, historique)
- Rate limiting et gestion d'erreurs
- SDKs JavaScript, Python, Dart

---

## 🚀 Guides de Démarrage Rapide

### Installation Complète

```bash
# 1. Cloner le repo
git clone https://github.com/neuractif-initiatives/ai4y-delta-lom25.git
cd ai4y-delta-lom25

# 2. Backend
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload

# 3. Dashboard Web
cd "../DASHBOARD WEB PULSEAI"
npm install
npm run dev

# 4. Mobile App
cd ../MOBILEAPP/pulseai
flutter pub get
flutter run
```

### Variables d'Environnement

- **Backend** : Voir [`backend/.env.example`](../backend/.env.example)
- **Dashboard** : Voir [`DASHBOARD WEB PULSEAI/config.example.js`](../DASHBOARD%20WEB%20PULSEAI/config.example.js)

---

## 🧪 Tests

### Backend
```bash
pytest backend/test_backend.py -v
```

### Mobile
```bash
cd MOBILEAPP/pulseai
flutter test
```

---

## 📦 Déploiement

### Backend (Render)
- Config : `backend/render.yaml`
- Dockerfile : `backend/Dockerfile`

### Dashboard (Netlify)
- Config : `DASHBOARD WEB PULSEAI/netlify.toml`
- Auto-deploy depuis `main` branch

### Mobile (APK)
```bash
cd MOBILEAPP/pulseai
flutter build apk --release
```

---

## 🤝 Contribution

### Guidelines
- [CONTRIBUTING.md](../CONTRIBUTING.md) — Process de contribution
- [SECURITY.md](../SECURITY.md) — Reporter des vulnérabilités
- [CODEOWNERS](../.github/CODEOWNERS) — Ownership du code

### Templates GitHub
- [Bug Report](../.github/ISSUE_TEMPLATE/bug_report.md)
- [Feature Request](../.github/ISSUE_TEMPLATE/feature_request.md)
- [Documentation](../.github/ISSUE_TEMPLATE/documentation.md)
- [Pull Request](../.github/PULL_REQUEST_TEMPLATE.md)

---

## 📊 Diagrammes

### Architecture Globale

```
┌─────────────────────────────────────────────────────────┐
│                    PulseAI Platform                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────┐   ┌──────────────┐   ┌────────────┐ │
│  │   Mobile     │   │  Dashboard   │   │   Website  │ │
│  │   Flutter    │   │  Vanilla JS  │   │  Vitrine   │ │
│  └──────────────┘   └──────────────┘   └────────────┘ │
│         │                   │                  │        │
│         └───────────────────┼──────────────────┘        │
│                             │                           │
│                             ▼                           │
│  ┌─────────────────────────────────────────────────┐   │
│  │          Backend API (FastAPI)                  │   │
│  │                                                 │   │
│  │  ┌─────────────┐         ┌──────────────┐     │   │
│  │  │ Diagnostic  │         │    Lyra      │     │   │
│  │  │   Service   │         │   Service    │     │   │
│  │  │  (RAG+FAISS)│         │   (Chat)     │     │   │
│  │  └─────────────┘         └──────────────┘     │   │
│  └─────────────────────────────────────────────────┘   │
│                             │                           │
│                             ▼                           │
│  ┌─────────────────────────────────────────────────┐   │
│  │              External Services                  │   │
│  │                                                 │   │
│  │  ┌──────────┐  ┌──────────┐  ┌─────────────┐  │   │
│  │  │ Supabase │  │ Mistral  │  │ Geolocation │  │   │
│  │  │ (DB+Auth)│  │   API    │  │     API     │  │   │
│  │  └──────────┘  └──────────┘  └─────────────┘  │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 🔗 Liens Utiles

### Production
- 🌐 **Site Web** : https://thepulseai.netlify.app
- 📱 **APK Android** : https://thepulseai.netlify.app (bouton télécharger)
- 🔧 **Dashboard** : https://thepulseai.netlify.app/dashboard.html

### Développement
- 🐙 **GitHub** : https://github.com/neuractif-initiatives/ai4y-delta-lom25
- 📖 **Documentation** : `/docs`
- 🧪 **Tests** : `/backend/test_backend.py`

### Services
- ☁️ **Backend API** : Render (render.com)
- 🗄️ **Database** : Supabase (supabase.com)
- 🌍 **Hosting Web** : Netlify (netlify.com)

---

## 📞 Contact & Support

### Équipe PulseAI
- **Organisation** : Neuractif Initiatives
- **Email** : [contact@neuractif.org]
- **GitHub** : [@neuractif-initiatives](https://github.com/neuractif-initiatives)

### Reporting Issues
Pour reporter un bug ou proposer une fonctionnalité :
1. Vérifier les [issues existantes](https://github.com/neuractif-initiatives/ai4y-delta-lom25/issues)
2. Créer une nouvelle issue avec le template approprié
3. Fournir un maximum de détails (environnement, étapes, captures)

---

## 📄 Licence

Ce projet est sous licence **MIT** — voir [LICENSE](../LICENSE) pour détails.

---

## 🙏 Remerciements

Merci à tous les contributeurs, jurys de hackathon, et utilisateurs qui croient en notre mission : **démocratiser la santé en Afrique grâce à l'IA**.

---

<div align="center">

**Fait avec ❤️ pour l'Afrique**

[⬆ Retour en haut](#-documentation-pulseai--index)

</div>
