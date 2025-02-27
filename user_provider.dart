import 'package:flutter/material.dart';
import 'package:qt_qt/models/user_model.dart';
import 'dart:io';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to load user data
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      _user = UserModel(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phoneNumber: '1234567890',
        walletBalance: 1000.0, // Add wallet balance
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    double? walletBalance, // Add wallet balance parameter
  }) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to update user profile
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      _user = UserModel(
        id: _user!.id,
        firstName: firstName ?? _user!.firstName,
        lastName: lastName ?? _user!.lastName,
        email: _user!.email,
        phoneNumber: phoneNumber ?? _user!.phoneNumber,
        walletBalance: walletBalance ?? _user!.walletBalance, // Add wallet balance
        profilePicture: _user!.profilePicture,
        emailVerifiedAt: _user!.emailVerifiedAt,
        phoneVerifiedAt: _user!.phoneVerifiedAt,
        isTwoFactorEnabled: _user!.isTwoFactorEnabled,
        preferences: _user!.preferences,
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfilePicture(File imageFile) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement API call to upload profile picture
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Simulate updated image URL
      _user = UserModel(
        id: _user!.id,
        firstName: _user!.firstName,
        lastName: _user!.lastName,
        email: _user!.email,
        phoneNumber: _user!.phoneNumber,
        walletBalance: _user!.walletBalance, // Add wallet balance
        profilePicture: 'https://example.com/profile.jpg', // Updated URL
        emailVerifiedAt: _user!.emailVerifiedAt,
        phoneVerifiedAt: _user!.phoneVerifiedAt,
        isTwoFactorEnabled: _user!.isTwoFactorEnabled,
        preferences: _user!.preferences,
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyEmail() async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement email verification API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      _user = UserModel(
        id: _user!.id,
        firstName: _user!.firstName,
        lastName: _user!.lastName,
        email: _user!.email,
        phoneNumber: _user!.phoneNumber,
        walletBalance: _user!.walletBalance, // Add wallet balance
        profilePicture: _user!.profilePicture,
        emailVerifiedAt: DateTime.now(), // Set verification timestamp
        phoneVerifiedAt: _user!.phoneVerifiedAt,
        isTwoFactorEnabled: _user!.isTwoFactorEnabled,
        preferences: _user!.preferences,
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyPhone() async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement phone verification API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      _user = UserModel(
        id: _user!.id,
        firstName: _user!.firstName,
        lastName: _user!.lastName,
        email: _user!.email,
        phoneNumber: _user!.phoneNumber,
        walletBalance: _user!.walletBalance, // Add wallet balance
        profilePicture: _user!.profilePicture,
        emailVerifiedAt: _user!.emailVerifiedAt,
        phoneVerifiedAt: DateTime.now(), // Set verification timestamp
        isTwoFactorEnabled: _user!.isTwoFactorEnabled,
        preferences: _user!.preferences,
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement preferences update API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      _user = UserModel(
        id: _user!.id,
        firstName: _user!.firstName,
        lastName: _user!.lastName,
        email: _user!.email,
        phoneNumber: _user!.phoneNumber,
        walletBalance: _user!.walletBalance, // Add wallet balance
        profilePicture: _user!.profilePicture,
        emailVerifiedAt: _user!.emailVerifiedAt,
        phoneVerifiedAt: _user!.phoneVerifiedAt,
        isTwoFactorEnabled: _user!.isTwoFactorEnabled,
        preferences: preferences,
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}