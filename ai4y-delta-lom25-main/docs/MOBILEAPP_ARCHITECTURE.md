# Architecture Mobile App (Flutter) — Documentation Technique

## 📋 Vue d'Ensemble

Application mobile multiplateforme (Android, iOS, Web) construite avec **Flutter 3.x** offrant :
- RuralDiag (diagnostic IA)
- SmartHosp (recherche hôpitaux)
- Lyra (assistant mental)
- MedScan (phase 2)

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│         Flutter Application                 │
│                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │   UI     │  │ Business │  │   Data   │  │
│  │  Layer   │  │  Logic   │  │  Layer   │  │
│  │ (Widgets)│  │(Provider)│  │ (API/DB) │  │
│  └──────────┘  └──────────┘  └──────────┘  │
│       │             │             │         │
└───────┼─────────────┼─────────────┼─────────┘
        │             │             │
        ▼             ▼             ▼
┌─────────────────────────────────────────────┐
│           External Services                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ Backend  │  │ Supabase │  │   Maps   │  │
│  │   API    │  │(Auth/DB) │  │   API    │  │
│  └──────────┘  └──────────┘  └──────────┘  │
└─────────────────────────────────────────────┘
```

### Architecture Pattern : **Clean Architecture + Provider**

```
lib/
├── presentation/     # UI (Widgets, Screens)
│   ├── screens/
│   ├── widgets/
│   └── themes/
├── domain/          # Business Logic
│   ├── models/
│   ├── repositories/
│   └── usecases/
├── data/            # Data Layer
│   ├── datasources/
│   ├── repositories_impl/
│   └── models/
└── core/            # Utilities
    ├── constants/
    ├── utils/
    └── services/
```

---

## 📂 Structure des Fichiers

```
MOBILEAPP/pulseai/
├── lib/
│   ├── main.dart                    # Point d'entrée
│   ├── app.dart                     # Configuration app
│   ├── screens/
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── diagnostic/
│   │   │   ├── symptoms_selection_screen.dart
│   │   │   └── diagnosis_result_screen.dart
│   │   ├── hospitals/
│   │   │   ├── hospitals_list_screen.dart
│   │   │   └── hospital_detail_screen.dart
│   │   ├── lyra/
│   │   │   └── chat_screen.dart
│   │   └── profile/
│   │       └── profile_screen.dart
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── symptom_chip.dart
│   │   ├── hospital_card.dart
│   │   └── chat_bubble.dart
│   ├── models/
│   │   ├── user.dart
│   │   ├── symptom.dart
│   │   ├── diagnosis.dart
│   │   ├── hospital.dart
│   │   └── chat_message.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   ├── location_service.dart
│   │   └── tts_service.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── diagnostic_provider.dart
│   │   ├── hospital_provider.dart
│   │   └── lyra_provider.dart
│   ├── utils/
│   │   ├── constants.dart
│   │   ├── helpers.dart
│   │   └── validators.dart
│   └── config/
│       ├── routes.dart
│       ├── theme.dart
│       └── env.dart
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   ├── google-services.json   # Firebase
│   │   └── src/main/AndroidManifest.xml
│   └── local.properties
├── ios/
│   └── Runner/
│       ├── Info.plist
│       └── GoogleService-Info.plist
├── assets/
│   ├── images/
│   ├── icons/
│   └── data/
├── pubspec.yaml                    # Dépendances
└── README.md
```

---

## 🎨 UI/UX Architecture

### Navigation

#### Router Configuration (`lib/config/routes.dart`)

```dart
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String diagnostic = '/diagnostic';
  static const String diagnosticResult = '/diagnostic/result';
  static const String hospitals = '/hospitals';
  static const String hospitalDetail = '/hospitals/detail';
  static const String lyra = '/lyra';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case diagnostic:
        return MaterialPageRoute(builder: (_) => SymptomsSelectionScreen());
      case hospitals:
        return MaterialPageRoute(builder: (_) => HospitalsListScreen());
      case lyra:
        return MaterialPageRoute(builder: (_) => LyraChatScreen());
      default:
        return MaterialPageRoute(builder: (_) => NotFoundScreen());
    }
  }
}
```

### Bottom Navigation Bar

```dart
class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    HomeScreen(),
    DiagnosticScreen(),
    HospitalsListScreen(),
    LyraChatScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: 'Diag',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Hôpital',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Lyra',
          ),
        ],
      ),
    );
  }
}
```

---

## 🔐 Authentification (Supabase)

### Service (`lib/services/auth_service.dart`)

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  
  // Signup
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> metadata,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }
  
  // Login
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  // Logout
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  // Current User
  User? get currentUser => _client.auth.currentUser;
  
  // Auth State Stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
```

