// 화면 빌드를 관리하는 클래스입니다.
import 'package:flutter/material.dart';
import '../screens/library_menu_screen.dart';
import '../screens/reservation_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/my_page_screen.dart';
import '../screens/login_screen.dart';
import '../providers/auth_provider.dart';

class ScreenBuilder {
  static Widget buildMainScreen(
    int selectedIndex,
    AuthProvider authProvider,
    VoidCallback onLogout,
    Function(String) onLoginSuccess,
  ) {
    return IndexedStack(
      index: selectedIndex,
      children: [
        const LibraryMenuScreen(),
        ReservationScreen(seatNumber: 0),
        const HomeScreen(),
        const SearchScreen(),
        _buildAuthScreen(
          authProvider: authProvider,
          onLogout: onLogout,
          onLoginSuccess: onLoginSuccess,
        ),
      ],
    );
  }

  static Widget _buildAuthScreen({
    required AuthProvider authProvider,
    required VoidCallback onLogout,
    required Function(String) onLoginSuccess,
  }) {
    return authProvider.isLoggedIn
        ? MyPageScreen(
            onLogout: onLogout,
            Id: authProvider.studentId,
          )
        : LoginScreen(onLoginSuccess: onLoginSuccess);
  }
}
