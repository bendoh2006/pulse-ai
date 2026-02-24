# 🤝 Guide de Contribution — PulseAI

Merci de votre intérêt pour contribuer à PulseAI ! Ce guide vous aidera à contribuer efficacement.

---

## 📋 Table des Matières

- [Code de Conduite](#code-de-conduite)
- [Comment Contribuer](#comment-contribuer)
- [Workflow Git](#workflow-git)
- [Conventions de Code](#conventions-de-code)
- [Tests](#tests)
- [Documentation](#documentation)

---

## 📜 Code de Conduite

En participant à ce projet, vous acceptez de respecter notre code de conduite :
- 🤝 Soyez respectueux et inclusif
- 💬 Communiquez de manière constructive
- 🎯 Concentrez-vous sur les solutions, pas les personnes
- 🌍 Respectez les différences culturelles et linguistiques

---

## 🚀 Comment Contribuer

### 1. Signaler un Bug

Utilisez le template [Bug Report](.github/ISSUE_TEMPLATE/bug_report.md) :
- Décrivez le problème clairement
- Fournissez les étapes de reproduction
- Incluez logs et captures d'écran
- Spécifiez votre environnement (OS, version, navigateur)

### 2. Proposer une Fonctionnalité

Utilisez le template [Feature Request](.github/ISSUE_TEMPLATE/feature_request.md) :
- Expliquez le problème à résoudre
- Décrivez votre solution proposée
- Évaluez l'impact utilisateurs
- Fournissez des maquettes si possible

### 3. Améliorer la Documentation

Utilisez le template [Documentation](.github/ISSUE_TEMPLATE/documentation.md) :
- Indiquez la section concernée
- Décrivez ce qui manque ou est incorrect
- Proposez une amélioration

---

## 🔀 Workflow Git

### 1. Fork & Clone

```bash
# Fork via GitHub UI, puis :
git clone https://github.com/VOTRE_USERNAME/ai4y-delta-lom25.git
cd ai4y-delta-lom25
git remote add upstream https://github.com/neuractif-initiatives/ai4y-delta-lom25.git
```

### 2. Créer une Branche

```bash
# Feature
git checkout -b feature/nom-fonctionnalite

# Bugfix
git checkout -b fix/nom-bug

# Documentation
git checkout -b docs/nom-doc
```

**Convention de nommage** :
- `feature/` — Nouvelle fonctionnalité
- `fix/` — Correction de bug
- `docs/` — Documentation
- `refactor/` — Refactoring
- `test/` — Ajout de tests
- `chore/` — Tâches maintenance

### 3. Développer

```bash
# Synchroniser avec upstream
git fetch upstream
git rebase upstream/main

# Commiter régulièrement
git add .
git commit -m "feat: ajouter diagnostic vocal"
```

### 4. Tester

```bash
# Backend
pytest backend/test_backend.py -v

# Mobile
cd MOBILEAPP/pulseai && flutter test
```

### 5. Push & Pull Request

```bash
git push origin feature/nom-fonctionnalite
```

Créez une PR sur GitHub avec le template [Pull Request](.github/PULL_REQUEST_TEMPLATE.md).

---

## 📝 Conventions de Code

### Commits (Conventional Commits)

Format : `<type>(<scope>): <description>`

**Types** :
- `feat:` — Nouvelle fonctionnalité
- `fix:` — Correction de bug
- `docs:` — Documentation
- `style:` — Formatage, style
- `refactor:` — Refactoring
- `test:` — Tests
- `chore:` — Maintenance

**Exemples** :
```bash
feat(diagnostic): ajouter support vocal symptômes
fix(lyra): corriger persistence sessions
docs(readme): mettre à jour instructions installation
test(backend): ajouter tests unitaires diagnostic
```

### Python (Backend)

#### Style Guide : PEP 8

```python
# ✅ BON
def analyze_diagnosis(symptoms: List[str], notes: str = None) -> Dict[str, Any]:
    """
    Analyse des symptômes pour générer un diagnostic.
    
    Args:
        symptoms: Liste des symptômes sélectionnés
        notes: Précisions additionnelles (optionnel)
    
    Returns:
        Dictionnaire contenant diagnostic, recommandations, sévérité
    
    Raises:
        ValueError: Si symptoms est vide
    """
    if not symptoms:
        raise ValueError("Au moins un symptôme requis")
    
    # Logique...
    return {"diagnosis": "...", "recommendations": [...]}

# ❌ MAUVAIS
def analyzeDiagnosis(symptoms,notes=None):
    if not symptoms:return None
    #pas de docstring
    return {"diagnosis":"..."}
```

#### Imports

```python
# Standard library
import os
import json
from typing import List, Dict

# Third-party
import faiss
from fastapi import FastAPI

# Local
from .diagnostic_service import DiagnosticSystem
```

#### Docstrings (Google Style)

```python
def function_name(arg1: type, arg2: type) -> return_type:
    """Brief description.
    
    Longer description if needed.
    
    Args:
        arg1: Description of arg1
        arg2: Description of arg2
    
    Returns:
        Description of return value
    
    Raises:
        ErrorType: When this error occurs
    """
```

### JavaScript (Dashboard)

#### Style Guide : Airbnb

```javascript
// ✅ BON
async function getNearbyHospitals(latitude, longitude, radius = 10) {
  /**
   * Récupère les hôpitaux à proximité.
   * @param {number} latitude - Latitude utilisateur
   * @param {number} longitude - Longitude utilisateur
   * @param {number} radius - Rayon de recherche en km
   * @returns {Promise<Array>} Liste des hôpitaux
   */
  const { data, error } = await supabase
    .rpc('get_nearby_hospitals', {
      user_lat: latitude,
      user_lon: longitude,
      radius_km: radius,
    });
  
  if (error) throw error;
  return data;
}

// ❌ MAUVAIS
function getNearbyHospitals(lat,lng,r){
  return supabase.rpc('get_nearby_hospitals',{user_lat:lat,user_lon:lng,radius_km:r})
}
```

#### JSDoc

```javascript
/**
 * @typedef {Object} Hospital
 * @property {string} id - ID unique
 * @property {string} name - Nom hôpital
 * @property {number} latitude - Latitude
 * @property {number} longitude - Longitude
 */

/**
 * Crée un nouvel hôpital.
 * @param {Hospital} hospitalData - Données hôpital
 * @returns {Promise<Hospital>} Hôpital créé
 * @throws {Error} Si validation échoue
 */
async function createHospital(hospitalData) {
  // ...
}
```

### Dart (Flutter)

#### Style Guide : Effective Dart

```dart
// ✅ BON
class DiagnosticProvider with ChangeNotifier {
  /// Analyse des symptômes pour générer un diagnostic.
  /// 
  /// Paramètres:
  /// - [symptoms]: Liste des symptômes sélectionnés
  /// - [notes]: Précisions additionnelles (optionnel)
  /// 
  /// Returns: Objet [Diagnosis] avec résultats
  Future<Diagnosis> analyzeDiagnosis({
    required List<String> symptoms,
    String? notes,
  }) async {
    final response = await _apiService.post('/diagnostic/analyze', data: {
      'symptoms': symptoms,
      'notes': notes,
    });
    
    return Diagnosis.fromJson(response.data);
  }
}

// ❌ MAUVAIS
class diagnosticprovider with ChangeNotifier{
  Future<Diagnosis> analyzediagnosis(List<String> symptoms,String notes) async {
    var response=await _apiService.post('/diagnostic/analyze',data:{'symptoms':symptoms,'notes':notes});
    return Diagnosis.fromJson(response.data);
  }
}
```

---

## 🧪 Tests

### Backend (pytest)

```python
# backend/test_backend.py
import pytest
from app.diagnostic_service import DiagnosticSystem

def test_fetch_symptoms():
    """Test récupération liste symptômes."""
    system = DiagnosticSystem()
    symptoms = system.symptoms_list
    assert len(symptoms) > 0
    assert "Fièvre" in symptoms

def test_analyze_diagnosis():
    """Test génération diagnostic."""
    system = DiagnosticSystem()
    result = system.generate_diagnosis(
        symptoms=["Fièvre", "Toux"],
        notes="Depuis 3 jours"
    )
    assert "diagnosis" in result
    assert result["severity"] in ["low", "moderate", "high", "critical"]
```

Run :
```bash
pytest backend/test_backend.py -v --cov
```

### Mobile (Flutter)

```dart
// test/providers/auth_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pulseai/providers/auth_provider.dart';

void main() {
  group('AuthProvider', () {
    test('signUp creates new user', () async {
      final provider = AuthProvider();
      
      await provider.signUp(
        email: 'test@example.com',
        password: 'password123',
        fullName: 'Test User',
      );
      
      expect(provider.errorMessage, isNull);
      expect(provider.isAuthenticated, isTrue);
    });
  });
}
```

Run :
```bash
flutter test
```

---

## 📖 Documentation

### Quand Documenter

- ✅ Nouvelle fonctionnalité
- ✅ Modification API
- ✅ Changement architecture
- ✅ Nouvelle dépendance
- ✅ Configuration requise

### Où Documenter

- `README.md` — Vue d'ensemble, quick start
- `docs/` — Documentation technique détaillée
- `CHANGELOG.md` — Historique des changements
- Code — Docstrings, JSDoc, DartDoc

### Comment Documenter

1. **Markdown** : Utilisez Markdown pour tous les docs
2. **Clarté** : Écrivez simplement, évitez jargon
3. **Exemples** : Fournissez toujours des exemples de code
4. **Mise à jour** : Mettez à jour avec le code

---

## ✅ Checklist Pre-PR

Avant de soumettre votre PR :

### Code
- [ ] Code suit les conventions du langage
- [ ] Pas de `console.log`, `print()` oubliés
- [ ] Pas de secrets/clés hardcodés
- [ ] Pas de code commenté inutile
- [ ] Imports organisés

### Tests
- [ ] Tests unitaires ajoutés/mis à jour
- [ ] Tous les tests passent localement
- [ ] Couverture code maintenue/améliorée

### Documentation
- [ ] README mis à jour si nécessaire
- [ ] CHANGELOG.md mis à jour
- [ ] Docstrings/JSDoc/DartDoc ajoutés
- [ ] API_REFERENCE.md mis à jour (si endpoints modifiés)

### Git
- [ ] Commits bien nommés (Conventional Commits)
- [ ] Branch à jour avec `main`
- [ ] Pas de conflits
- [ ] `.gitignore` respecté

---

## 🆘 Besoin d'Aide ?

- 💬 [Discussions GitHub](https://github.com/neuractif-initiatives/ai4y-delta-lom25/discussions)
- 📧 Email : contact@neuractif.org
- 📖 [Documentation complète](docs/INDEX.md)

---

## 🙏 Merci !

Chaque contribution, aussi petite soit-elle, fait avancer PulseAI. Merci de participer à cette mission : **démocratiser la santé en Afrique grâce à l'IA**.

---

<div align="center">

**Fait avec ❤️ pour l'Afrique**

[⬆ Retour en haut](#-guide-de-contribution--pulseai)

</div>
