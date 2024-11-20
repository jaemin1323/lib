// 이 파일은 교직원 안내 화면을 구성하는 위젯을 정의합니다.

import 'package:flutter/material.dart';

class StaffInfoScreen extends StatelessWidget {
  const StaffInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('교직원 안내'),
      ),
      body: const Center(
        child: Text('교직원 안내 화면'),
      ),
    );
  }
}
