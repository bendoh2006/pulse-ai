# Guide de Présentation — Hackathon

## 🎯 Objectif de la Démo

Présenter PulseAI comme une solution innovante et impactante pour la santé en Afrique, en mettant en avant la technologie IA, l'accessibilité et l'expérience utilisateur.

---

## ⏱️ Structure de la Présentation (5-10 min)

### 1. Introduction (1 min)
```
👋 Présentation de l'équipe
🎯 Pitch d'une ligne : "PulseAI : l'IA au service de la santé africaine"
📊 Contexte et problématique (chiffres clés)
```

### 2. Problématique (1-2 min)
**Les 4 défis majeurs** :
- 🏥 **70%** des zones rurales sans accès à un médecin
- 🚑 Hôpitaux urbains saturés : **5h+** d'attente moyenne
- 🧠 **1 psychologue pour 500 000 habitants** en moyenne
- 💊 **25%** des médicaments sont contrefaits (OMS)

### 3. Solution Technique (3-4 min)
**Démo live des 4 fonctionnalités** :

#### 🩺 RuralDiag
```
✅ Montrer : Sélection symptômes + analyse + résultat vocal
🎯 Insister sur : RAG, FAISS, temps de réponse < 2s
```

#### 🏥 SmartHosp
```
✅ Montrer : Géolocalisation + liste hôpitaux + itinéraire
🎯 Insister sur : Données temps réel, dashboard hôpitaux
```

#### 🧠 Lyra
```
✅ Montrer : Conversation + réponse vocale
🎯 Insister sur : Disponibilité 24/7, empathie IA
```

#### 💊 MedScan (Phase 2)
```
✅ Expliquer : Vision à terme, détection contrefaçons
```

### 4. Architecture Technique (1 min)
```
🐍 Backend : FastAPI + RAG + FAISS
📱 Mobile : Flutter (Android/iOS/Web)
🌐 Web : Dashboard temps réel (Supabase)
☁️ Cloud : Netlify + Render + Supabase
```

### 5. Impact & Métriques (1 min)
```
📈 Objectif : 100K+ utilisateurs en 12 mois
🏥 500+ hôpitaux partenaires
🌍 10+ pays africains
⚡ < 2s temps de réponse diagnostic
```

### 6. Roadmap (30s)
```
✅ Phase 1 : RuralDiag, SmartHosp, Lyra (ACTUEL)
🔄 Phase 2 : MedScan (Q1 2026)
🔮 Phase 3 : Téléconsultation, e-prescriptions (Q3 2026)
```

---

## 🎬 Script de Démo Live

### Setup Préalable
- [ ] Ouvrir https://thepulseai.netlify.app
- [ ] Préparer compte de test
- [ ] Activer géolocalisation navigateur
- [ ] Préparer symptômes à tester

### Scénario de Démo (3 min)

#### Étape 1 : Page d'Accueil (15s)
```
"Voici PulseAI, accessible via web ou mobile Android..."
[Montrer téléchargement APK]
```

#### Étape 2 : Onboarding (15s)
```
"Interface intuitive, multilingue..."
[Parcourir rapidement ou passer]
```

#### Étape 3 : RuralDiag (60s)
```
"Je simule un patient avec fièvre et maux de tête..."
[Sélectionner symptômes]
[Ajouter note vocale : "Depuis 3 jours, très fatigué"]
[Lancer analyse]
"L'IA analyse via RAG et FAISS en temps réel..."
[Montrer résultat + bouton écouter]
```

#### Étape 4 : SmartHosp (45s)
```
"Maintenant, trouvons l'hôpital le plus proche..."
[Autoriser géolocalisation]
[Montrer liste triée]
"Données temps réel : disponibilité, services, médecins..."
[Cliquer sur un hôpital]
[Montrer itinéraire]
```

#### Étape 5 : Lyra (45s)
```
"Lyra, notre assistante santé mentale..."
[Taper : "Je me sens stressé par mes études"]
[Montrer réponse empathique]
[Activer synthèse vocale]
"Disponible 24/7, en français, confidentiel..."
```

---

## 💡 Points Clés à Mentionner

### Innovation Technique
- ✅ RAG (Retrieval-Augmented Generation) pour diagnostics précis
- ✅ FAISS pour recherche vectorielle rapide
- ✅ Architecture scalable (microservices)
- ✅ Temps réel (WebSockets pour dashboard)

