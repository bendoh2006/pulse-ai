# 🩺 Pulse AI - Santé Intelligente pour l'Afrique

![Pulse AI Banner](https://images.unsplash.com/photo-1576091160550-2173dba999ef?q=80&w=1200&auto=format&fit=crop)

## 📋 À propos

**Pulse AI** est une plateforme de santé intelligente conçue spécifiquement pour l'Afrique, combinant intelligence artificielle et accessibilité pour révolutionner l'accès aux soins de santé. Notre mission est de rendre les soins de santé plus accessibles, plus rapides et plus fiables, en particulier dans les zones rurales et mal desservies.

### 🎯 Vision

Démocratiser l'accès aux soins de santé en Afrique grâce à l'intelligence artificielle, en permettant à chacun de recevoir un diagnostic préliminaire, de trouver l'hôpital adapté et de bénéficier d'un accompagnement personnalisé.

## ✨ Fonctionnalités Principales

### 🩺 Diagnostic Intelligent
- **Analyse multimodale** : Saisie des symptômes par texte, voix ou image
- **Pré-diagnostic IA** : Analyse rapide et conseils de premiers soins
- **Recommandations personnalisées** : Suggestions adaptées à chaque situation

### 🏥 Recommandation d'Hôpitaux
- **Système de classement en temps réel** : Disponibilité des lits, médecins et spécialités
- **Géolocalisation** : Calcul de distance et itinéraire vers l'hôpital recommandé
- **Mise à jour continue** : Informations actualisées via le dashboard hôpitaux

### 💬 Chatbot & Bien-être
- **Assistant conversationnel** : Soutien mental pour les jeunes
- **Exercices de relaxation** : Techniques de gestion du stress
- **Conseils de concentration** : Méthodes pour améliorer la productivité

### 💊 Traçabilité des Médicaments *(À venir)*
- **Scan et vérification** : Authenticité des médicaments
- **Fiches d'information** : Détails complets sur les médicaments
- **Lutte contre la contrefaçon** : Protection des patients

## 🚀 Technologies Utilisées

### Frontend
- **HTML5** : Structure sémantique et accessible
- **CSS3** : Design moderne avec animations et effets glassmorphism
- **JavaScript (Vanilla)** : Interactions dynamiques sans framework lourd

### Design
- **Mobile-First** : Responsive design adapté à tous les écrans
- **Glassmorphism** : Interface moderne avec effets de transparence
- **Animations fluides** : Transitions CSS et effets visuels

### Infrastructure
- **Firebase Hosting** : Hébergement de la web app
- **Vercel** : Déploiement du dashboard hôpitaux
- **Progressive Web App (PWA)** : Fonctionnalité offline

## 📱 Démo en Ligne

- **🌐 Web App** : [pulseai-a0548.web.app](https://pulseai-a0548.web.app/#/home)
- **📊 Dashboard Hôpitaux** : [Dashboard Vercel](https://frontend-azy8j2013-light667s-projects.vercel.app/)
- **📱 APK Android** : *Lien à venir*

## 🛠️ Installation et Développement

### Prérequis
- Un navigateur web moderne (Chrome, Firefox, Safari, Edge)
- Un serveur web local (optionnel pour le développement)

### Installation Locale

1. **Cloner le dépôt**
```bash
git clone https://github.com/light667/PulseAI.git
cd PulseAI
```

2. **Ouvrir le projet**
```bash
# Option 1 : Ouvrir directement index.html dans le navigateur
open index.html

# Option 2 : Utiliser un serveur local (Python)
python3 -m http.server 8000

# Option 3 : Utiliser un serveur local (Node.js)
npx http-server -p 8000
```

3. **Accéder à l'application**
```
http://localhost:8000
```

### Structure du Projet

```
PulseAI Website/
├── index.html          # Page principale
├── styles.css          # Feuille de styles
├── script.js           # Logique JavaScript
├── logo.png           # Logo de l'application
├── page1.png          # Mockup de l'application
└── README.md          # Documentation
```

## 🎨 Personnalisation

### Variables CSS
Les couleurs et styles peuvent être modifiés dans `styles.css` :

```css
:root {
  --primary: #00A896;        /* Couleur principale */
  --primary-light: #02C39A;  /* Couleur principale claire */
  --secondary: #F28F3B;      /* Couleur secondaire */
  --accent: #FF6B9D;         /* Couleur d'accent */
  --dark: #1a3a3a;          /* Texte foncé */
  --muted: #6b7280;         /* Texte atténué */
}
```

### Configuration des Liens
Remplacez les liens de démonstration dans `index.html` :
- **APK Download** : Ligne 118
- **Web App** : Ligne 119
- **Dashboard** : Ligne 120

## 📊 Impact et Cas d'Usage

### Zones d'Impact
- ✅ **Accessibilité** : Diagnostic préliminaire sans déplacement
- ✅ **Réduction des files d'attente** : Orientation optimisée des patients
- ✅ **Confiance pharmaceutique** : Vérification de l'authenticité des médicaments
- ✅ **Santé mentale** : Accompagnement des jeunes

### Témoignages
> "Pulse AI a aidé une communauté rurale à prioriser les cas urgents et réduire les files d'attente aux urgences."
> 
> — *Centre de santé communautaire, Togo*

## 🗺️ Roadmap

### Version 1.0 (Actuelle)
- [x] Diagnostic intelligent par texte/voix/image
- [x] Recommandation d'hôpitaux en temps réel
- [x] Chatbot de bien-être
- [x] Dashboard hôpitaux
- [x] Site web vitrine

### Version 2.0 (À venir)
- [ ] Traçabilité des médicaments par scan
- [ ] Application mobile native (iOS/Android)
- [ ] Intégration de la télémédecine
- [ ] Système de rendez-vous en ligne
- [ ] Historique médical sécurisé
- [ ] Support multilingue (Français, Anglais, Langues locales)

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment participer :

1. **Fork** le projet
2. **Créer** une branche pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. **Commit** vos changements (`git commit -m 'Add some AmazingFeature'`)
4. **Push** vers la branche (`git push origin feature/AmazingFeature`)
5. **Ouvrir** une Pull Request

### Guidelines de Contribution
- Respecter le style de code existant
- Tester vos modifications sur mobile et desktop
- Documenter les nouvelles fonctionnalités
- Maintenir l'accessibilité (WCAG 2.1)

## 📄 Licence

Ce projet est sous licence **MIT**. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Équipe

### Créateur
- **Nethaniah Djossou** - *Fondateur & Développeur Principal*
  - Email: nethaniahdjossou@gmail.com
  - LinkedIn: [The PulseAI](https://www.linkedin.com/company/the-pulseai/)
  - GitHub: [@light667](https://github.com/light667)

## 📞 Contact

- **📧 Email** : nethaniahdjossou@gmail.com
- **🌐 Site Web** : [pulseai-a0548.web.app](https://pulseai-a0548.web.app)
- **💼 LinkedIn** : [Company Page](https://www.linkedin.com/company/the-pulseai/)
- **🐙 GitHub** : [Dépôt Principal](https://github.com/light667/Pulse-AI)

## 🙏 Remerciements

- Merci à tous les centres de santé partenaires en Afrique
- Communauté open-source pour les outils et bibliothèques
- Utilisateurs beta-testeurs pour leurs retours précieux
- Unsplash pour les images de démonstration

## 📈 Statistiques du Projet

![GitHub Stars](https://img.shields.io/github/stars/light667/PulseAI?style=social)
![GitHub Forks](https://img.shields.io/github/forks/light667/PulseAI?style=social)
![GitHub Issues](https://img.shields.io/github/issues/light667/PulseAI)
![GitHub License](https://img.shields.io/github/license/light667/PulseAI)

---

<p align="center">
  Fait avec ❤️ pour l'Afrique par <a href="https://github.com/light667">Nethaniah Djossou</a>
</p>

<p align="center">
  <strong>Pulse AI</strong> - La santé intelligente, accessible et humaine
</p>
