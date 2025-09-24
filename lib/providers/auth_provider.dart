import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isAdmin = false;
  String? _userId;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _isAdmin;
  String? get userId => _userId;
  String? get userName => _userName;

  Future<void> login(String email, String password) async {
    // Simulate login logic
    await Future.delayed(const Duration(seconds: 1));
    
    _isAuthenticated = true;
    _isAdmin = email.contains('admin');
    _userId = DateTime.now().millisecondsSinceEpoch.toString();
    _userName = email.split('@')[0];
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setBool('isAdmin', _isAdmin);
    await prefs.setString('userId', _userId!);
    await prefs.setString('userName', _userName!);
    
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _isAdmin = false;
    _userId = null;
    _userName = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _isAdmin = prefs.getBool('isAdmin') ?? false;
    _userId = prefs.getString('userId');
    _userName = prefs.getString('userName');
    
    notifyListeners();
  }
}
