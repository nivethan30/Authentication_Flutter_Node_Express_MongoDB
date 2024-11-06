import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isError = false;
  String errorMessage = "";

  UserModel _user =
      UserModel(id: '', name: '', email: '', password: '', token: '');

  UserModel get user => _user;

  Future<void> getUserData() async {
    try {
      isLoading = true;
      notifyListeners();
      _user = await AuthService().getUserData();
      notifyListeners();
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
