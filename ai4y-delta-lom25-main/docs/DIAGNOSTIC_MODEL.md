# Diagnostic Model (RAG + FAISS)

## Données et Index
- Corpus: `Diagnostic Model/rag_clean.csv`
- Index vectoriel: `Diagnostic Model/rag_index.faiss`

## Pipeline
- Embeddings -> FAISS search -> Context -> Réponse IA
- Fichier service: `backend/app/diagnostic_service.py`

## Limitations
- Corpus non exhaustif; prévoir validations médicales
- Recommandations informatives, pas de diagnostic médical définitif

## Mise à jour des données
- Régénérer embeddings et index après modification du corpus
