// 이 파일은 추천 도서 화면을 구성하는 위젯을 정의합니다.

import 'package:flutter/material.dart';

class RecommendedBooksScreen extends StatelessWidget {
  const RecommendedBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('추천도서'),
      ),
      body: const Center(
        child: Text('추천도서 화면'),
      ),
    );
  }
}
