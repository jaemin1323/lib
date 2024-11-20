// 이 파일은 예약 변경 화면을 구성하는 위젯을 정의합니다.

import 'package:flutter/material.dart';

class ReservationChangeScreen extends StatelessWidget {
  const ReservationChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('예약 변경')),
      body: const Center(child: Text('예약 변경 화면')),
    );
  }
}
