# Architecture Backend — Documentation Technique

## 📋 Vue d'Ensemble

Le backend PulseAI est une API REST construite avec **FastAPI** qui expose deux services principaux :
1. **Diagnostic System** (RuralDiag) — RAG + FAISS
2. **Lyra Service** — Assistant mental virtuel

---

## 🏗️ Architecture Globale

```
┌─────────────────────────────────────────┐
│         FastAPI Application             │
│         (app/main.py)                   │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────────┐   ┌───────────────┐  │
│  │   Diagnostic │   │     Lyra      │  │
│  │   Service    │   │   Service     │  │
│  └──────────────┘   └───────────────┘  │
│         │                   │           │
│         ▼                   ▼           │
│  ┌──────────────┐   ┌───────────────┐  │
│  │  FAISS Index │   │ Conversation  │  │
│  │  RAG Corpus  │   │   Manager     │  │
│  └──────────────┘   └───────────────┘  │
│         │                   │           │
│         ▼                   ▼           │
│  ┌──────────────┐   ┌───────────────┐  │
│  │ Mistral API  │   │ Mistral API   │  │
│  │ (Diagnosis)  │   │  (Chat)       │  │
│  └──────────────┘   └───────────────┘  │
└─────────────────────────────────────────┘
```

---

## 📂 Structure des Fichiers

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                  # Point d'entrée FastAPI
│   ├── diagnostic_service.py    # Service RAG + FAISS
│   └── lyra_service.py          # Service Lyra (chat)
├── data/
│   ├── rag_clean.csv            # Corpus médical structuré
│   ├── rag_index.faiss          # Index vectoriel FAISS
│   ├── rag_docs.pkl             # Documents sérialisés
│   └── sessions/                # Sessions de chat persistées
├── prompts/
│   └── lyra_system_prompt.txt   # Prompt système Lyra
├── Dockerfile                   # Conteneurisation
├── render.yaml                  # Config déploiement Render
├── requirements.txt             # Dépendances Python
└── test_backend.py              # Tests unitaires
```

---

## 🔌 API Endpoints

### Health Check
```http
GET /
Response: {"status": "healthy", "version": "2.0.0"}
```

### Diagnostic Service (RuralDiag)

#### 1. Liste des Symptômes
```http
GET /diagnostic/symptoms
Response: {
  "symptoms": ["Fièvre", "Maux de tête", ...]
}
```

#### 2. Analyse de Diagnostic
```http
POST /diagnostic/analyze
Body: {
  "symptoms": ["Fièvre", "Toux"],
  "notes": "Symptômes depuis 3 jours",
  "user_id": "user123"
}
Response: {
  "diagnosis": "Analyse détaillée...",
  "recommendations": [...],
  "severity": "moderate"
}
```

### Lyra Service (Assistant Mental)

#### 1. Créer Session
```http
POST /lyra/create_session
Body: {
  "user_id": "user123"
}
Response: {
  "session_id": "uuid-xxx"
}
```

#### 2. Chat
```http
POST /lyra/chat
Body: {
  "session_id": "uuid-xxx",
  "message": "Je me sens stressé"
}
Response: {
  "response": "Je comprends que tu te sentes stressé...",
  "session_id": "uuid-xxx"
}
```

#### 3. Historique
```http
GET /lyra/history/{session_id}
Response: {
  "messages": [
    {"role": "user", "content": "...", "timestamp": "..."},
    {"role": "assistant", "content": "...", "timestamp": "..."}
  ]
}
```

---

## 🧠 Diagnostic Service — Architecture RAG

### Composants

#### 1. **Embedding Model**
```python
SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
```
- Convertit le texte en vecteurs de 384 dimensions
- Lazy loading (chargé à la première utilisation)
- Optimisé pour recherche sémantique

#### 2. **FAISS Index**
```python
faiss.IndexFlatL2(384)
```
- Recherche vectorielle par similarité L2
- Chargement paresseux pour performance
- Requêtes en < 50ms pour 10K+ documents

#### 3. **RAG Pipeline**
```
User Input (symptômes + notes)
        ↓
Embedding (SentenceTransformer)
        ↓
FAISS Search (top-k docs similaires)
        ↓
Context Building (docs + symptômes)
        ↓
Mistral API (génération diagnostic)
        ↓
Response (diagnosis + recommendations)
```

### Fonctions Clés

#### `_load_symptoms()`
Charge la liste des symptômes depuis `rag_clean.csv`.

#### `_ensure_index_loaded()`
Charge l'index FAISS et l'embedder (lazy loading).

#### `_retrieve_context(query: str, top_k: int) -> List[Dict]`
Recherche les documents les plus pertinents via FAISS.

#### `generate_diagnosis(symptoms: List[str], notes: str) -> Dict`
Génère un diagnostic complet avec :
- Analyse des symptômes
- Contexte médical (RAG)
- Recommandations
- Niveau de sévérité

### Exemple de Flux

```python
# 1. Utilisateur sélectionne symptômes
symptoms = ["Fièvre", "Toux sèche", "Fatigue"]
notes = "Depuis 3 jours, température 38.5°C"

# 2. Construction de la requête
query = "Symptômes: Fièvre, Toux sèche, Fatigue. Notes: Depuis 3 jours..."

# 3. Embedding
query_vector = embedder.encode([query])

# 4. Recherche FAISS (top-3 documents)
distances, indices = index.search(query_vector, k=3)
relevant_docs = [docs[i] for i in indices[0]]

# 5. Construction du contexte
context = "\n".join([doc["content"] for doc in relevant_docs])

