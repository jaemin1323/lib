// 이 파일은 재학생 안내 화면을 구성하는 위젯을 정의합니다.

import 'package:flutter/material.dart';

class StudentInfoScreen extends StatelessWidget {
  const StudentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('재학생 안내')),
      body: const Center(child: Text('재학생 안내 화면')),
    );
  }
}
