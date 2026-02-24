import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_assets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'Diagnostic Rapide',
      description: 'Faites des diagnostics rapides pour voir votre état de santé grâce à notre IA médicale avancée.',
      imagePath: AppAssets.onboarding1,
      icon: Icons.monitor_heart_outlined,
    ),
    OnboardingSlide(
      title: 'Trouvez votre Hôpital',
      description: 'Trouvez l\'hôpital le plus proche de vous en fonction de vos besoins, leur disponibilité et la qualité de leur service.',
      imagePath: AppAssets.onboarding2,
      icon: Icons.local_hospital_outlined,
    ),
    OnboardingSlide(
      title: 'Thérapeute Virtuelle',
      description: 'Discutez avec une thérapeute virtuelle pour tous vos problèmes de santé mentale comme le manque de concentration ou la dépression.',
      imagePath: AppAssets.onboarding3,
      icon: Icons.psychology_outlined,
    ),
    OnboardingSlide(
      title: 'Sécurité Médicamenteuse',
      description: 'Vérifiez la qualité et le rôle de chaque produit que vous prenez pour une consommation sécurisée.',
      imagePath: AppAssets.onboarding1,
      icon: Icons.medication_outlined,
    ),
    OnboardingSlide(
      title: 'Bien-être Quotidien',
      description: 'Recevez chaque jour des conseils pour votre bien-être physique et mental.',
      imagePath: AppAssets.onboarding2,
      icon: Icons.favorite_outlined,
    ),
  ];

  void _nextSlide() {
    if (_currentIndex < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryBlue.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accent.withOpacity(0.1),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header / Skip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            AppAssets.logo,
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                            errorBuilder: (c, o, s) => const Icon(Icons.health_and_safety, color: AppTheme.primaryBlue, size: 30),
                          ),
                        ),
                      ),
                      if (_currentIndex != _slides.length - 1)
                        TextButton(
                          onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                          child: const Text('Passer'),
                        ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: _slides.length,
                    options: CarouselOptions(
                      height: double.infinity,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return _buildSlide(_slides[index]);
                    },
                  ),
                ),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      AnimatedSmoothIndicator(
                        activeIndex: _currentIndex,
                        count: _slides.length,
                        effect: const ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: AppTheme.primaryBlue,
                          dotColor: Color(0xFFD1D5DB),
                          spacing: 8,
                          expansionFactor: 4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _nextSlide,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: AppTheme.primaryBlue.withOpacity(0.4),
                          ),
                          child: Text(
                            _currentIndex == _slides.length - 1 ? 'Commencer' : 'Suivant',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              slide.icon,
              size: 80,
              color: AppTheme.primaryBlue,
            ),
          )
          .animate(target: _currentIndex == _slides.indexOf(slide) ? 1 : 0)
          .scale(duration: 500.ms, curve: Curves.easeOutBack),
          
          const SizedBox(height: 48),
          
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          
          const SizedBox(height: 16),
          
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}

class OnboardingSlide {
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;

  OnboardingSlide({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
  });
}
