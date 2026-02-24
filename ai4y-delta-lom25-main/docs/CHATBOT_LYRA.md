# Chatbot & Lyra

## Aperçu
Assistant de soutien mental (Lyra) basé sur prompts et génération contrôlée.

## Fichiers clés
- `CHATBOT/Lyra.ipynb` — expérimentation et flux
- `CHATBOT/prompts/lyra_system_prompt.txt` — prompt système
- `CHATBOT/requirements.txt` — dépendances

## Lancement Notebook
Ouvrir `Lyra.ipynb` et installer les dépendances.

## Intégration Backend
- `backend/app/lyra_service.py` expose l’assistant via API.
- Paramétrer `LYRA_SYSTEM_PROMPT_PATH`.
