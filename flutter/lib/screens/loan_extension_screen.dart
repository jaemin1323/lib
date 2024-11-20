// 이 파일은 대출 연장 화면을 구성하는 위젯을 정의합니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트

class LoanExtensionScreen extends StatelessWidget {
  const LoanExtensionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대출 연장'),
      ),
      body: const Center(
        child: Text('대출 연장 화면'),
      ),
    );
  }
}
