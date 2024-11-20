// 이 파일은 좌석 변경 화면을 구성하는 위젯을 정의합니다.

import 'package:flutter/material.dart';

class SeatChangeScreen extends StatelessWidget {
  const SeatChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('좌석 변경')),
      body: const Center(child: Text('좌석 변경 화면')),
    );
  }
}
