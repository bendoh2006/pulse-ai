import 'package:pulseai/services/api_service.dart';
import 'package:pulseai/services/api_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Modèle pour une réponse du chatbot
class ChatResponse {
  final String response;
  final double confidence;
  final List<String> sources;
  final String timestamp;

  ChatResponse({
    required this.response,
    required this.confidence,
    required this.sources,
    required this.timestamp,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      response: json['response'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      sources: List<String>.from(json['sources'] ?? []),
      timestamp: json['timestamp'] as String,
    );
  }
}

/// Service pour gérer les interactions avec le chatbot Lyra
class ChatService {
  final ApiService _apiService = ApiService();
  
  /// Envoyer un message au chatbot et recevoir une réponse
  Future<ChatResponse> sendMessage({
    required String message,
    String? userId,
    String? sessionId,
  }) async {
    try {
      // Appel direct au backend Lyra
      final dioLyra = Dio(BaseOptions(
        baseUrl: ApiConfig.lyraBase,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ));
      final response = await dioLyra.post('/chat', data: {
        'message': message,
        'history': [],
      });
      // L'API retourne {"response": "...", "history": [...]}
      return ChatResponse(
        response: response.data['response'] as String,
        confidence: 0.95,
        sources: ['Lyra AI'],
        timestamp: DateTime.now().toIso8601String(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error sending message: $e');
      }
      // En cas d'erreur, retourner une réponse par défaut
      return _getMockResponse(message);
    }
  }

  /// Vérifier si l'API du chatbot est disponible
  Future<bool> isApiAvailable() async {
    try {
      final dioLyra = Dio(BaseOptions(baseUrl: ApiConfig.lyraBase));
      final res = await dioLyra.get('/');
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Réponse mockée pour quand l'API n'est pas disponible
  ChatResponse _getMockResponse(String userMessage) {
    final String response;
    
    // Logique simple de réponse basée sur les mots-clés
    final messageLower = userMessage.toLowerCase();
    
    if (messageLower.contains('stress') || messageLower.contains('stressé')) {
      response = '''Je comprends que vous vous sentiez stressé. Voici quelques techniques qui peuvent vous aider :

🌬️ **Respiration profonde** : Inspirez pendant 4 secondes, retenez 4 secondes, expirez pendant 4 secondes. Répétez 5 fois.

🧘 **Méditation** : Prenez 5 minutes pour vous concentrer sur votre respiration et laisser passer vos pensées.

🚶 **Marche** : Une courte marche de 10 minutes peut réduire significativement le stress.

💤 **Sommeil** : Assurez-vous de dormir suffisamment (7-9 heures).

⚠️ **Note** : L'API Lyra n'est pas accessible. Cette réponse est générée localement.''';
    } else if (messageLower.contains('anxi') || messageLower.contains('peur')) {
      response = '''L'anxiété est une réaction normale face à l'incertitude. Voici ce qui peut vous aider :

✍️ **Journaling** : Écrivez vos pensées pour les extérioriser.

🎵 **Musique** : Écoutez de la musique relaxante.

👥 **Parlez** : Partagez vos inquiétudes avec une personne de confiance.

🧘 **Pleine conscience** : Concentrez-vous sur le moment présent.

⚠️ **Note** : L'API Lyra n'est pas accessible. Cette réponse est générée localement.''';
    } else if (messageLower.contains('sommeil') || messageLower.contains('dormir')) {
      response = '''Pour améliorer votre sommeil :

⏰ **Routine** : Couchez-vous et levez-vous à heures fixes.

📵 **Écrans** : Évitez les écrans 1h avant le coucher.

🌡️ **Température** : Maintenez la chambre fraîche (18-20°C).

☕ **Caféine** : Évitez la caféine après 14h.

⚠️ **Note** : L'API Lyra n'est pas accessible. Cette réponse est générée localement.''';
    } else if (messageLower.contains('motivation') || messageLower.contains('motivé')) {
      response = '''Retrouver sa motivation :

🎯 **Objectifs** : Fixez des objectifs petits et atteignables.

📅 **Planning** : Planifiez votre journée la veille.

🏆 **Récompenses** : Félicitez-vous pour chaque petite victoire.

💪 **Activité** : L'exercice physique booste la motivation.

⚠️ **Note** : L'API Lyra n'est pas accessible. Cette réponse est générée localement.''';
    } else {
      response = '''Bonjour ! Je suis votre assistant bien-être PulseAI. Je peux vous aider avec :

• 🌬️ Gestion du stress
• 😰 Réduction de l'anxiété
• 😴 Amélioration du sommeil
• 🚀 Boost de motivation
• 🎯 Concentration
• 🧘 Pleine conscience

N'hésitez pas à me poser vos questions !

⚠️ **Note** : L'API Lyra n'est pas accessible. Je fonctionne en mode local avec des réponses prédéfinies. Pour des conseils personnalisés basés sur l'IA, veuillez démarrer le serveur backend.''';
    }

    return ChatResponse(
      response: response,
      confidence: 0.70, // Confiance faible car c'est une réponse mockée
      sources: ['local_mock'],
      timestamp: DateTime.now().toIso8601String(),
    );
  }
}
