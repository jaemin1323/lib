import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 패키지
import 'package:http/http.dart' as http; // HTTP 요청을 위한 패키지
import '../models/book_loan_info.dart'; // 도서 대출 정보 모델 임포트

/// BookLoanService 클래스는 도서 대출 정보를 가져오는 기능을 제공합니다.
/// 이 클래스는 API를 통해 특정 도서의 대출 정보를 요청하고,
/// 응답을 JSON 형식으로 디코딩하여 BookLoanInfo 객체의 리스트로 변환합니다.
class BookLoanService {
  static const String baseUrl = 'YOUR_API_BASE_URL';

  Future<List<BookLoanInfo>> fetchBookLoanInfo(String bookId) async {
    try {
      // TODO: 실제 API 엔드포인트로 변경
      final response =
          await http.get(Uri.parse('$baseUrl/books/$bookId/loan-info'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => BookLoanInfo.fromJson(data)).toList();
      } else {
        throw Exception('도서 대출 정보를 불러오는데 실패했습니다.');
      }
    } catch (e) {
      throw Exception('네트워크 오류: $e');
    }
  }
}
