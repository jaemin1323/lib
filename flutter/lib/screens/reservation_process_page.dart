// 이 파일은 좌석 예약 프로세스를 관리하는 Flutter 위젯을 정의합니다.
// 사용자가 날짜, 시간, 방 및 좌석을 선택하여 예약을 진행할 수 있도록 합니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트
import 'package:table_calendar/table_calendar.dart'; // 테이블 캘린더 패키지 임포트

class ReservationProcessPage extends StatefulWidget {
  const ReservationProcessPage({super.key});

  @override
  _ReservationProcessPageState createState() => _ReservationProcessPageState();
}

class _ReservationProcessPageState extends State<ReservationProcessPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;
  String? _selectedStartTime;
  String? _selectedEndTime;
  String _selectedRoom = "열람실";
  int _selectedSeat = -1;

  final List<String> _startOptions = [
    for (int i = 9; i <= 21; i++) ...["$i:00", "$i:30"]
  ];

  List<String> _generateEndOptions() {
    if (_selectedStartTime == null) return [];
    int startHour = int.parse(_selectedStartTime!.split(":")[0]);
    int startMinute = int.parse(_selectedStartTime!.split(":")[1]);
    List<String> endOptions = [];

    if (startMinute == 0) {
      endOptions.add("$startHour:30");
    }

    for (int i = startHour + 1; i <= 21; i++) {
      endOptions.add("$i:00");
      endOptions.add("$i:30");
    }
    endOptions.add("22:00");

    return endOptions;
  }

  final List<String> _roomOptions = ["열람실", "노트북실", "자율학습실", "스터디룸"];

  Future<void> _navigateToSeatSelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeatSelectionPage(
          selectedDate: _selectedDate,
          selectedStartTime: _selectedStartTime,
          selectedEndTime: _selectedEndTime,
          selectedRoom: _selectedRoom,
          onDateAndTimeChanged: (newDate, newStartTime, newEndTime, newRoom) {
            setState(() {
              _selectedDate = newDate;
              _selectedStartTime = newStartTime;
              _selectedEndTime = newEndTime;
              _selectedRoom = newRoom;
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedSeat = result as int;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 진행'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              locale: 'ko_KR',
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 14)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedStartTime = null;
                  _selectedEndTime = null;
                });
              },
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedRoom,
                      items: _roomOptions
                          .map((room) => DropdownMenuItem(
                                value: room,
                                child: Center(child: Text(room)),
                              ))
                          .toList(),
                      onChanged: (newRoom) {
                        setState(() {
                          _selectedRoom = newRoom!;
                        });
                      },
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedStartTime,
                      hint: const Center(child: Text("입실시간 선택")),
                      items: _startOptions
                          .map((time) => DropdownMenuItem(
                                value: time,
                                child: Center(child: Text(time)),
                              ))
                          .toList(),
                      onChanged: (newStartTime) {
                        setState(() {
                          _selectedStartTime = newStartTime;
                          _selectedEndTime = null;
                        });
                      },
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedEndTime,
                      hint: const Center(child: Text("퇴실시간 선택")),
                      items: _generateEndOptions()
                          .map((time) => DropdownMenuItem(
                                value: time,
                                child: Center(child: Text(time)),
                              ))
                          .toList(),
                      onChanged: (newEndTime) {
                        setState(() {
                          _selectedEndTime = newEndTime;
                        });
                      },
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _selectedEndTime == null ? null : _navigateToSeatSelection,
              child: const Text("예약하기"),
            ),
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime day1, DateTime? day2) {
    if (day2 == null) return false;
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }
}

// 좌석 선택 페이지
class SeatSelectionPage extends StatefulWidget {
  final DateTime? selectedDate;
  final String? selectedStartTime;
  final String? selectedEndTime;
  final String selectedRoom;
  final Function(DateTime, String, String, String) onDateAndTimeChanged;

  const SeatSelectionPage({
    super.key,
    required this.selectedDate,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.selectedRoom,
    required this.onDateAndTimeChanged,
  });

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  late DateTime _date;
  late String _startTime;
  late String _endTime;
  late String _room;
  int? _selectedSeatIndex; // 선택된 좌석 인덱스

  @override
  void initState() {
    super.initState();
    _date = widget.selectedDate ?? DateTime.now();
    _startTime = widget.selectedStartTime ?? "9:00";
    _endTime = widget.selectedEndTime ?? "9:30";
    _room = widget.selectedRoom;
  }

  void _confirmReservation() {
    String reservationDetails = "예약할 위치: $_room\n"
        "날짜: ${_date.toLocal().toString().split(' ')[0]}\n"
        "입실 시간: $_startTime\n"
        "퇴실 시간: $_endTime\n"
        "선택된 좌석 번호: ${_selectedSeatIndex != null ? _selectedSeatIndex! + 1 : '선택 안 됨'}";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("예약 확인"),
        content: Text(reservationDetails),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 예약 확인 다이얼로그 닫기
              Navigator.pop(context); // 예약 진행 페이지를 빠져나가기
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("예약 완료"),
                  content: const Text("예약이 완료되었습니다."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 예약 완료 다이얼로그 닫기
                      },
                      child: const Text("확인"),
                    ),
                  ],
                ),
              );
            },
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('좌석 선택'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  title: const Text("예약할 위치"),
                  trailing: DropdownButton<String>(
                    value: _room,
                    items: ["열람실", "노트북실", "자율학습실", "스터디룸"].map((String room) {
                      return DropdownMenuItem<String>(
                          value: room, child: Text(room));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _room = newValue!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text("날짜 선택"),
                  trailing: Text("${_date.toLocal()}".split(' ')[0]),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 14)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _date = pickedDate;
                      });
                    }
                  },
                ),
                ListTile(
                  title: const Text("입실 시간"),
                  trailing: DropdownButton<String>(
                    value: _startTime,
                    items: [
                      for (int i = 9; i <= 21; i++) ...["$i:00", "$i:30"]
                    ].map((String time) {
                      return DropdownMenuItem<String>(
                          value: time, child: Text(time));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _startTime = newValue!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text("퇴실 시간"),
                  trailing: DropdownButton<String>(
                    value: _endTime,
                    items: [
                      for (int i = 9; i <= 21; i++) ...["$i:30", "${i + 1}:00"]
                    ].map((String time) {
                      return DropdownMenuItem<String>(
                          value: time, child: Text(time));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _endTime = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 열 수
                childAspectRatio: 1.5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 20, // 좌석 수
              itemBuilder: (context, index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedSeatIndex == index ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedSeatIndex = index;
                    });
                  },
                  child: Text('좌석 ${index + 1}'),
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed:
                  _selectedSeatIndex != null ? _confirmReservation : null,
              child: const Text("예약하기"),
            ),
          ),
        ],
      ),
    );
  }
}