### Provider (`lib/providers/auth_provider.dart`)

```dart
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  
  AuthProvider() {
    _initAuth();
  }
  
  void _initAuth() {
    _authService.authStateChanges.listen((state) {
      _user = state.session?.user;
      notifyListeners();
    });
  }
  
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _authService.signUp(
        email: email,
        password: password,
        metadata: {'full_name': fullName},
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _authService.signIn(email: email, password: password);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
```

---

## 🩺 RuralDiag (Diagnostic)

### Flow

```
Symptoms Selection → [Voice/Text Input] → API Call → Result Display → TTS
```

### Symptoms Selection Screen

```dart
class SymptomsSelectionScreen extends StatefulWidget {
  @override
  _SymptomsSelectionScreenState createState() => _SymptomsSelectionScreenState();
}

class _SymptomsSelectionScreenState extends State<SymptomsSelectionScreen> {
  final DiagnosticProvider _provider = DiagnosticProvider();
  List<String> _selectedSymptoms = [];
  TextEditingController _notesController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RuralDiag')),
      body: Column(
        children: [
          // Symptoms Grid
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _provider.fetchSymptoms(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final symptom = snapshot.data![index];
                    final isSelected = _selectedSymptoms.contains(symptom);
                    
                    return SymptomChip(
                      label: symptom,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedSymptoms.remove(symptom);
                          } else {
                            _selectedSymptoms.add(symptom);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          
          // Notes Input
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Précisions (optionnel)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () => _startVoiceInput(),
                ),
              ),
              maxLines: 3,
            ),
          ),
          
          // Submit Button
          ElevatedButton(
            onPressed: _selectedSymptoms.isEmpty ? null : _analyzeDiagnosis,
            child: Text('Analyser'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _analyzeDiagnosis() async {
    final result = await _provider.analyzeDiagnosis(
      symptoms: _selectedSymptoms,
      notes: _notesController.text,
    );
    
    Navigator.pushNamed(
      context,
      AppRoutes.diagnosticResult,
      arguments: result,
    );
  }
  
  Future<void> _startVoiceInput() async {
    // Speech-to-Text implementation
  }
}
```

### Diagnostic Provider

```dart
class DiagnosticProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Future<List<String>> fetchSymptoms() async {
    final response = await _apiService.get('/diagnostic/symptoms');
    return List<String>.from(response.data['symptoms']);
  }
  
  Future<Diagnosis> analyzeDiagnosis({
    required List<String> symptoms,
    String? notes,
  }) async {
    final response = await _apiService.post('/diagnostic/analyze', data: {
      'symptoms': symptoms,
      'notes': notes,
      'user_id': AuthService().currentUser?.id,
    });
    
    return Diagnosis.fromJson(response.data);
  }
}
```

---

## 🏥 SmartHosp (Recherche Hôpitaux)

### Location Service

```dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions denied');
      }
    }
    
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  
  double calculateDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // km
  }
}
```

### Hospitals List Screen

```dart
class HospitalsListScreen extends StatefulWidget {
  @override
  _HospitalsListScreenState createState() => _HospitalsListScreenState();
}

class _HospitalsListScreenState extends State<HospitalsListScreen> {
  final HospitalProvider _provider = HospitalProvider();
  final LocationService _locationService = LocationService();
  
  Position? _currentPosition;
  List<Hospital> _hospitals = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }
  
  Future<void> _loadHospitals() async {
    try {
      _currentPosition = await _locationService.getCurrentLocation();
      _hospitals = await _provider.getNearbyHospitals(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Center(child: CircularProgressIndicator());
    
    return Scaffold(
      appBar: AppBar(title: Text('Hôpitaux Proches')),
      body: ListView.builder(
        itemCount: _hospitals.length,
        itemBuilder: (context, index) {
          final hospital = _hospitals[index];
          final distance = _locationService.calculateDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            hospital.latitude,
            hospital.longitude,
          );
          
          return HospitalCard(
            hospital: hospital,
            distance: distance,
            onTap: () => _navigateToHospital(hospital),
          );
        },
      ),
    );
  }
  
  void _navigateToHospital(Hospital hospital) {
    Navigator.pushNamed(
      context,
      AppRoutes.hospitalDetail,
      arguments: hospital,
    );
  }
}
```

