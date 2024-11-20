// 이 파일은 좌석 현황 화면을 구성하는 위젯을 정의합니다.
// 사용자가 좌석 현황을 확인할 수 있는 기능을 제공합니다.
import 'package:flutter/material.dart';

class SeatStatusScreen extends StatelessWidget {
  const SeatStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('좌석 현황')),
      body: const Center(child: Text('좌석 현황 화면')),
    );
  }
}
