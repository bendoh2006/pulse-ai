class ApiConfig {
  // Backend unifié PulseAI sur Render
  static const String backendBase = 'https://pulseai-fi9m.onrender.com';
  
  // Le backend unifié gère à la fois le chatbot et le diagnostic
  static const String diagnosticBase = backendBase;
  static const String lyraBase = backendBase;
  static const String dashboardBase = '$backendBase/api/v1'; // Compatibilité (non utilisé)

  // Dev fallbacks for emulators and local testing
  static const String devBackend = 'http://10.0.2.2:8000';
  static const String devBackendV1 = 'http://10.0.2.2:8000/api/v1';

  /// Garantit que le suffixe /api/v1 est présent si nécessaire
  static String normalizeV1(String base) {
    final trimmed = base.trim().replaceAll(RegExp(r"/+$"), '');
    return trimmed.endsWith('/api/v1') ? trimmed : '$trimmed/api/v1';
  }
}
