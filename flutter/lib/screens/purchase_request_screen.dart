// 이 파일은 자료 구입 신청 화면을 구성하는 위젯을 정의합니다.

import 'package:flutter/material.dart';

class PurchaseRequestScreen extends StatelessWidget {
  const PurchaseRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자료 구입신청'),
      ),
      body: const Center(
        child: Text('자료 구입신청 화면'),
      ),
    );
  }
}
