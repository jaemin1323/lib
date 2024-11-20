// 이 파일은 설정 화면을 구성하는 위젯을 정의합니다.
// 사용자가 알림 설정, 개인정보 설정 및 앱 정보를 관리할 수 있는 기능을 제공합니다.

import 'package:flutter/material.dart';
import '../services/navigation_service.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsScreen({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: Column(
        children: [
          // 설정 메뉴 아이템들
          _buildSettingItem(
            icon: Icons.notifications_outlined,
            title: '알림 설정',
            onTap: () {
              // TODO: 알림 설정 화면으로 이동
            },
          ),
          _buildSettingItem(
            icon: Icons.lock_outline,
            title: '개인정보 설정',
            onTap: () {
              // TODO: 개인정보 설정 화면으로 이동
            },
          ),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: '앱 정보',
            onTap: () {
              // TODO: 앱 정보 화면으로 이동
            },
          ),
          const Spacer(), // 나머지 공간을 채움
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => NavigationService.handleLogout(context, onLogout),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          '로그아웃',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
