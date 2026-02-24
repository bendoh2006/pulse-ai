# 🔌 API Reference — PulseAI Backend

Documentation complète des endpoints de l'API PulseAI.

**Base URL (Production)** : `https://pulseai-backend.onrender.com`  
**Base URL (Local)** : `http://localhost:8000`

---

## 📋 Table des Matières

- [Health Check](#health-check)
- [Diagnostic Service](#diagnostic-service)
  - [Liste des Symptômes](#liste-des-symptômes)
  - [Analyse Diagnostic](#analyse-diagnostic)
- [Lyra Service](#lyra-service)
  - [Créer Session](#créer-session)
  - [Chat](#chat)
  - [Historique](#historique)
  - [Supprimer Session](#supprimer-session)

---

## Health Check

### `GET /`

Vérifier l'état de l'API.

**Response**
```json
{
  "status": "healthy",
  "version": "2.0.0",
  "services": {
    "diagnostic": "operational",
    "lyra": "operational"
  }
}
```

**Status Codes**
- `200 OK` — API fonctionnelle

---

## Diagnostic Service

### Liste des Symptômes

#### `GET /diagnostic/symptoms`

Récupérer la liste complète des symptômes disponibles.

**Response**
```json
{
  "symptoms": [
    "Fièvre",
    "Maux de tête",
    "Toux",
    "Fatigue",
    "Nausée",
    "Douleurs abdominales",
    "Diarrhée",
    "Vomissements",
    "..."
  ],
  "count": 150
}
```

**Status Codes**
- `200 OK` — Liste retournée avec succès

**Exemple cURL**
```bash
curl -X GET "https://pulseai-backend.onrender.com/diagnostic/symptoms"
```

---

### Analyse Diagnostic

#### `POST /diagnostic/analyze`

Analyser des symptômes et générer un diagnostic informatif avec RAG.

**Request Body**
```json
{
  "symptoms": ["Fièvre", "Maux de tête", "Fatigue"],
  "notes": "Symptômes depuis 3 jours, température 38.5°C",
  "user_id": "user123"
}
```

**Parameters**

| Champ | Type | Requis | Description |
|-------|------|--------|-------------|
| `symptoms` | `string[]` | ✅ | Liste des symptômes sélectionnés (1-10) |
| `notes` | `string` | ❌ | Précisions additionnelles (max 500 caractères) |
| `user_id` | `string` | ❌ | Identifiant utilisateur pour historique |

**Response**
```json
{
  "diagnosis": "Analyse détaillée basée sur les symptômes fournis...",
  "recommendations": [
    "Consulter un médecin dans les 24h",
    "Se reposer et s'hydrater",
    "Prendre du paracétamol pour la fièvre"
  ],
  "severity": "moderate",
  "confidence": 0.85,
  "relevant_docs": [
    {
      "title": "Syndrome grippal",
      "excerpt": "...",
      "similarity": 0.92
    }
  ],
  "timestamp": "2025-12-10T14:30:00Z"
}
```

**Response Fields**

| Champ | Type | Description |
|-------|------|-------------|
| `diagnosis` | `string` | Analyse détaillée générée par IA |
| `recommendations` | `string[]` | Liste de recommandations |
| `severity` | `string` | `low`, `moderate`, `high`, `critical` |
| `confidence` | `float` | Score de confiance (0-1) |
| `relevant_docs` | `object[]` | Documents RAG utilisés |
| `timestamp` | `string` | Date/heure de génération (ISO 8601) |

**Status Codes**
- `200 OK` — Diagnostic généré avec succès
- `400 Bad Request` — Paramètres invalides
- `500 Internal Server Error` — Erreur serveur

**Exemple cURL**
```bash
curl -X POST "https://pulseai-backend.onrender.com/diagnostic/analyze" \
  -H "Content-Type: application/json" \
  -d '{
    "symptoms": ["Fièvre", "Toux"],
    "notes": "Depuis 3 jours",
    "user_id": "user123"
  }'
```

**Limitations**
- Max 10 symptômes par requête
- Notes limitées à 500 caractères
- Rate limit : 10 requêtes/minute par IP

---

## Lyra Service

### Créer Session

#### `POST /lyra/create_session`

Créer une nouvelle session de conversation avec Lyra.

**Request Body**
```json
{
  "user_id": "user123"
}
```

**Response**
```json
{
  "session_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "created_at": "2025-12-10T14:30:00Z"
}
```

**Status Codes**
- `200 OK` — Session créée
- `400 Bad Request` — user_id invalide

**Exemple cURL**
```bash
curl -X POST "https://pulseai-backend.onrender.com/lyra/create_session" \
  -H "Content-Type: application/json" \
  -d '{"user_id": "user123"}'
```

---

### Chat

#### `POST /lyra/chat`

Envoyer un message à Lyra et recevoir une réponse.

**Request Body**
```json
{
  "session_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "message": "Je me sens stressé par mes examens"
}
```

**Response**
```json
{
  "response": "Je comprends que la période d'examens peut être très stressante. Peux-tu me dire ce qui te stresse le plus dans cette situation ? Est-ce le volume de travail, la peur de l'échec, ou autre chose ?",
  "session_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "timestamp": "2025-12-10T14:35:00Z",
  "emotion_detected": "stress"
}
```

**Parameters**

| Champ | Type | Requis | Description |
|-------|------|--------|-------------|
| `session_id` | `string` | ✅ | ID de la session (UUID) |
| `message` | `string` | ✅ | Message utilisateur (max 1000 caractères) |

**Status Codes**
- `200 OK` — Réponse générée
- `400 Bad Request` — Paramètres invalides
- `404 Not Found` — Session introuvable
- `500 Internal Server Error` — Erreur serveur

**Exemple cURL**
```bash
curl -X POST "https://pulseai-backend.onrender.com/lyra/chat" \
  -H "Content-Type: application/json" \
  -d '{
    "session_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "message": "Je me sens stressé"
  }'
```

---

### Historique

#### `GET /lyra/history/{session_id}`

Récupérer l'historique complet d'une session de chat.

**Response**
```json
{
  "session_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "messages": [
    {
      "role": "user",
      "content": "Je me sens stressé",
      "timestamp": "2025-12-10T14:35:00Z"
    },
    {
      "role": "assistant",
      "content": "Je comprends que...",
      "timestamp": "2025-12-10T14:35:02Z"
    }
  ],
  "message_count": 12,
  "created_at": "2025-12-10T14:30:00Z"
}
```

**Status Codes**
- `200 OK` — Historique retourné
- `404 Not Found` — Session introuvable

**Exemple cURL**
```bash
curl -X GET "https://pulseai-backend.onrender.com/lyra/history/a1b2c3d4-e5f6-7890-abcd-ef1234567890"
```

---

### Supprimer Session

#### `DELETE /lyra/session/{session_id}`

Supprimer une session et son historique.

**Response**
```json
{
  "message": "Session deleted successfully",
  "session_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

**Status Codes**
- `200 OK` — Session supprimée
- `404 Not Found` — Session introuvable

**Exemple cURL**
```bash
curl -X DELETE "https://pulseai-backend.onrender.com/lyra/session/a1b2c3d4-e5f6-7890-abcd-ef1234567890"
```

---

## 🔐 Authentification

### Headers Requis

```http
Authorization: Bearer {token}
Content-Type: application/json
```

**Note** : Actuellement, l'API ne requiert pas d'authentification. Une authentification JWT sera ajoutée en Phase 2.

---

## 📊 Rate Limiting

| Endpoint | Limite |
|----------|--------|
| `/diagnostic/analyze` | 10 req/min |
| `/lyra/chat` | 30 req/min |
| Autres | 100 req/min |

**Response en cas de dépassement**
```json
{
  "error": "Rate limit exceeded",
  "retry_after": 45
}
```

**Status Code** : `429 Too Many Requests`

---

## ❌ Gestion d'Erreurs

### Format des Erreurs

```json
{
  "error": "Error message",
  "detail": "Detailed error description",
  "timestamp": "2025-12-10T14:30:00Z",
  "path": "/diagnostic/analyze"
}
```

### Codes d'Erreur Communs

| Code | Signification | Exemple |
|------|---------------|---------|
| `400` | Bad Request | Paramètres manquants/invalides |
| `404` | Not Found | Ressource introuvable |
| `429` | Too Many Requests | Rate limit dépassé |
| `500` | Internal Server Error | Erreur serveur |
| `503` | Service Unavailable | Service temporairement indisponible |

---

## 🧪 Environnement de Test

### Sandbox URL
```
https://pulseai-backend-sandbox.onrender.com
```

### Données de Test

**Symptoms de test**
```json
["Fièvre", "Toux", "Maux de tête"]
```

**Session ID de test**
```
test-session-12345
```

---

## 📦 SDKs & Clients

### JavaScript/TypeScript

```javascript
const BASE_URL = 'https://pulseai-backend.onrender.com';

async function analyzeDiagnosis(symptoms, notes) {
  const response = await fetch(`${BASE_URL}/diagnostic/analyze`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ symptoms, notes, user_id: 'user123' })
  });
  return await response.json();
}

async function chatWithLyra(sessionId, message) {
  const response = await fetch(`${BASE_URL}/lyra/chat`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ session_id: sessionId, message })
  });
  return await response.json();
}
```

### Python

```python
import requests

BASE_URL = "https://pulseai-backend.onrender.com"

def analyze_diagnosis(symptoms, notes=None):
    response = requests.post(
        f"{BASE_URL}/diagnostic/analyze",
        json={
            "symptoms": symptoms,
            "notes": notes,
            "user_id": "user123"
        }
    )
    return response.json()

def chat_with_lyra(session_id, message):
    response = requests.post(
        f"{BASE_URL}/lyra/chat",
        json={
            "session_id": session_id,
            "message": message
        }
    )
    return response.json()
```

### Dart (Flutter)

```dart
import 'package:dio/dio.dart';

class PulseAIApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://pulseai-backend.onrender.com',
  ));
  
  Future<Map<String, dynamic>> analyzeDiagnosis({
    required List<String> symptoms,
    String? notes,
  }) async {
    final response = await _dio.post('/diagnostic/analyze', data: {
      'symptoms': symptoms,
      'notes': notes,
      'user_id': 'user123',
    });
    return response.data;
  }
  
  Future<Map<String, dynamic>> chatWithLyra({
    required String sessionId,
    required String message,
  }) async {
    final response = await _dio.post('/lyra/chat', data: {
      'session_id': sessionId,
      'message': message,
    });
    return response.data;
  }
}
```

---

## 📖 Ressources Additionnelles

- [Documentation Backend Complète](BACKEND_ARCHITECTURE.md)
- [Guide Démarrage Rapide](../README.md#-installation--lancement)
- [Exemples d'Utilisation](https://github.com/neuractif-initiatives/ai4y-delta-lom25/tree/main/examples)

---

## 🐛 Reporter un Bug API

Si vous rencontrez un problème avec l'API :
1. Vérifier le [statut des services](https://pulseai-backend.onrender.com/)
2. Consulter les [issues existantes](https://github.com/neuractif-initiatives/ai4y-delta-lom25/issues)
3. Créer une nouvelle issue avec :
   - Endpoint concerné
   - Request/Response complets
   - Logs d'erreur
   - Environnement (OS, version client)

---

## 📄 Licence

API sous licence **MIT** — voir [LICENSE](../LICENSE)

---

<div align="center">

**PulseAI API v2.0.0**

[Documentation](../docs/INDEX.md) • [GitHub](https://github.com/neuractif-initiatives/ai4y-delta-lom25) • [Support](mailto:contact@neuractif.org)

</div>
