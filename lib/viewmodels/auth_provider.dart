import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Provider for managing authentication state
/// Handles user authentication status and provides auth operations
class AuthNotifier extends StateNotifier<UserModel?> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(null) {
    _initializeAuth();
  }

  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    try {
      final user = await _authService.getCurrentUser();
      state = user;
    } catch (e) {
      state = null;
    }
  }

  /// Set current user
  void setUser(UserModel? user) {
    state = user;
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final user = await _authService.signInWithEmailAndPassword(email, password);
      state = user;
    } catch (e) {
      rethrow;
    }
  }

  /// Register with email and password
  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final user = await _authService.registerWithEmailAndPassword(
        email,
        password,
        name,
      );
      state = user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      state = user;
    } catch (e) {
      rethrow;
    }
  }

  /// Continue as guest
  Future<void> continueAsGuest() async {
    try {
      final user = await _authService.continueAsGuest();
      state = user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = null;
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      final updatedUser = await _authService.updateUserProfile(user);
      state = updatedUser;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      await _authService.deleteAccount();
      state = null;
    } catch (e) {
      rethrow;
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state != null;

  /// Check if user is guest
  bool get isGuest => state?.isGuest ?? false;

  /// Get current user
  UserModel? get currentUser => state;
}

/// Global provider for authentication state
final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});

/// Provider for checking if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider);
  return user != null;
});

/// Provider for checking if user is guest
final isGuestProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider);
  return user?.isGuest ?? false;
});

/// Provider for getting current user
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider);
});