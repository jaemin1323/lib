// 이 파일은 AlumniInfoScreen 위젯을 정의하며, 휴학생 및 졸업생 안내 화면을 표시합니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트

class AlumniInfoScreen extends StatelessWidget {
  const AlumniInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('휴학생 및 졸업생 안내'),
      ),
      body: const Center(
        child: Text('휴학생 및 졸업생 안내 화면'),
      ),
    );
  }
}
