import 'package:flutter/material.dart';

class UsageHistoryPage extends StatelessWidget {
  final List<Map<String, String>> usageHistory; // 이용 내역 데이터

  UsageHistoryPage({super.key, required this.usageHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("이용 내역"),
      ),
      body: usageHistory.isEmpty
          ? const Center(
              child: Text(
                "이용 내역이 없습니다.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: usageHistory.length,
              itemBuilder: (context, index) {
                final history = usageHistory[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text("좌석 번호: ${history['seatNumber']}"),
                    subtitle: Text(
                        "장소: ${history['room']}\n기간: ${history['date']} ${history['startTime']} - ${history['endTime']}"),
                  ),
                );
              },
            ),
    );
  }
}
