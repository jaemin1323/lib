// 이 파일은 인기 도서 화면을 구성하는 위젯을 정의합니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트

class PopularBookScreen extends StatelessWidget {
  const PopularBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('인기도서'),
      ),
      body: const Center(
        child: Text('인기도서 화면'),
      ),
    );
  }
}
