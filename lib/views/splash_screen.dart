import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';
import '../viewmodels/auth_provider.dart';

/// Splash screen that displays app logo and handles initial app setup
/// Shows loading animation while checking authentication status
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  /// Initialize splash screen animations
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  /// Initialize app and check authentication status
  Future<void> _initializeApp() async {
    try {
      // Add a minimum splash duration for better UX
      await Future.wait([
        Future.delayed(const Duration(seconds: 2)),
        _checkAuthenticationStatus(),
      ]);

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      // Handle initialization errors
      debugPrint('App initialization error: $e');
      if (mounted) {
        _navigateToOnboarding();
      }
    }
  }

  /// Check if user is already authenticated
  Future<void> _checkAuthenticationStatus() async {
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.getCurrentUser();
      
      if (user != null) {
        // User is authenticated, can go to home
        ref.read(authProvider.notifier).setUser(user);
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
    }
  }

  /// Navigate to the appropriate next screen
  void _navigateToNextScreen() {
    final currentUser = ref.read(authProvider);
    
    if (currentUser != null) {
      // User is authenticated, go to home
      _navigateToHome();
    } else {
      // User not authenticated, go to onboarding
      _navigateToOnboarding();
    }
  }

  /// Navigate to onboarding screen
  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: AppConstants.mediumAnimation,
      ),
    );
  }

  /// Navigate to home screen
  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: AppConstants.mediumAnimation,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark 
          ? AppTheme.backgroundDark 
          : AppTheme.backgroundLight,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppTheme.backgroundDark,
                        AppTheme.surfaceDark,
                      ]
                    : [
                        AppTheme.backgroundLight,
                        Colors.white,
                      ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated logo container
                    FadeInDown(
                      duration: AppConstants.mediumAnimation,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryColor,
                                AppTheme.secondaryColor,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // App name
                    FadeInUp(
                      duration: AppConstants.mediumAnimation,
                      delay: const Duration(milliseconds: 200),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          AppConstants.appName,
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // App tagline
                    FadeInUp(
                      duration: AppConstants.mediumAnimation,
                      delay: const Duration(milliseconds: 400),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          AppConstants.appTagline,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isDark 
                                ? Colors.white70 
                                : AppTheme.primaryColor.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 64),
                    
                    // Loading animation
                    FadeInUp(
                      duration: AppConstants.mediumAnimation,
                      delay: const Duration(milliseconds: 600),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark ? AppTheme.secondaryColor : AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Loading text
                    FadeInUp(
                      duration: AppConstants.mediumAnimation,
                      delay: const Duration(milliseconds: 800),
                      child: Text(
                        'Loading...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}