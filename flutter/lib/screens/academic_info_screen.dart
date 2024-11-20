// 이 파일은 학술정보 화면을 구성하는 위젯을 정의합니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지를 임포트합니다.

class AcademicInfoScreen extends StatelessWidget {
  const AcademicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학술정보'),
      ),
      body: const Center(
        child: Text('학술정보 화면'),
      ),
    );
  }
}
