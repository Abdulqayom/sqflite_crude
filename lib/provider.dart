import 'package:flutter/material.dart';
import '../usermodel.dart';
import '../sqflitedatabase.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    _users = await DatabaseHelper.instance.getUsers();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    await DatabaseHelper.instance.insertUser(user);
    await fetchUsers();
  }

  Future<void> updateUser(User user) async {
    await DatabaseHelper.instance.updateUser(user);
    await fetchUsers();
  }

  Future<void> deleteUser(int id) async {
    await DatabaseHelper.instance.deleteUser(id);
    await fetchUsers();
  }
}
