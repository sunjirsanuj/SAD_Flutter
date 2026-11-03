import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _fullName;
  String? _studentId;
  String? _email;
  String? _password;

  String? get fullName => _fullName;
  String? get studentId => _studentId;
  String? get email => _email;

  String? signup({
    required String fullName,
    required String studentId,
    required String email,
    required String password,
  }) {
    if (fullName.trim().isEmpty ||
        studentId.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty) {
      return "Please fill in all fields";
    }

    if (!email.contains("@")) {
      return "Please enter valid email";
    }

    if (password.length < 6) {
      return "Password must be at least 6 characters.";
    }

    _fullName = fullName;
    _studentId = studentId;
    _email = email;
    _password = password;

    notifyListeners();
    return null;
  }

  String? login({required String email, required String password}) {
    if (_email == null || _password == null) {
      return "Please signup first";
    }

    if (email.trim() != _email || password != _password) {
      return "Incorrect email or password";
    }

    return null;
  }
}
