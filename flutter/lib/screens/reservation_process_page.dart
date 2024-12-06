import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationProcessPage extends StatefulWidget {
  const ReservationProcessPage({super.key});

  @override
  _ReservationProcessPageState createState() => _ReservationProcessPageState();
}

class _ReservationProcessPageState extends State<ReservationProcessPage> {
  DateTime _focusedDay = DateTime.now(); // 현재 집중된 날짜
  DateTime? _selectedDate; // 선택된 날짜
  String? _selectedStartTime; // 선택된 시작 시간
  String? _selectedEndTime; // 선택된 종료 시간
  String _selectedRoom = "열람실"; // 선택된 방

  final List<String> _startOptions = [
    for (int i = 9; i <= 21; i++) ...["$i:00", "$i:30"] // 시작 시간 옵션 생성
  ];

  List<String> _generateStartOptions() {
    DateTime now = DateTime.now(); // 현재 시간
    if (_selectedDate != null &&
        _selectedDate!.year == now.year &&
        _selectedDate!.month == now.month &&
        _selectedDate!.day == now.day) {
      // 오늘 날짜인 경우, 현재 시간 이후의 시간만 추가
      return _startOptions.where((time) {
        int hour = int.parse(time.split(":")[0]);
        int minute = int.parse(time.split(":")[1]);
        if (hour < now.hour) {
          return false; // 현재 시간 이전은 제외
        } else if (hour == now.hour && minute < now.minute) {
          return false; // 현재 시간 이전은 제외
        }
        return true; // 유효한 시간
      }).toList();
    }
    // 오늘 날짜가 아닌 경우 전체 시간대 반환
    return _startOptions;
  }

  List<String> _generateEndOptions() {
    if (_selectedStartTime == null) return []; // 시작 시간이 없으면 종료 시간 옵션 없음
    int startHour = int.parse(_selectedStartTime!.split(":")[0]);
    int startMinute = int.parse(_selectedStartTime!.split(":")[1]);
    List<String> endOptions = [];

    if (startMinute == 0) {
      endOptions.add("$startHour:30"); // 시작 시간이 정각일 경우 30분 추가
    }

    for (int i = startHour + 1; i <= 21; i++) {
      endOptions.add("$i:00"); // 다음 시간 추가
      endOptions.add("$i:30"); // 다음 30분 추가
    }
    endOptions.add("22:00"); // 마지막 종료 시간 추가

    return endOptions;
  }

  final List<String> _roomOptions = [
    "열람실",
    "노트북실",
    "자율학습실",
    "전자정보실",
    "스터디룸"
  ]; // 방 옵션

