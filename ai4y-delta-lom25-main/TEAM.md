# 👥 Équipe PulseAI

## 🏢 Organisation

**Neuractif Initiatives**  
Organisation dédiée à l'innovation technologique pour le développement en Afrique.

---

## 🎯 Mission

Démocratiser l'accès aux soins de santé en Afrique grâce à l'intelligence artificielle, en créant des solutions accessibles, fiables et adaptées aux contextes locaux.

---

## 👨‍💻 Équipe Technique

### Chef de Projet / Architecte
**Rôle** : Vision produit, architecture globale, coordination équipe

**Responsabilités** :
- Définir la roadmap produit
- Arbitrer décisions techniques
- Coordonner les équipes (backend, frontend, mobile, IA)
- Relations avec partenaires et jurys
- Veiller à la cohérence du projet

**Compétences** :
- Architecture logicielle
- Gestion de projet agile
- Communication technique et non-technique
- Vision stratégique

---

### Ingénieur Backend
**Rôle** : API REST, services IA, infrastructure cloud

**Responsabilités** :
- Développement API FastAPI
- Intégration Mistral API et FAISS
- Pipeline RAG (diagnostic)
- Service Lyra (chat)
- Déploiement Render/Docker
- Tests et optimisation performance
- Documentation API

**Stack Technique** :
- Python (FastAPI, Pydantic)
- FAISS, Sentence Transformers
- Mistral API
- Docker, Render
- PostgreSQL, Supabase

**Livrables** :
- `backend/` — Code API
- `docs/BACKEND_ARCHITECTURE.md`
- `docs/API_REFERENCE.md`
- Tests unitaires

---

### Développeur Frontend Web
**Rôle** : Dashboard hôpitaux, site vitrine, interfaces web

**Responsabilités** :
- Dashboard web pour hôpitaux
- Page d'inscription et authentification
- Gestion disponibilités temps réel
- Liste publique hôpitaux
- Site vitrine (landing page)
- Responsive design
- Déploiement Netlify
- Intégration Supabase (auth, DB)

**Stack Technique** :
- HTML5, CSS3, JavaScript (ES6+)
- Supabase (auth, realtime, DB)
- Netlify
- APIs Geolocation, Maps

**Livrables** :
- `DASHBOARD WEB PULSEAI/` — Code dashboard
- `PulseAI Website General/` — Site vitrine
- `docs/DASHBOARD_ARCHITECTURE.md`
- Interfaces responsive

---

### Développeur Mobile
**Rôle** : Application Flutter multiplateforme

**Responsabilités** :
- App Flutter (Android, iOS, Web)
- UI/UX toutes les fonctionnalités
- Navigation et routing
- Authentification Supabase
- Intégration backend API
- Location services (géolocalisation)
- Text-to-Speech, Speech-to-Text
- Build APK/AAB release
- Tests Flutter

**Stack Technique** :
- Flutter 3.x, Dart
- Provider (state management)
- Supabase Flutter
- Geolocator, Flutter TTS
- Android SDK, iOS SDK

**Livrables** :
- `MOBILEAPP/pulseai/` — Code Flutter
- `docs/MOBILEAPP_ARCHITECTURE.md`
- APK release
- Screenshots et vidéos démo

---

### Data Scientist / Ingénieur IA
**Rôle** : Modèles IA, pipeline RAG, corpus médical

**Responsabilités** :
- Corpus médical structuré (`rag_clean.csv`)
- Embeddings et index FAISS
- Pipeline RAG (recherche sémantique)
- Prompts système (diagnostic, Lyra)
- Évaluation qualité diagnostics
- Fine-tuning modèles si besoin
- Notebooks expérimentaux

**Stack Technique** :
- Python (pandas, scikit-learn)
- Sentence Transformers
- FAISS
- Mistral API
- Jupyter Notebooks

**Livrables** :
- `Diagnostic Model/` — Corpus et index
- `CHATBOT/` — Notebooks Lyra
- `backend/prompts/` — Prompts système
- `docs/DIAGNOSTIC_MODEL.md`
- Évaluations métriques

---

## 🤝 Collaboration

### Communication

- **Daily Standups** (10 min) : Partage avancement, blocages
- **Weekly Planning** : Priorisation tâches semaine
- **Sprint Reviews** (bi-weekly) : Démo fonctionnalités
- **Rétrospectives** : Amélioration continue

### Outils

