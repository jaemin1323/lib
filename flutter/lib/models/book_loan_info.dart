class BookLoanInfo {
  final String registrationNo;
  final String callNo;
  final String location;
  final String status;
  final String returnDate;
  final String reservation;

  BookLoanInfo({
    required this.registrationNo,
    required this.callNo,
    required this.location,
    required this.status,
    required this.returnDate,
    this.reservation = '-',
  });

  factory BookLoanInfo.fromJson(Map<String, dynamic> json) {
    return BookLoanInfo(
      registrationNo: _decodeString(json['registrationNo'] ?? ''),
      callNo: _decodeString(json['callNo'] ?? ''),
      location: _decodeString(json['location'] ?? ''),
      status: _decodeString(json['status'] ?? ''),
      returnDate: json['returnDate'] != null 
          ? _formatDate(json['returnDate'])
          : '',
      reservation: _decodeString(json['reservation'] ?? '-'),
    );
  }

  // UTF-8 디코딩을 위한 헬퍼 메서드
  static String _decodeString(String text) {
    try {
      return text;
    } catch (e) {
      return text;
    }
  }

  static String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
