import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

/// Service class for handling authentication operations
/// Provides methods for login, logout, registration, and user management
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current authenticated user
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        final userDoc = await _firestore
            .collection(AppConstants.firestoreUsersCollection)
            .doc(firebaseUser.uid)
            .get();

        if (userDoc.exists) {
          return UserModel.fromJson(userDoc.data()!);
        } else {
          // Create user document if it doesn't exist
          final newUser = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            name: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          await _firestore
              .collection(AppConstants.firestoreUsersCollection)
              .doc(firebaseUser.uid)
              .set(newUser.toJson());
          
          return newUser;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final user = await getCurrentUser();
        if (user != null) {
          return user;
        }
      }
      throw Exception('Failed to sign in');
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /// Register with email and password
  Future<UserModel> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(name);

        // Create user document in Firestore
        final newUser = UserModel(
          id: credential.user!.uid,
          email: email,
          name: name,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection(AppConstants.firestoreUsersCollection)
            .doc(credential.user!.uid)
            .set(newUser.toJson());

        return newUser;
      }
      throw Exception('Failed to register');
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final user = await getCurrentUser();
        if (user != null) {
          return user;
        }
      }
      throw Exception('Failed to sign in with Google');
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Continue as guest
  Future<UserModel> continueAsGuest() async {
    try {
      final credential = await _auth.signInAnonymously();

      if (credential.user != null) {
        final guestUser = UserModel(
          id: credential.user!.uid,
          email: 'guest@fillora.in',
          name: 'Guest User',
          isGuest: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Store guest user in Firestore
        await _firestore
            .collection(AppConstants.firestoreUsersCollection)
            .doc(credential.user!.uid)
            .set(guestUser.toJson());

        return guestUser;
      }
      throw Exception('Failed to continue as guest');
    } catch (e) {
      throw Exception('Guest login failed: $e');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Update user profile
  Future<UserModel> updateUserProfile(UserModel user) async {
    try {
      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      
      await _firestore
          .collection(AppConstants.firestoreUsersCollection)
          .doc(user.id)
          .update(updatedUser.toJson());

      return updatedUser;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user document from Firestore
        await _firestore
            .collection(AppConstants.firestoreUsersCollection)
            .doc(user.uid)
            .delete();

        // Delete authentication account
        await user.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Get authentication state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}

/// Provider for AuthService using Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});