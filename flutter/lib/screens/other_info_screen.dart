// 이 파일은 기타 안내 화면을 구성하는 위젯을 정의합니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트

class OtherInfoScreen extends StatelessWidget {
  const OtherInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기타 안내'),
      ),
      body: const Center(
        child: Text('기타 안내 화면'),
      ),
    );
  }
}
