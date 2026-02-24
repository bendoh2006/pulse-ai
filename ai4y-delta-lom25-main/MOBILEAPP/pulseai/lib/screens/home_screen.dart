import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulseai/l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/modern_widgets.dart';
import '../core/widgets/health_snapshot.dart';
import '../core/widgets/health_tips_widget.dart';
import '../core/utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final displayName = user?.displayName ?? 'Utilisateur';
    final l10n = AppLocalizations.of(context)!;
    final isMobile = Responsive.isMobile(context);
    final crossAxisCount = isMobile ? 2 : (Responsive.isTablet(context) ? 3 : 4);

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Reactive Top Bar
            SliverAppBar(
              backgroundColor: AppTheme.primaryBlue,
              elevation: 0,
              floating: true,
              snap: true,
              expandedHeight: Responsive.valueWhen(context, mobile: 70, tablet: 75, desktop: 80),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.valueWhen(
                      context,
                      mobile: 12,
                      tablet: 16,
                      desktop: 20,
                    ),
                    vertical: Responsive.valueWhen(
                      context,
                      mobile: 8,
                      tablet: 10,
                      desktop: 10,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Greeting
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.hello,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                                fontSize: Responsive.valueWhen(
                                  context,
                                  mobile: 13,
                                  tablet: 14,
                                  desktop: 15,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              displayName,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.valueWhen(
                                  context,
                                  mobile: 18,
                                  tablet: 20,
                                  desktop: 22,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      
                      // Avatar
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: Responsive.valueWhen(context, mobile: 18, tablet: 19, desktop: 20),
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: Responsive.valueWhen(context, mobile: 20, tablet: 22, desktop: 24),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Health Snapshot
            SliverToBoxAdapter(
              child: const HealthSnapshotWidget(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HealthTipsWidget(),
              ),
            ),

            // Main Content Container
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.valueWhen(
                    context,
                    mobile: 12,
                    tablet: 16,
                    desktop: 20,
                  ),
                  vertical: Responsive.valueWhen(
                    context,
                    mobile: 8,
                    tablet: 10,
                    desktop: 12,
                  ),
                ),
                child: Text(
                  l10n.ourServices,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 18,
                      tablet: 20,
                      desktop: 22,
                    ),
                  ),
                ),
              ),
            ),

            // Grid
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.valueWhen(
                  context,
                  mobile: 12,
                  tablet: 16,
                  desktop: 20,
                ),
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: Responsive.valueWhen(context, mobile: 12, tablet: 14, desktop: 16),
                  mainAxisSpacing: Responsive.valueWhen(context, mobile: 12, tablet: 14, desktop: 16),
                  childAspectRatio: 1.0, // Square cards
                ),
                delegate: SliverChildListDelegate([
                  FeatureCard(
                    title: l10n.ruralDiag,
                    description: l10n.ruralDiagDesc,
                    icon: Icons.assignment_outlined,
                    gradient: AppTheme.errorGradient,
                    onTap: () => widget.onNavigate(1),
                    delay: 300,
                  ),
                  FeatureCard(
                    title: l10n.smartHosp,
                    description: l10n.smartHospDesc,
                    icon: Icons.local_hospital,
                    gradient: AppTheme.primaryGradient,
                    onTap: () => widget.onNavigate(2),
                    delay: 400,
                  ),
                  FeatureCard(
                    title: l10n.medScan,
                    description: l10n.medScanDesc,
                    icon: Icons.science_outlined,
                    gradient: AppTheme.successGradient,
                    onTap: () => widget.onNavigate(3),
                    delay: 500,
                  ),
                  FeatureCard(
                    title: l10n.chatTitle,
                    description: l10n.lyraDesc,
                    icon: Icons.psychology_outlined,
                    gradient: AppTheme.accentGradient,
                    onTap: () => widget.onNavigate(4),
                    delay: 600,
                  ),
                ]),
              ),
            ),
            
            // Bottom padding for nav bar
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}