---

## 🧠 Lyra (Assistant Mental)

### Chat Screen

```dart
class LyraChatScreen extends StatefulWidget {
  @override
  _LyraChatScreenState createState() => _LyraChatScreenState();
}

class _LyraChatScreenState extends State<LyraChatScreen> {
  final LyraProvider _provider = LyraProvider();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TTSService _ttsService = TTSService();
  
  List<ChatMessage> _messages = [];
  bool _isTyping = false;
  
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }
  
  Future<void> _loadHistory() async {
    _messages = await _provider.getHistory();
    setState(() {});
    _scrollToBottom();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lyra - Assistant Mental'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _provider.createNewSession(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return ChatBubble(isTyping: true);
                }
                
                final message = _messages[index];
                return ChatBubble(
                  message: message,
                  onSpeakTap: () => _ttsService.speak(message.content),
                );
              },
            ),
          ),
          
          // Input Field
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Écris ton message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;
    
    final userMessage = ChatMessage(
      role: 'user',
      content: _messageController.text,
      timestamp: DateTime.now(),
    );
    
    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();
    
    try {
      final response = await _provider.sendMessage(userMessage.content);
      setState(() {
        _messages.add(response);
        _isTyping = false;
      });
      _scrollToBottom();
    } catch (e) {
      _showError(e.toString());
      setState(() => _isTyping = false);
    }
  }
  
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}
```

### TTS Service

```dart
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();
  
  TTSService() {
    _configureTTS();
  }
  
  void _configureTTS() {
    _tts.setLanguage('fr-FR');
    _tts.setSpeechRate(0.5);
    _tts.setVolume(1.0);
    _tts.setPitch(1.0);
  }
  
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }
  
  Future<void> stop() async {
    await _tts.stop();
  }
}
```

---

## 🔧 Configuration

### `pubspec.yaml`

```yaml
name: pulseai
description: PulseAI - Santé pour tous
version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # Backend
  supabase_flutter: ^2.0.0
  dio: ^5.4.0
  
  # UI
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  
  # Location
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  
  # Speech
  flutter_tts: ^4.0.2
  speech_to_text: ^6.5.1
  
  # Storage
  shared_preferences: ^2.2.2
  
  # Utils
  intl: ^0.19.0
  url_launcher: ^6.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

---

## 📱 Build & Déploiement

### Android

#### Build Debug APK
```bash
flutter build apk --debug
```

#### Build Release APK
```bash
flutter build apk --release
```

#### Build App Bundle (Play Store)
```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

---

## 🧪 Tests

### Unit Tests

```dart
// test/providers/auth_provider_test.dart
import 'package:flutter_test/flutter_test.dart';

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
    });
  });
}
```

Run tests:
```bash
flutter test
```

---

## 🚀 Performance

### Optimizations

1. **Lazy Loading**
   - Images chargées à la demande
   - Providers initialisés selon besoin

2. **Caching**
   ```dart
   class CacheService {
     static final SharedPreferences _prefs = ...;
     
     static Future<void> cacheSymptoms(List<String> symptoms) async {
       await _prefs.setStringList('symptoms', symptoms);
     }
     
     static List<String>? getCachedSymptoms() {
       return _prefs.getStringList('symptoms');
     }
   }
   ```

3. **Image Optimization**
   ```dart
   CachedNetworkImage(
     imageUrl: hospital.imageUrl,
     placeholder: (context, url) => CircularProgressIndicator(),
     errorWidget: (context, url, error) => Icon(Icons.error),
   )
   ```

---

## 👨‍💻 Contribution

Consultez [CONTRIBUTING.md](../CONTRIBUTING.md) pour :
- Dart style guide
- Widget best practices
- PR checklist
