// 이 파일은 이용 내역 화면을 구성하는 위젯을 정의합니다.
// 사용자가 자신의 이용 내역을 확인할 수 있는 기능을 제공합니다.

import 'package:flutter/material.dart';

class UsageHistoryScreen extends StatelessWidget {
  const UsageHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이용 내역')),
      body: const Center(child: Text('이용 내역 화면')),
    );
  }
}
