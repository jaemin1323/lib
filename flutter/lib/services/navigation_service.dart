// 네비게이션 관리를 위한 서비스 클래스입니다.
import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState get navigator => navigatorKey.currentState!;

  // 기본 네비게이션 메서드들
  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  static void pop<T>([T? result]) {
    return navigator.pop(result);
  }

  static void popUntilFirst() {
    navigator.popUntil((route) => route.isFirst);
  }

  // 인증 관련 네비게이션
  static Future<void> navigateToSettings(VoidCallback onLogout) async {
    await pushNamed('/settings', arguments: {'onLogout': onLogout});
  }

  static Future<void> handleLogout(
      BuildContext context, VoidCallback onLogout) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => pop(true),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      onLogout();
      popUntilFirst();
    }
  }
}
