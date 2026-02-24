import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pulseai/services/firebase/auth.dart';
import 'package:pulseai/providers/theme_provider.dart';
import 'package:pulseai/providers/locale_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/medical_id_card.dart';
import 'package:pulseai/l10n/generated/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = false;
  
  String _bloodGroup = '-';
  String _weight = '-';
  String _height = '-';
  String _allergies = '';
  int _diagnosticCount = 0;
  int _scanCount = 0;
  int _sessionCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _bloodGroup = prefs.getString('blood_group') ?? '-';
        _weight = prefs.getString('weight') ?? '-';
        _height = prefs.getString('height') ?? '-';
        _allergies = prefs.getString('allergies') ?? '';
        _diagnosticCount = prefs.getInt('diagnostic_count') ?? 0;
        _scanCount = prefs.getInt('scan_count') ?? 0;
        _sessionCount = prefs.getInt('session_count') ?? 0;
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await Auth().logout();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = localeProvider.locale.languageCode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chooseLanguage),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageTile(
                flag: '🇫🇷',
                name: 'Français',
                code: 'fr',
                currentLocale: currentLocale,
                onTap: () => _changeLanguage('fr'),
              ),
              _buildLanguageTile(
                flag: '🇬🇧',
                name: 'English',
                code: 'en',
                currentLocale: currentLocale,
                onTap: () => _changeLanguage('en'),
              ),
              _buildLanguageTile(
                flag: '🇹🇬',
                name: 'Ewe (Ɛʋɛgbe)',
                code: 'ee',
                currentLocale: currentLocale,
                onTap: () => _changeLanguage('ee'),
              ),
              _buildLanguageTile(
                flag: '🇹🇬',
                name: 'Kabiyè',
                code: 'kbp',
                currentLocale: currentLocale,
                onTap: () => _changeLanguage('kbp'),
              ),
              _buildLanguageTile(
                flag: '🇹🇬',
                name: 'Tem (Kotokoli)',
                code: 'tem',
                currentLocale: currentLocale,
                onTap: () => _changeLanguage('tem'),
              ),
              _buildLanguageTile(
                flag: '🇧🇯',
                name: 'Fɔngbe (Fon)',
                code: 'fon',
                currentLocale: currentLocale,
                onTap: () => _changeLanguage('fon'),
              ),
              _buildLanguageTile(
                flag: '🇳🇬',
                name: 'Yorùbá',
                code: 'yo',
                currentLocale: currentLocale,
                onTap: () => _changeLanguage('yo'),
              ),
              _buildLanguageTile(
                flag: '🇨🇩',
                name: 'Lingála',
                code: 'ln',
                currentLocale: currentLocale,
                onTap: () => _changeLanguage('ln'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile({
    required String flag,
    required String name,
    required String code,
    required String currentLocale,
    required VoidCallback onTap,
  }) {
    final isSelected = currentLocale == code;
    
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppTheme.primaryBlue : AppTheme.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppTheme.primaryBlue)
          : null,
      selected: isSelected,
      selectedTileColor: AppTheme.primaryBlue.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: onTap,
    );
  }

  Future<void> _changeLanguage(String languageCode) async {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    await localeProvider.setLocale(Locale(languageCode));
    
    if (mounted) {
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.languageChanged,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Refresh the current screen
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header with Back Button
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    l10n.myProfile,
                    style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Profile Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: AppTheme.premiumCardDecoration,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                        child: const Icon(Icons.person, size: 40, color: AppTheme.primaryBlue),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName?.toUpperCase() ?? 'UTILISATEUR',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'email@example.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.pushNamed(context, '/edit_profile');
                              if (result == true) {
                                _loadProfileData();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.edit, color: AppTheme.primaryBlue, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    l10n.editProfile,
                                    style: const TextStyle(
                                      color: AppTheme.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.2),

              const SizedBox(height: 24),
              
              // Medical ID Card
              MedicalIDCard(
                bloodGroup: _bloodGroup,
                weight: _weight,
                height: _height,
                allergies: _allergies,
                onEdit: () async {
                  final result = await Navigator.pushNamed(context, '/edit_profile');
                  if (result == true) {
                    _loadProfileData();
                  }
                },
              ),

              const SizedBox(height: 32),

              // Historique Section
              Text(
                l10n.history,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/diagnosis_history');
                        _loadProfileData();
                      },
                      child: _buildStatCard(_diagnosticCount.toString(), 'Diagnostics'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(_scanCount.toString(), 'Scans')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/chat_history');
                        _loadProfileData();
                      },
                      child: _buildStatCard(_sessionCount.toString(), 'Sessions'),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms).slideX(),

              const SizedBox(height: 32),

              // Paramètres Section
              Text(
                l10n.settings,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Column(
                  children: [
                    _buildSettingItem(
                      Icons.translate, 
                      l10n.chooseLanguage, 
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onItemTap: _showLanguageDialog,
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildSettingItem(
                      Icons.notifications_none,
                      l10n.notifications,
                      trailing: Switch(
                        value: _notifications,
                        onChanged: (val) => setState(() => _notifications = val),
                        activeColor: AppTheme.primaryBlue,
                      ),
                    ),
                    const Divider(height: 1, indent: 20, endIndent: 20),
                    _buildSettingItem(Icons.help_outline, l10n.helpSupport, trailing: const Icon(Icons.chevron_right, color: Colors.grey)),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

              const SizedBox(height: 40),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _signOut(context),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Déconnexion',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms).scale(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, {Widget? trailing, VoidCallback? onItemTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryBlue, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
          fontSize: 15,
        ),
      ),
      trailing: trailing,
      onTap: onItemTap ?? () {},
    );
  }
}
