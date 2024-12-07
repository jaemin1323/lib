import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // QR 코드 스캐너 패키지
import 'reservation_process_page.dart'; // 예약 프로세스 페이지 임포트
import 'reservation_history.dart'; // 이용 내역 페이지 임포트

class ReservationScreen extends StatelessWidget {
  // 현재 이용 중인 장소와 좌석 번호를 저장하는 변수
  final int? seatNumber; // 좌석 번호 (null이면 현재 이용 중인 좌석 없음)

  // 예약 내역 예시 데이터
  final List<Map<String, String>> reservationHistory = [
    {
      "seatNumber": "25",
      "room": "열람실",
      "date": "2023-12-01",
      "startTime": "10:00",
      "endTime": "13:00"
    },
    {
      "seatNumber": "3",
      "room": "노트북실",
      "date": "2023-12-02",
      "startTime": "14:00",
      "endTime": "16:00"
    }
  ]; // 예약 내역 예시 데이터

  ReservationScreen({this.seatNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
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
                    border: Border.all(color: Colors.blue, width: 1),
                  ),
                  // 좌석 이용 중일 때와 아닐 때의 위젯을 구분하여 표시
                  child: seatNumber != null
                      ? _buildSeatDetails(context) // 좌석 이용 중일 때 표시
                      : _buildNoSeatMessage(context), // 좌석 이용 중이 아닐 때 표시
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 예약하기 및 이용 내역 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 예약하기 버튼 클릭 시 예약 프로세스 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReservationProcessPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: const Text(
                        '예약하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 이용내역 버튼 클릭 시 이용 내역 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsageHistoryPage(
                                    usageHistory: [
                                      {
                                        "seatNumber": "25",
                                        "room": "열람실",
                                        "date": "2023-11-30",
                                        "startTime": "09:00",
                                        "endTime": "12:00"
                                      },
                                      {
                                        "seatNumber": "12",
                                        "room": "노트북실",
                                        "date": "2023-12-01",
                                        "startTime": "14:00",
                                        "endTime": "16:00"
                                      }
                                    ],
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: const Text(
                        '이용내역',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 예약 내역 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpansionTile(
                title: const Text(
                  '예약 내역',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                initiallyExpanded: false,
                children: reservationHistory.isEmpty
                    ? [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "예약 내역이 없습니다.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      ]
                    : reservationHistory.map((history) {
                        return ListTile(
                          title: Text(
                              "좌석 번호: ${history['seatNumber']} (${history['room']})"),
                          subtitle: Text(
                              "${history['date']} ${history['startTime']} - ${history['endTime']}"),
                        );
                      }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // 좌석 현황 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ExpansionTile(
                title: Text(
                  '좌석 현황',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                initiallyExpanded: true,
                children: [
                  // 각 좌석 현황을 표시하는 타일
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

  // 좌석 이용 중일 때 표시되는 위젯
  Widget _buildSeatDetails(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 150,
        maxHeight: 200,
        minWidth: double.infinity,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '열람실',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                _calculateRemainingTime(), // 잔여 시간 계산
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 좌석 번호 확인 버튼
              IconButton(
                icon:
                    const Icon(Icons.event_seat, size: 30, color: Colors.blue),
                onPressed: () {
                  // 좌석 번호 확인 기능 연결
                },
              ),
              // 자리 이동 버튼
              IconButton(
                icon:
                    const Icon(Icons.swap_horiz, size: 30, color: Colors.blue),
                onPressed: () {
                  // 자리 이동 기능 연결
                },
              ),
              // 좌석 반납 버튼
              IconButton(
                icon: const Icon(Icons.assignment_return,
                    size: 30, color: Colors.blue),
                onPressed: () {
                  // 좌석 반납 다이얼로그 표시
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('좌석 반납'),
                        content: const Text('정말 좌석을 반납하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 다이얼로그 닫기
                            },
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () {
                              // 좌석 반납 처리
                              Navigator.of(context).pop(); // 다이얼로그 닫기
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReservationScreen(seatNumber: null),
                                ),
                              );
                            },
                            child: const Text('반납'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              // 연장하기 버튼
              IconButton(
                icon:
                    const Icon(Icons.access_time, size: 30, color: Colors.blue),
                onPressed: () {
                  // 연장하기 기능 연결
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('좌석 번호: $seatNumber',
                  style: const TextStyle(color: Colors.blue)),
              const Text('자리 이동', style: TextStyle(color: Colors.blue)),
              const Text('좌석 반납', style: TextStyle(color: Colors.blue)),
              const Text('연장하기', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }

  // 좌석 이용 중이 아닐 때 표시되는 메시지 위젯
  Widget _buildNoSeatMessage(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 150,
        maxHeight: 200,
        minWidth: double.infinity,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(), // 위쪽 여백을 추가하여 중앙 정렬
          const Text(
            '현재 이용중인 자리가 없습니다.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40), // 메시지 아래 여백 추가
          SizedBox(
            width: double.infinity,
            height: 35, // 버튼 높이 설정
            child: ElevatedButton(
              onPressed: () {
                // QR 스캐너 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScannerPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              child: const Text(
                '예약좌석 이용하기',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 5), // 버튼 아래 여백 추가
        ],
      ),
    );
  }

  // 좌석 현황 타일을 생성하는 위젯
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: occupancyRate, // 좌석 점유율 표시
                backgroundColor: Colors.grey[200],
                color: Colors.green,
                minHeight: 4,
              ),
              const SizedBox(height: 8),
              Text(
                '$availableSeats / $totalSeats', // 사용 가능한 좌석 수
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 잔여 시간을 계산하는 메서드
  String _calculateRemainingTime() {
    DateTime endTime = DateTime.parse("2023-12-06 20:00"); // 퇴실 시간 (예시)
    Duration remainingTime = endTime.difference(DateTime.now());

    if (remainingTime.isNegative) {
      return '퇴실 시간이 지났습니다.'; // 퇴실 시간이 지났을 경우 메시지
    }

    int hours = remainingTime.inHours; // 남은 시간의 시간
    int minutes = remainingTime.inMinutes % 60; // 남은 시간의 분

    return '잔여 시간 $hours시간 $minutes분'; // 잔여 시간 표시
  }
}

// QR 스캐너 페이지
class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR 코드 스캔')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      '스캔 결과: ${result!.code}',
                      style: const TextStyle(fontSize: 18),
                    )
                  : const Text('QR 코드를 스캔하세요'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      // 스캔 완료 후 처리: 좌석 번호 업데이트 및 화면 이동
      if (result != null) {
        Navigator.pop(context, result!.code); // 스캔 결과 반환
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
