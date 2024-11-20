// 이 파일은 좌석 예약 화면을 구성하는 위젯을 정의합니다.
// 사용자가 좌석 번호를 확인하고 예약 프로세스를 진행할 수 있는 기능을 제공합니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트
import 'reservation_process_page.dart'; // 예약 프로세스 페이지 임포트

class ReservationScreen extends StatelessWidget {
  final int seatNumber; // 좌석 번호

  ReservationScreen({required this.seatNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: Colors.teal, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '열람실',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '잔여 시간 1시간 15분',
                            style: TextStyle(
                                fontSize: 16, color: Colors.redAccent),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(Icons.event_seat,
                                size: 30, color: Colors.teal),
                            onPressed: () {
                              // 좌석 번호 확인 기능 연결
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.swap_horiz,
                                size: 30, color: Colors.teal),
                            onPressed: () {
                              // 자리 이동 기능 연결
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.assignment_return,
                                size: 30, color: Colors.teal),
                            onPressed: () {
                              // 좌석 반납 기능 연결
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.access_time,
                                size: 30, color: Colors.teal),
                            onPressed: () {
                              // 연장하기 기능 연결
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('좌석 번호: $seatNumber',
                              style: TextStyle(color: Colors.teal)),
                          Text('자리 이동', style: TextStyle(color: Colors.teal)),
                          Text('좌석 반납', style: TextStyle(color: Colors.teal)),
                          Text('연장하기', style: TextStyle(color: Colors.teal)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // 예약하기 및 이용 내역 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReservationProcessPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: Text('예약하기'),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 이용 내역 기능 연결 예정
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: Text('이용 내역'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 예약 내역 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpansionTile(
                title: Text(
                  '예약 내역',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                initiallyExpanded: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 예약 내역 추가
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 좌석 현황
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpansionTile(
                title: Text(
                  '좌석 현황',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                initiallyExpanded: true,
                children: [
                  _buildSeatStatusTile(
                    context,
                    title: '열람실',
                    availableSeats: 19,
                    totalSeats: 203,
                    occupancyRate: 19 / 203,
                    onTap: () {
                      // 열람실 예약 페이지로 이동
                    },
                  ),
                  _buildSeatStatusTile(
                    context,
                    title: '노트북실',
                    availableSeats: 22,
                    totalSeats: 96,
                    occupancyRate: 22 / 96,
                    onTap: () {
                      // 노트북실 예약 페이지로 이동
                    },
                  ),
                  _buildSeatStatusTile(
                    context,
                    title: '자율학습실',
                    availableSeats: 0,
                    totalSeats: 80,
                    occupancyRate: 0 / 80,
                    onTap: () {
                      // 자율학습실 예약 페이지로 이동
                    },
                  ),
                  _buildSeatStatusTile(
                    context,
                    title: '전자정보실(멀티미디어)',
                    availableSeats: 0,
                    totalSeats: 70,
                    occupancyRate: 0 / 70,
                    onTap: () {
                      // 전자정보실 예약 페이지로 이동
                    },
                  ),
                  _buildSeatStatusTile(
                    context,
                    title: '스터디룸',
                    availableSeats: 2,
                    totalSeats: 27,
                    occupancyRate: 2 / 27,
                    onTap: () {
                      // 스터디룸 예약 페이지로 이동
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatStatusTile(BuildContext context,
      {required String title,
      required int availableSeats,
      required int totalSeats,
      required double occupancyRate,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: occupancyRate,
                backgroundColor: Colors.grey[200],
                color: Colors.green,
                minHeight: 4,
              ),
              SizedBox(height: 8),
              Text(
                '$availableSeats / $totalSeats',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