- **Code** : GitHub (version control, issues, PRs)
- **Docs** : Markdown (docs/), GitHub Wiki
- **Communication** : Discord/Slack
- **Project Management** : GitHub Projects, Trello
- **Design** : Figma (maquettes UI/UX)

### Workflow

1. **Issue** créée avec template approprié
2. **Branch** feature/fix/docs créée
3. **Développement** + commits réguliers
4. **Tests** locaux + validation
5. **PR** avec template, review par pairs
6. **Merge** après validation 2+ reviewers
7. **Deploy** automatique (main → production)

---

## 📊 Répartition du Travail

### Phase 1 : MVP (Nov-Dec 2025) ✅

| Fonctionnalité | Backend | Frontend Web | Mobile | IA/Data |
|----------------|---------|--------------|--------|---------|
| RuralDiag | ✅ API | ❌ | ✅ UI | ✅ RAG |
| SmartHosp | ✅ API | ✅ Dashboard | ✅ UI | ❌ |
| Lyra | ✅ API | ❌ | ✅ UI | ✅ Prompts |
| Auth/Profile | ✅ API | ✅ Auth | ✅ Auth | ❌ |

### Phase 2 : MedScan (Q1 2026)

| Fonctionnalité | Backend | Frontend Web | Mobile | IA/Data |
|----------------|---------|--------------|--------|---------|
| MedScan | 🔄 API | ❌ | 🔄 Camera | 🔄 Model |
| Notifications | 🔄 FCM | 🔄 Dashboard | 🔄 Push | ❌ |
| Offline Mode | ❌ | ❌ | 🔄 Cache | ❌ |

**Légende** :
- ✅ Fait
- 🔄 En cours
- ❌ Non démarré

---

## 🏆 Contributions Notables

### Version 1.0.0 (Hackathon Release)

**Chef de Projet**
- Architecture globale et coordination
- Documentation complète (README, docs/)
- Présentation jury et pitch

**Backend**
- API FastAPI unifiée (diagnostic + Lyra)
- Pipeline RAG avec FAISS
- Déploiement Render + Docker
- Tests unitaires

**Frontend Web**
- Dashboard hôpitaux avec auth Supabase
- Gestion disponibilités temps réel
- Site vitrine responsive
- Déploiement Netlify

**Mobile**
- App Flutter complète (4 fonctionnalités)
- Location services et TTS
- Build APK release
- UI/UX soignée

**IA/Data**
- Corpus médical 150+ symptômes
- Index FAISS optimisé
- Prompts système Lyra
- Notebooks expérimentaux

---

## 📞 Contact Équipe

### Interne
- **Slack** : `#pulseai-general`, `#pulseai-dev`, `#pulseai-design`
- **GitHub** : [@neuractif-initiatives/pulseai-team](https://github.com/orgs/neuractif-initiatives/teams/pulseai-team)
- **Email** : team@pulseai.neuractif.org

### Externe
- **Support** : support@pulseai.neuractif.org
- **Partenariats** : partnerships@pulseai.neuractif.org
- **Presse** : press@pulseai.neuractif.org

---

## 🌟 Rejoindre l'Équipe

Nous recrutons activement pour Phase 2 :

**Postes Ouverts** :
- Ingénieur DevOps (Kubernetes, CI/CD)
- UI/UX Designer (Figma, mobile-first)
- QA Engineer (tests automatisés, E2E)
- Data Engineer (pipelines, ETL)
- Community Manager (réseaux sociaux, contenus)

**Process de Recrutement** :
1. Candidature via email (CV + portfolio)
2. Entretien technique (1h)
3. Test pratique (mini-projet)
4. Entretien culture fit
5. Onboarding 2 semaines

**Envoyer candidatures à** : jobs@neuractif.org

---

## 🙏 Remerciements

### Mentors & Advisors
- **Dr. [Nom]** — Expertise médicale, validation corpus
- **[Nom]** — Architecture cloud et scalabilité
- **[Nom]** — IA et NLP pour santé

### Partenaires
- **Mistral AI** — Accès API et support technique
- **Supabase** — Hébergement DB/Auth
- **Render** — Hébergement backend
- **Netlify** — Hébergement web

### Testeurs Beta
- Communauté de 50+ testeurs ayant fourni feedback précieux

---

## 📄 Licence

Code sous **MIT License** — voir [LICENSE](LICENSE)

Contributions acceptées sous mêmes termes.

---

<div align="center">

**Ensemble, révolutionnons la santé en Afrique 🚀**

**Fait avec ❤️ par l'équipe PulseAI**

[⬆ Retour en haut](#-équipe-pulseai)

</div>
