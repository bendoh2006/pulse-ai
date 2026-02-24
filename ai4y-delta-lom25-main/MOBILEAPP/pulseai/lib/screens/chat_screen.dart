import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pulseai/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/modern_widgets.dart';
import '../core/widgets/markdown_text.dart';
import '../core/utils/responsive.dart';

import 'package:pulseai/services/history_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  final HistoryService _historyService = HistoryService(); // Add HistoryService
  final ScrollController _scrollController = ScrollController();
  final FlutterTts _flutterTts = FlutterTts();
  String? _speakingMessage; // Track which message is being spoken

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("fr-FR");
      await _flutterTts.setPitch(1.2);
      await _flutterTts.setSpeechRate(1.05);
      await _flutterTts.setVolume(1.0);
      debugPrint("TTS init: fr-FR, P=1.2, R=1.05");
    } catch (e) {
      debugPrint("TTS error: $e");
    }
    
    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _speakingMessage = null);
    });

    _flutterTts.setCancelHandler(() {
      if (mounted) setState(() => _speakingMessage = null);
    });
    
    _flutterTts.setErrorHandler((msg) {
       debugPrint("TTS Error: $msg");
       if (mounted) setState(() => _speakingMessage = null);
    });
  }

  Future<void> _speak(String text) async {
    try {
      if (_speakingMessage == text) {
        // Stop if clicking the same message - force immediate stop
        if (mounted) setState(() => _speakingMessage = null);
        await _flutterTts.stop();
        // On web, might need to pause as well
        if (kIsWeb) {
          await _flutterTts.pause();
        }
      } else {
        // Stop previous and start new
        await _flutterTts.stop();
        if (mounted) setState(() => _speakingMessage = text);
        // Small delay to ensure stop is processed
        await Future.delayed(const Duration(milliseconds: 100));
        await _flutterTts.speak(text);
      }
    } catch (e) {
      debugPrint("TTS speak error: $e");
      if (mounted) setState(() => _speakingMessage = null);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _saveSession(); // Save session on dispose
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'message': 'Bonjour ! Je suis Lyra, votre assistant de santé mentale. Comment puis-je vous aider aujourd\'hui ?',
      'time': DateTime.now().subtract(const Duration(minutes: 1)),
    },
  ];
  
  // API History
  List<Map<String, String>> _apiHistory = [];
  
  bool _isLoading = false;

  Future<void> _saveSession() async {
    if (_messages.length > 1) {
      await _historyService.saveChatSession(messages: _messages);
    }
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;

    final userMessage = _controller.text.trim();
    
    setState(() {
      _messages.add({
        'isUser': true,
        'message': userMessage,
        'time': DateTime.now(),
      });
      _controller.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _apiService.chat(userMessage, _apiHistory);
      
      final botResponse = response['response'];
      final history = List<Map<String, dynamic>>.from(response['history']);
      
      // Convert history to string map for next call
      _apiHistory = history.map((e) => {
        "role": e['role'].toString(),
        "content": e['content'].toString()
      }).toList();

      if (mounted) {
        setState(() {
          _messages.add({
            'isUser': false,
            'message': botResponse,
            'time': DateTime.now(),
          });
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({
            'isUser': false,
            'message': 'Désolé, une erreur est survenue. Vérifiez votre connexion.',
            'time': DateTime.now(),
            'isError': true,
          });
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Lyra', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white)),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.valueWhen(
                  context,
                  mobile: 8,
                  tablet: 16,
                  desktop: 16,
                ),
                vertical: Responsive.valueWhen(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 16,
                ),
              ),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'] as bool;
                final isError = msg['isError'] as bool? ?? false;
                
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isUser)
                            Container(
                              margin: EdgeInsets.only(
                                right: Responsive.valueWhen(context, mobile: 6, tablet: 8, desktop: 8),
                                bottom: Responsive.valueWhen(context, mobile: 12, tablet: 16, desktop: 16),
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryBlue.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _speakingMessage == msg['message'] ? Icons.stop_circle_rounded : Icons.volume_up_rounded, 
                                  size: Responsive.valueWhen(context, mobile: 20, tablet: 24, desktop: 26),
                                  color: Colors.white
                                ),
                                onPressed: () => _speak(msg['message'] as String),
                                tooltip: _speakingMessage == msg['message'] ? "Arrêter" : "Écouter",
                                padding: EdgeInsets.all(Responsive.valueWhen(context, mobile: 8, tablet: 10, desktop: 10)),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          Flexible(
                            child: ModernCard(
                              margin: EdgeInsets.only(bottom: Responsive.spacing(context, 2)),
                              padding: EdgeInsets.symmetric(
                                horizontal: Responsive.valueWhen(
                                  context,
                                  mobile: 12,
                                  tablet: 16,
                                  desktop: 16,
                                ),
                                vertical: Responsive.valueWhen(
                                  context,
                                  mobile: 10,
                                  tablet: 12,
                                  desktop: 12,
                                ),
                              ),
                              constraints: BoxConstraints(
                                maxWidth: Responsive.valueWhen(
                                  context,
                                  mobile: MediaQuery.of(context).size.width * 0.75,
                                  tablet: MediaQuery.of(context).size.width * 0.6,
                                  desktop: 500,
                                ),
                              ),
                              gradient: isError 
                                  ? null
                                  : isUser 
                                      ? AppTheme.primaryGradient
                                      : null,
                              color: isError 
                                  ? AppTheme.error.withOpacity(0.1)
                                  : isUser 
                                      ? null
                                      : Colors.white,
                              elevation: isUser ? 3 : 1,
                              child: MarkdownText(
                                text: msg['message'] as String,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isError
                                      ? AppTheme.error
                                      : isUser 
                                          ? Colors.white 
                                          : const Color(0xFF2C3E50),
                                  fontSize: Responsive.valueWhen(
                                    context,
                                    mobile: 14,
                                    tablet: 15,
                                    desktop: 16,
                                  ),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, curve: Curves.easeOut),
                );
              },
            ),
          ),
          
          // Loading indicator
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(Responsive.spacing(context, 1)),
              child: Row(
                children: [
                  SizedBox(width: Responsive.spacing(context, 2)),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                    ),
                  ),
                  SizedBox(width: Responsive.spacing(context, 1.5)),
                  Text(
                    'Lyra réfléchit...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF95A5A6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          
          // Input Area
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.valueWhen(
                context,
                mobile: 8,
                tablet: 16,
                desktop: 16,
              ),
              vertical: Responsive.valueWhen(
                context,
                mobile: 8,
                tablet: 12,
                desktop: 12,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_isLoading,
                      maxLines: null,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Écrivez votre message...',
                        hintStyle: TextStyle(
                          color: const Color(0xFF95A5A6),
                          fontSize: Responsive.valueWhen(
                            context,
                            mobile: 14,
                            tablet: 15,
                            desktop: 16,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Responsive.valueWhen(
                            context,
                            mobile: 14,
                            tablet: 18,
                            desktop: 20,
                          ),
                          vertical: Responsive.valueWhen(
                            context,
                            mobile: 10,
                            tablet: 12,
                            desktop: 12,
                          ),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: Responsive.valueWhen(
                          context,
                          mobile: 14,
                          tablet: 15,
                          desktop: 16,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: Responsive.valueWhen(context, mobile: 8, tablet: 12, desktop: 12)),
                  PrimaryButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: Icons.send_rounded,
                    isCircular: true,
                    isLoading: _isLoading,
                  ).animate().scale(duration: 200.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}