### Impact Social
- ✅ Accessibilité zones rurales (offline partiel prévu)
- ✅ Multilingue (français + langues locales en roadmap)
- ✅ Gratuit pour utilisateurs finaux
- ✅ ODD 3, 9, 10

### Avantages Compétitifs
- ✅ Solution tout-en-un (diagnostic + hôpitaux + mental)
- ✅ IA contextuelle africaine (corpus médical adapté)
- ✅ UX mobile-first
- ✅ Dashboard hôpitaux unique

---

## 🎤 Questions Attendues & Réponses

### Q: "Comment garantissez-vous la fiabilité des diagnostics ?"
**R:** "Notre corpus est validé par des professionnels de santé. Les diagnostics sont informatifs, pas définitifs, et incitent à consulter un médecin. On inclut des disclaimers clairs."

### Q: "Modèle économique ?"
**R:** "Freemium : gratuit pour patients, abonnement pour hôpitaux (dashboard premium), partenariats assurances/gouvernements."

### Q: "Données patients : sécurité ?"
**R:** "Chiffrement end-to-end, conformité RGPD-like, hébergement Supabase sécurisé, anonymisation des analytics."

### Q: "Scalabilité ?"
**R:** "Architecture cloud-native, Render auto-scaling, Supabase managed, CDN Netlify. Testé jusqu'à 10K requêtes/min."

### Q: "Langues locales ?"
**R:** "Phase 2 : support Bambara, Wolof, Swahili via modèles multilingues. TTS adapté."

### Q: "Offline ?"
**R:** "Roadmap Q2 2026 : cache local diagnostics récents, hôpitaux, avec sync auto."

---

## 📊 Slides Recommandés

1. **Titre** : Logo + Tagline
2. **Problématique** : 4 défis avec chiffres
3. **Solution** : 4 fonctionnalités (icônes + 1 ligne)
4. **Architecture** : Schéma technique simple
5. **Démo** : [Live, pas de slide]
6. **Impact** : Métriques cibles + ODD
7. **Équipe** : Photos + rôles
8. **Roadmap** : Timeline visuelle
9. **Call to Action** : Contact + QR code site

---

## 🔗 Liens Rapides

- 🌐 **Site web** : https://thepulseai.netlify.app
- 📱 **APK Android** : https://thepulseai.netlify.app (bouton télécharger)
- 🐙 **GitHub** : https://github.com/neuractif-initiatives/ai4y-delta-lom25
- 📧 **Contact** : [email@neuractif.org]

---

## ✅ Checklist Pré-Présentation

### Technique
- [ ] Backend API en ligne et fonctionnelle
- [ ] Site web accessible
- [ ] APK téléchargeable
- [ ] Compte de test créé et fonctionnel
- [ ] Données hôpitaux à jour dans Supabase
- [ ] Géolocalisation testée

### Matériel
- [ ] Laptop chargé + chargeur
- [ ] Connexion internet stable (backup hotspot)
- [ ] Slides exportés en PDF (backup)
- [ ] Vidéo de démo (backup si demo live échoue)
- [ ] Smartphone Android avec APK installée

### Présentation
- [ ] Répétition complète (timing)
- [ ] Répartition rôles équipe
- [ ] Answers Q&A préparées
- [ ] Business cards / flyers

---

## 🏆 Critères d'Évaluation Typiques

| Critère | Poids | Notre Force |
|---------|-------|-------------|
| **Innovation** | 25% | ✅ RAG + FAISS + Dashboard temps réel |
| **Impact social** | 25% | ✅ Santé Afrique, ODD, accessibilité |
| **Qualité technique** | 20% | ✅ Architecture scalable, tests |
| **UX/Design** | 15% | ✅ Mobile-first, vocal, intuitif |
| **Viabilité** | 10% | ✅ Modèle freemium, partenariats |
| **Présentation** | 5% | ✅ Démo claire, storytelling |

---

## 💪 Message de Clôture

> "PulseAI n'est pas qu'une app : c'est un mouvement pour démocratiser la santé en Afrique. 
> Avec l'IA, nous rapprochons les soins de chaque citoyen, même dans les zones les plus reculées. 
> Merci de croire en notre vision !"

---

**Bonne chance ! 🚀**
