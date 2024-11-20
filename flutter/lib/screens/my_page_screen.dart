// 이 파일은 사용자의 정보를 표시하고, 설정 화면으로 이동할 수 있는 기능을 제공하는 MyPageScreen 위젯을 정의합니다.

import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트

import '../services/navigation_service.dart';
import '../services/user_service.dart'; // UserService 임포트 추가

class MyPageScreen extends StatefulWidget {
  final VoidCallback onLogout;

  final String Id;

  const MyPageScreen({
    super.key,
    required this.onLogout,
    required this.Id,
  });

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  bool isLoading = true;
  String? _userName;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      setState(() {
        isLoading = true;
        _errorMessage = null;
      });

      final userInfo = await UserService().getUserInfo(widget.Id);

      setState(() {
        _userName = userInfo['name'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _userName = null;
        isLoading = false;
        _errorMessage = '사용자 정보를 불러오는데 실패했습니다.';
      });

      print('사용자 정보 로딩 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                NavigationService.navigateToSettings(widget.onLogout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            _buildQuickMenu(),
            _buildOrderStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.Id,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userName ?? "사용자",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickMenu() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '바로가기',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickMenuItem(Icons.notifications, '알림', ''),
              _buildQuickMenuItem(Icons.card_giftcard, '', ''),
              _buildQuickMenuItem(Icons.favorite, '즐겨찾기', null),
              _buildQuickMenuItem(Icons.card_membership, '모바일 출입ID', null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMenuItem(IconData icon, String label, String? badge) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24),
            ),
            if (badge != null)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '대출 현황',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderStatusItem('대출중', '0'),
              _buildOrderStatusItem('예약중', '0'),
              _buildOrderStatusItem('반납 완료', '0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