# 6. Prompt Mistral API
prompt = f"""
Contexte médical:
{context}

Patient:
- Symptômes: {', '.join(symptoms)}
- Notes: {notes}

Génère un diagnostic informatif et des recommandations.
"""

# 7. Génération
response = mistral_client.chat(messages=[{"role": "user", "content": prompt}])
```

---

## 💬 Lyra Service — Architecture

### Composants

#### 1. **ConversationManager**
```python
class ConversationManager:
    - history: List[Dict[str, str]]  # Messages historiques
    - user_data: Dict[str, str]       # Données utilisateur
    - history_file: Path              # Fichier de persistence
```

Gère :
- Persistence des conversations (JSON)
- Limitation à 20 derniers messages (performance)
- Détection de patterns (émotions basiques)

#### 2. **System Prompt**
Chargé depuis `prompts/lyra_system_prompt.txt` :
```
Tu es Lyra, un assistant virtuel empathique...
RÈGLES STRICTES:
- N'utilise JAMAIS d'astérisques, Markdown
- EXCLUSIVEMENT tutoiement (tu/toi)
- Numérote avec 1) 2) 3)
- Ne mentionne jamais Mistral
```

#### 3. **Session Management**
- Chaque utilisateur a un `session_id` unique
- Sessions stockées dans `data/sessions/{session_id}.json`
- Auto-création si inexistante

### Fonctions Clés

#### `create_session(user_id: str) -> str`
Crée une nouvelle session de chat.

#### `chat_with_lyra(session_id: str, message: str) -> Dict`
Envoie un message et retourne la réponse de Lyra.

#### `get_history(session_id: str) -> List[Dict]`
Récupère l'historique d'une session.

### Exemple de Flux

```python
# 1. Créer session
session_id = create_session("user123")

# 2. Chat
response = chat_with_lyra(
    session_id=session_id,
    message="Je me sens stressé par mes examens"
)
# Response: {
#   "response": "Je comprends que la période d'examens...",
#   "session_id": "uuid-xxx"
# }

# 3. Historique
history = get_history(session_id)
# [
#   {"role": "user", "content": "Je me sens...", "timestamp": "..."},
#   {"role": "assistant", "content": "Je comprends...", "timestamp": "..."}
# ]
```

---

## 🐳 Déploiement

### Docker

```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

Build & Run :
```bash
docker build -t pulseai-backend .
docker run -p 8000:8000 --env-file .env pulseai-backend
```

### Render

Configuration dans `render.yaml` :
```yaml
services:
  - type: web
    name: pulseai-backend
    env: docker
    plan: free
    envVars:
      - key: MISTRAL_API_KEY
        sync: false
```

Deploy :
```bash
git push origin main  # Auto-deploy via Render
```

---

## 🧪 Tests

### Exécution
```bash
pytest backend/test_backend.py -v
```

### Couverture
```bash
pytest --cov=backend/app --cov-report=html
```

### Tests Disponibles
- ✅ Health check
- ✅ Liste des symptômes
- ✅ Diagnostic avec symptômes valides
- ✅ Session Lyra
- ✅ Chat Lyra
- ✅ Historique Lyra

---

## ⚡ Performance

### Optimisations

1. **Lazy Loading**
   - Embedder chargé uniquement à la première utilisation
   - FAISS index chargé à la demande

2. **Caching**
   - Embedder gardé en mémoire après chargement
   - Index FAISS persisté en RAM

3. **Garbage Collection**
   - Nettoyage mémoire après opérations lourdes

### Benchmarks

| Endpoint | Temps Moyen | Mémoire |
|----------|-------------|---------|
| GET /diagnostic/symptoms | < 10ms | ~50MB |
| POST /diagnostic/analyze | ~1-2s | ~300MB |
| POST /lyra/chat | ~500ms-1s | ~100MB |

---

## 🔐 Sécurité

### Best Practices

1. **Variables d'Environnement**
   - Secrets dans `.env` (jamais commitées)
   - Validation au démarrage

2. **CORS**
   - Origins whitelistés
   - Regex pattern pour domaines dynamiques

3. **Validation Entrées**
   - Pydantic models pour toutes les requêtes
   - Sanitization des inputs utilisateurs

4. **Rate Limiting** (À Implémenter)
   ```python
   from slowapi import Limiter
   limiter = Limiter(key_func=get_remote_address)
   @limiter.limit("10/minute")
   ```

---

## 📊 Monitoring & Logs

### Logs Structurés
```python
import logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
```

### Métriques à Surveiller
- Latence API (p50, p95, p99)
- Taux d'erreur Mistral API
- Mémoire FAISS index
- Sessions actives Lyra

---

## 🔧 Dépendances Principales

```txt
fastapi==0.104.1         # Framework API
uvicorn==0.24.0          # Serveur ASGI
sentence-transformers    # Embeddings
faiss-cpu==1.7.4         # Vector search
mistralai                # LLM API
pydantic==2.5.0          # Validation
```

---

## 🚀 Roadmap Technique

- [ ] Rate limiting (SlowAPI)
- [ ] Cache Redis pour embeddings fréquents
- [ ] Websockets pour chat temps réel
- [ ] Métriques Prometheus
- [ ] Tests de charge (Locust)
- [ ] CI/CD avec GitHub Actions
- [ ] Monitoring Sentry

---

## 👨‍💻 Contribution au Code

Consultez [CONTRIBUTING.md](../CONTRIBUTING.md) pour :
- Conventions de code (PEP 8)
- Workflow Git (feature branches)
- Standards de tests
- Review process