  Future<void> _navigateToSeatSelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeatSelectionPage(
          selectedDate: _selectedDate,
          selectedStartTime: _selectedStartTime,
          selectedEndTime: _selectedEndTime,
          selectedRoom: _selectedRoom,
          onDateTimeChanged: (newDate, newStartTime, newEndTime, newRoom) {
            setState(() {
              _selectedDate = newDate; // 날짜 변경
              _selectedStartTime = newStartTime; // 시작 시간 변경
              _selectedEndTime = newEndTime; // 종료 시간 변경
              _selectedRoom = newRoom; // 방 변경
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        // 좌석 선택 결과 처리
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 진행'), // 앱바 제목
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              locale: 'ko_KR', // 한국어 로케일
              firstDay: DateTime.now(), // 캘린더 시작일
              lastDay: DateTime.now().add(const Duration(days: 14)), // 캘린더 종료일
              focusedDay: _focusedDay, // 현재 집중된 날짜
              selectedDayPredicate: (day) =>
                  isSameDay(day, _selectedDate), // 선택된 날짜 확인
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay; // 선택된 날짜 업데이트
                  _focusedDay = focusedDay; // 집중된 날짜 업데이트
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
                      items: _generateStartOptions()
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

// 장소별 좌석 구성
final Map<String, List<String>> roomSeats = {
  "열람실": List.generate(203, (index) => "${index + 1}번 좌석"),
  "노트북실": List.generate(96, (index) => "${index + 1}번 좌석"),
  "자율학습실": List.generate(80, (index) => "${index + 1}번 좌석"),
  "전자정보실": List.generate(70, (index) => "${index + 1}번 좌석"),
  "스터디룸": List.generate(27, (index) => "${index + 1}번 스터디룸"),
};

class SeatSelectionPage extends StatefulWidget {
  final DateTime? selectedDate;
  final String? selectedStartTime;
  final String? selectedEndTime;
  final String selectedRoom;
  final Function(DateTime, String, String, String) onDateTimeChanged;

  const SeatSelectionPage({
    super.key,
    required this.selectedDate,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.selectedRoom,
    required this.onDateTimeChanged,
  });

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  late DateTime _date;
  late String _startTime;
  late String _endTime;
  late String _room;
  String? _selectedSeat;

  @override
  void initState() {
    super.initState();
    _date = widget.selectedDate ?? DateTime.now();
    _startTime = widget.selectedStartTime ?? "9:00";
    _endTime = widget.selectedEndTime ?? "9:30";
    _room = widget.selectedRoom;
  }

  List<String> get _seats => roomSeats[_room] ?? [];

  List<String> _generateStartOptions() {
    DateTime now = DateTime.now();
    // 선택된 날짜가 오늘인 경우, 현재 시간 이후의 시간만 추가
    if (widget.selectedDate != null &&
        widget.selectedDate!.year == now.year &&
        widget.selectedDate!.month == now.month &&
        widget.selectedDate!.day == now.day) {
      return List.generate(25, (index) {
        int hour = 9 + index ~/ 2;
        int minute = (index % 2) * 30;
        if (hour < now.hour || (hour == now.hour && minute < now.minute)) {
          return null; // 현재 시간 이전은 제외
        }
        return "$hour:${minute.toString().padLeft(2, '0')}";
      }).where((time) => time != null).cast<String>().toList();
    }
    // 오늘 날짜가 아닌 경우 전체 시간대 반환
    return List.generate(25, (index) {
      int hour = 9 + index ~/ 2;
      int minute = (index % 2) * 30;
      return "$hour:${minute.toString().padLeft(2, '0')}";
    });
  }

  void _confirmReservation() {
    widget.onDateTimeChanged(_date, _startTime, _endTime, _room);

    String reservationDetails = "예약할 위치: $_room\n"
        "날짜: ${_date.toLocal().toString().split(' ')[0]}\n"
        "입실 시간: $_startTime\n"
        "퇴실 시간: $_endTime\n"
        "선택된 좌석/룸: ${_selectedSeat ?? '선택 안 됨'}";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("예약 확인"),
        content: Text(reservationDetails),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 현재 화면 닫기
              Navigator.pop(context);
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
          ListTile(
            title: const Text("예약 날짜"),
            trailing: TextButton(
              onPressed: () async {
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
              child: Text("${_date.toLocal()}".split(' ')[0]),
            ),
          ),
          ListTile(
            title: const Text("입실 시간"),
            trailing: DropdownButton<String>(
              value: _startTime,
              items: _generateStartOptions().map((String time) {
                return DropdownMenuItem<String>(value: time, child: Text(time));
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
                return DropdownMenuItem<String>(value: time, child: Text(time));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _endTime = newValue!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text("장소 선택"),
            trailing: DropdownButton<String>(
              value: _room,
              items: roomSeats.keys.map((String room) {
                return DropdownMenuItem<String>(value: room, child: Text(room));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _room = newValue!;
                  _selectedSeat = null; // 좌석 선택 초기화
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: _seats.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedSeat == _seats[index]
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedSeat = _seats[index];
                    });
                  },
                  child: Text(_seats[index]),
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: _selectedSeat != null ? _confirmReservation : null,
              child: const Text("예약하기"),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
