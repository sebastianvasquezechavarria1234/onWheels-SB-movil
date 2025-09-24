import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [
    User(
      id: '1',
      name: 'Juan Pérez',
      email: 'juan@example.com',
      phone: '+1234567890',
      address: 'Calle Principal 123, Ciudad',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      isAdmin: false,
    ),
    User(
      id: '2',
      name: 'María García',
      email: 'maria@example.com',
      phone: '+1234567891',
      address: 'Avenida Central 456, Ciudad',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      isAdmin: false,
    ),
    User(
      id: '3',
      name: 'Admin User',
      email: 'admin@example.com',
      phone: '+1234567892',
      address: 'Oficina Central 789, Ciudad',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      isAdmin: true,
    ),
  ];

  List<User> get users => _users;
  
  List<User> get activeUsers => _users.where((user) => user.isActive).toList();
  
  List<User> get adminUsers => _users.where((user) => user.isAdmin).toList();
  
  List<User> get regularUsers => _users.where((user) => !user.isAdmin).toList();

  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  User? getUserByEmail(String email) {
    try {
      return _users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser(User user) {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      notifyListeners();
    }
  }

  void deleteUser(String id) {
    _users.removeWhere((user) => user.id == id);
    notifyListeners();
  }

  void toggleUserStatus(String id) {
    final index = _users.indexWhere((user) => user.id == id);
    if (index != -1) {
      _users[index] = _users[index].copyWith(isActive: !_users[index].isActive);
      notifyListeners();
    }
  }

  void toggleAdminStatus(String id) {
    final index = _users.indexWhere((user) => user.id == id);
    if (index != -1) {
      _users[index] = _users[index].copyWith(isAdmin: !_users[index].isAdmin);
      notifyListeners();
    }
  }

  List<User> searchUsers(String query) {
    if (query.isEmpty) return _users;
    
    return _users.where((user) =>
        user.name.toLowerCase().contains(query.toLowerCase()) ||
        user.email.toLowerCase().contains(query.toLowerCase()) ||
        (user.phone?.contains(query) ?? false)
    ).toList();
  }
}
