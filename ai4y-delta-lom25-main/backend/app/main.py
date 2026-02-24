"""
Backend unifié PulseAI - Chatbot Lyra + Diagnostic
"""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List, Dict
from .lyra_service import create_session, get_manager_for_session, chat_with_lyra, _create_client
from .diagnostic_service import DiagnosticSystem

app = FastAPI(
    title="PulseAI Backend Unifié",
    version="2.0.0",
    description="Backend unifié pour le chatbot Lyra et le système de diagnostic"
)

# CORS - Configuration pour Firebase Hosting et développement local
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://localhost:8000",
        "http://localhost:8080",
        "http://127.0.0.1:3000",
        "http://127.0.0.1:8000",
        "http://127.0.0.1:8080",
        "https://pulseai-a0548.web.app",
        "https://pulseai-a0548.firebaseapp.com",
        "https://pulseai.web.app",
        "https://pulseai.firebaseapp.com",
    ],
    allow_origin_regex="https://.*\\.web\\.app|https://.*\\.firebaseapp\\.com|http://localhost:.*",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize services
diagnostic_system = DiagnosticSystem()


# ========== Models ==========
class ChatRequest(BaseModel):
    message: str
    history: Optional[List[Dict[str, str]]] = None


class ChatResponse(BaseModel):
    response: str
    history: List[Dict[str, str]]


class DiagnosticRequest(BaseModel):
    symptoms: List[str]
    use_ai: bool = True


class DiagnosticResponse(BaseModel):
    diagnosis: str
    confidence: Optional[str] = None
    recommendations: Optional[List[str]] = None


class SymptomsResponse(BaseModel):
    symptoms: List[str]


class CreateSessionResponse(BaseModel):
    session_id: str


class MessageIn(BaseModel):
    content: str


class MessageOut(BaseModel):
    assistant: str
    raw: Optional[dict] = None


# ========== Health Endpoints ==========
@app.get("/")
def read_root():
    return {
        "status": "online",
        "service": "PulseAI Backend Unifié",
        "version": "2.0.0",
        "endpoints": {
            "chatbot": "/chat",
            "diagnostic": "/diagnostic",
            "symptoms": "/symptoms"
        }
    }


@app.get("/health")
@app.get("/api/v1/health")
def health():
    return {
        "status": "ok",
        "version": "2.0.0",
        "services": {
            "chatbot": "operational",
            "diagnostic": "operational"
        }
    }


# ========== Chatbot Endpoints ==========
@app.post("/chat", response_model=ChatResponse)
@app.post("/api/v1/chat", response_model=ChatResponse)
def chat_endpoint(request: ChatRequest):
    """
    Endpoint principal pour le chatbot Lyra
    Compatible avec l'application Flutter
    """
    session_id = "default"
    manager = get_manager_for_session(session_id)
    client = _create_client()
    
    try:
        assistant_text, raw = chat_with_lyra(request.message, manager, client)
        
        # Build history
        history = request.history or []
        history.append({"role": "user", "content": request.message})
        history.append({"role": "assistant", "content": assistant_text})
        
        return ChatResponse(response=assistant_text, history=history)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erreur chatbot: {str(e)}")


@app.post("/api/sessions", response_model=CreateSessionResponse)
def create_session_endpoint():
    """Crée une nouvelle session de chat"""
    session_id = create_session()
    return CreateSessionResponse(session_id=session_id)


@app.post("/api/sessions/{session_id}/messages", response_model=MessageOut)
def send_message_to_session(session_id: str, msg: MessageIn):
    """Envoie un message à une session spécifique"""
    manager = get_manager_for_session(session_id)
    client = _create_client()
    try:
        assistant_text, raw = chat_with_lyra(msg.content, manager, client)
        return MessageOut(assistant=assistant_text, raw=raw)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/sessions/{session_id}/history")
def get_session_history(session_id: str):
    """Récupère l'historique d'une session"""
    manager = get_manager_for_session(session_id)
    return {"messages": manager.get_recent_history()}


# ========== Diagnostic Endpoints ==========
@app.post("/diagnostic", response_model=DiagnosticResponse)
@app.post("/api/v1/diagnostic", response_model=DiagnosticResponse)
def diagnostic_endpoint(request: DiagnosticRequest):
    """
    Endpoint principal pour le diagnostic médical
    Compatible avec l'application Flutter
    """
    try:
        result = diagnostic_system.diagnose(request.symptoms, use_ai=request.use_ai)
        return DiagnosticResponse(
            diagnosis=result.get("diagnosis", "Diagnostic non disponible"),
            confidence=result.get("confidence"),
            recommendations=result.get("recommendations", [])
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erreur diagnostic: {str(e)}")


@app.get("/symptoms", response_model=SymptomsResponse)
@app.get("/ai/symptoms", response_model=SymptomsResponse)
@app.get("/api/v1/ai/symptoms", response_model=SymptomsResponse)
def get_symptoms():
    """Récupère la liste des symptômes disponibles"""
    symptoms = diagnostic_system.get_symptoms()
    return SymptomsResponse(symptoms=symptoms)


# ========== Additional Diagnostic Endpoints ==========
@app.get("/diagnostic/stats")
@app.get("/api/v1/diagnostic/stats")
def get_diagnostic_stats():
    """Statistiques du système de diagnostic"""
    return {
        "total_symptoms": len(diagnostic_system.get_symptoms()),
        "rag_enabled": diagnostic_system.use_rag,
        "model": "Mistral AI"
    }
