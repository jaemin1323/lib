/// BookLoanInfo 클래스는 도서 대출 정보를 나타내며,
/// 대출 등록 번호, 호출 번호, 위치, 상태, 반납일 및 예약 정보를 포함합니다.
/// JSON 데이터를 기반으로 객체를 생성하는 팩토리 메서드도 제공합니다.
class BookLoanInfo {
  final String registrationNo; // 대출 등록 번호
  final String callNo; // 호출 번호
  final String location; // 도서 위치
  final String status; // 대출 상태
  final String returnDate; // 반납일
  final String reservation; // 예약 정보

  BookLoanInfo({
    required this.registrationNo, // 대출 등록 번호 필수
    required this.callNo, // 호출 번호 필수
    required this.location, // 위치 필수
    required this.status, // 상태 필수
    required this.returnDate, // 반납일 필수
    required this.reservation, // 예약 정보 필수
  });

  factory BookLoanInfo.fromJson(Map<String, dynamic> json) {
    return BookLoanInfo(
      registrationNo: json['registrationNo'] ?? '', // 대출 등록 번호 초기화, 기본값은 빈 문자열
      callNo: json['callNo'] ?? '', // 호출 번호 초기화, 기본값은 빈 문자열
      location: json['location'] ?? '', // 위치 초기화, 기본값은 빈 문자열
      status: json['status'] ?? '', // 상태 초기화, 기본값은 빈 문자열
      returnDate: json['returnDate'] ?? '', // 반납일 초기화, 기본값은 빈 문자열
      reservation: json['reservation'] ?? '', // 예약 정보 초기화, 기본값은 빈 문자열
    );
  }
}
