import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pulseai/services/diagnosis_service.dart';
import 'package:pulseai/services/api_service.dart';
import 'package:pulseai/services/history_service.dart';
import 'package:pulseai/screens/diagnosis_result_screen.dart';
import 'package:pulseai/l10n/generated/app_localizations.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import '../core/theme/app_theme.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final DiagnosisService _diagnosisService = DiagnosisService();
  final HistoryService _historyService = HistoryService();
  final TextEditingController _textController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final GoogleTranslator _translator = GoogleTranslator();
  bool _isListening = false;
  
  Widget _buildQuickSymptomsList(AppLocalizations l10n) {
    final symptoms = [
      {'label': l10n.symptomVomiting, 'icon': Icons.sick_outlined},
      {'label': l10n.symptomNausea, 'icon': Icons.waves},
      {'label': l10n.symptomBackPain, 'icon': Icons.back_hand},
      {'label': l10n.symptomHeadache, 'icon': Icons.psychology},
      {'label': l10n.symptomAbdominalPainAcute, 'icon': Icons.healing},
      {'label': l10n.symptomFever, 'icon': Icons.thermostat},
      {'label': l10n.symptomAbdominalPainLow, 'icon': Icons.healing},
      {'label': l10n.symptomCough, 'icon': Icons.masks},
      {'label': l10n.symptomNasalCongestion, 'icon': Icons.sick},
      {'label': l10n.symptomHeartburn, 'icon': Icons.local_fire_department},
      {'label': l10n.symptomArmPain, 'icon': Icons.accessibility_new},
      {'label': l10n.symptomLowBackPain, 'icon': Icons.accessibility},
      {'label': l10n.symptomEarPain, 'icon': Icons.hearing},
      {'label': l10n.symptomDiarrhea, 'icon': Icons.water_drop},
      {'label': l10n.symptomNeckPain, 'icon': Icons.accessibility_new},
      {'label': l10n.symptomSkinAbnormal, 'icon': Icons.face},
      {'label': l10n.symptomWeakness, 'icon': Icons.battery_alert},
      {'label': l10n.symptomSkinLesion, 'icon': Icons.coronavirus},
      {'label': l10n.symptomChestPainAcute, 'icon': Icons.monitor_heart},
      {'label': l10n.symptomSensationLoss, 'icon': Icons.do_not_touch},
      {'label': l10n.symptomPelvicPain, 'icon': Icons.accessibility_new},
      {'label': l10n.symptomSkinGrowth, 'icon': Icons.coronavirus},
      {'label': l10n.symptomPeeling, 'icon': Icons.face},
      {'label': l10n.symptomDrySkin, 'icon': Icons.face},
      {'label': l10n.symptomMovementProblem, 'icon': Icons.directions_walk},
      {'label': l10n.symptomItching, 'icon': Icons.bug_report},
      {'label': l10n.symptomLegSwelling, 'icon': Icons.accessibility},
      {'label': l10n.symptomEyePain, 'icon': Icons.visibility},
      {'label': l10n.symptomChestTightness, 'icon': Icons.monitor_heart},
      {'label': l10n.symptomDepression, 'icon': Icons.mood_bad},
      {'label': l10n.symptomScalpAbnormal, 'icon': Icons.face},
      {'label': l10n.symptomInsomnia, 'icon': Icons.bedtime},
      {'label': l10n.symptomSidePain, 'icon': Icons.accessibility_new},
      {'label': l10n.symptomKneePain, 'icon': Icons.accessibility},
      {'label': l10n.symptomPainfulUrination, 'icon': Icons.water_drop},
      {'label': l10n.symptomBreathingDifficulty, 'icon': Icons.air},
      {'label': l10n.symptomAcne, 'icon': Icons.face},
      {'label': l10n.symptomFacePain, 'icon': Icons.face},
      {'label': l10n.symptomFootPain, 'icon': Icons.directions_walk},
      {'label': l10n.symptomFrequentUrination, 'icon': Icons.water_drop},
      {'label': l10n.symptomDizziness, 'icon': Icons.rotate_right},
      {'label': l10n.symptomEyeProblem, 'icon': Icons.visibility},
      {'label': l10n.symptomAppetiteLoss, 'icon': Icons.no_food},
      {'label': l10n.symptomStomachBurn, 'icon': Icons.local_fire_department},
      {'label': l10n.symptomIrritability, 'icon': Icons.mood_bad},
      {'label': l10n.symptomMole, 'icon': Icons.coronavirus},
      {'label': l10n.symptomTearing, 'icon': Icons.water_drop},
      {'label': l10n.symptomAlcoholConsumption, 'icon': Icons.local_bar},
    ];

    final displayedSymptoms = _showAllQuick ? symptoms : symptoms.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: displayedSymptoms.map((symptom) {
            return ActionChip(
              avatar: Icon(symptom['icon'] as IconData, size: 18, color: AppTheme.primaryBlue),
              label: Text(symptom['label'] as String),
              onPressed: () => _addSymptom(symptom['label'] as String),
              backgroundColor: AppTheme.lightGrey,
              labelStyle: AppTheme.lightTheme.textTheme.bodyMedium,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide.none,
              ),
            );
          }).toList(),
        ),
        if (symptoms.length > 6)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showAllQuick = !_showAllQuick;
                });
              },
              child: Text(
                _showAllQuick ? l10n.seeLess : l10n.seeAll,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
  bool _showAllQuick = false;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    // No longer loading common symptoms from API as requested
  }

  void _listen() async {
    if (!_isListening) {
      try {
        bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) {
            print('onError: $val');
            if (mounted) {
              setState(() => _isListening = false);
            }
          },
        );
        if (available) {
          setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) => setState(() {
              _textController.text = val.recognizedWords;
            }),
            localeId: 'fr_FR',
          );
        } else {
          // Speech recognition not available (e.g., Firefox)
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Reconnaissance vocale non disponible sur ce navigateur. Utilisez Chrome ou Safari.'),
                backgroundColor: AppTheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } catch (e) {
        print('Speech recognition error: $e');
        if (mounted) {
          setState(() => _isListening = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Reconnaissance vocale non disponible sur ce navigateur.'),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _analyze() async {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez décrire vos symptômes.'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      // Translate to English for the backend
      var translation = await _translator.translate(_textController.text, from: 'fr', to: 'en');
      String symptomsEn = translation.text;

      final results = await _diagnosisService.diagnose(
        symptoms: [symptomsEn],
      );

      if (mounted) {
        await _historyService.saveDiagnosis(
          symptoms: _textController.text, // Save original French text
          results: results,
        );

        setState(() => _isAnalyzing = false);
        
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiagnosisResultScreen(results: results),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du diagnostic: $e'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _addSymptom(String symptom) {
    final currentText = _textController.text;
    if (currentText.isEmpty) {
      _textController.text = symptom;
    } else {
      _textController.text = '$currentText, $symptom';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======= HEADER =======
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.ruralDiag,
                    style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.ruralDiagDesc.replaceAll('\n', ' '),
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // ======= CONTENT =======
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text Input with Send Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: AppTheme.softShadow,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: l10n.describeSymptoms,
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: _isAnalyzing 
                                ? const SizedBox(
                                    width: 24, 
                                    height: 24, 
                                    child: CircularProgressIndicator(strokeWidth: 2)
                                  )
                                : const Icon(Icons.send, color: AppTheme.primaryBlue),
                              onPressed: _isAnalyzing ? null : _analyze,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _actionButton(
                              _isListening ? Icons.mic_off : Icons.mic, 
                              _isListening ? "Stop" : "Vocal", 
                              _listen, 
                              subtitle: "Français"
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _actionButton(Icons.camera_alt_outlined, "Photo", () {
                               ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Fonctionnalité disponible bientôt")),
                              );
                            }),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Quick Symptoms Section
                      Text(
                        l10n.frequentSymptoms,
                        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Expandable quick symptoms list
                      _buildQuickSymptomsList(l10n),
                      
                      const SizedBox(height: 24), // Bottom padding
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap, {String? subtitle}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.softShadow,
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryBlue, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }


  Widget _buildSymptomChip(String text) {
    return InkWell(
      onTap: () => _addSymptom(text),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryBlue.withOpacity(0.1),
              AppTheme.accent.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
