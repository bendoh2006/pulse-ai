# Backend (FastAPI)

## Aperçu
- API REST pour RuralDiag et Lyra.
- Services: `diagnostic_service.py`, `lyra_service.py`, point d’entrée `app/main.py`.
- Déploiement: Render (`backend/render.yaml`), Docker (`backend/Dockerfile`).

## Structure
- `backend/app/main.py` — routes et initialisation
- `backend/app/diagnostic_service.py` — pipeline RAG, FAISS
- `backend/app/lyra_service.py` — assistant Lyra
- `backend/data/` — corpus, index, sessions
- `backend/prompts/` — prompts système

## Variables d’environnement
- `SUPABASE_URL`, `SUPABASE_ANON_KEY`
- `EMBEDDINGS_MODEL`, `FAISS_INDEX_PATH`
- `LYRA_SYSTEM_PROMPT_PATH`

## Lancement local
```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Tests
```bash
pytest backend/test_backend.py -q
```

## Déploiement Render
- Configurer `render.yaml` avec service web et variables.
- Construire via Dockerfile ou via build command.

## Sécurité
- Valider les entrées (symptômes, texte libre).
- Journaliser les erreurs sans données sensibles.
- Stocker secrets via variables d’environnement.
