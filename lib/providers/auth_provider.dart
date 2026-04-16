import 'package:flutter/material.dart';

import '../core/exceptions/app_exception.dart';
import '../core/services/storage_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  Future<void> loadUser() async {
    final userMap = await _storageService.getLoggedInUser();
    if (userMap != null) {
      _currentUser = UserModel.fromMap(userMap);
      notifyListeners();
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final users = await _storageService.getRegisteredUsers();

      final isExists = users.any(
            (user) => user['email'].toString().toLowerCase() == email.toLowerCase(),
      );

      if (isExists) {
        throw AuthException('Email đã tồn tại');
      }

      final newUser = UserModel(
        fullName: fullName,
        email: email,
        password: password,
      );

      users.add(newUser.toMap());
      await _storageService.saveRegisteredUsers(users);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final users = await _storageService.getRegisteredUsers();

      final matchedUsers = users.where(
            (user) =>
        user['email'].toString().toLowerCase() == email.toLowerCase() &&
            user['password'].toString() == password,
      );

      if (matchedUsers.isEmpty) {
        throw AuthException('Sai email hoặc mật khẩu');
      }

      _currentUser = UserModel.fromMap(matchedUsers.first);
      await _storageService.saveLoggedInUser(_currentUser!.toMap());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _storageService.clearLoggedInUser();
    notifyListeners();
  }
}