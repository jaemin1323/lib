// 로그인 상태를 관리하는 프로바이더 클래스입니다.
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _studentId = '';

  bool get isLoggedIn => _isLoggedIn;
  String get studentId => _studentId;

  void login(String studentId) {
    _isLoggedIn = true;
    _studentId = studentId;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _studentId = '';
    notifyListeners();
  }
}
