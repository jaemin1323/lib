// BookService 클래스는 도서 검색 기능을 제공하며,
// 주어진 쿼리를 기반으로 API를 통해 도서를 검색하고,
// 검색 결과를 Book 객체의 리스트로 변환합니다.
import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 패키지
import 'package:http/http.dart' as http; // HTTP 요청을 위한 패키지
import '../models/book.dart'; // Book 모델 임포트

class BookService {
  static const String baseUrl = 'http://10.0.2.2:8080/api'; // API 기본 URL

  Future<List<Book>> searchBooks(String query) async {
    try {
      // API 요청을 통해 도서 검색
      final response = await http.get(
        Uri.parse(
            '$baseUrl/books/search?query=${Uri.encodeComponent(query)}'), // 쿼리 인코딩
        headers: {
          'Content-Type': 'application/json', // 요청 헤더 설정
        },
      );

      // 응답 상태 코드가 200일 경우
      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(response.body); // JSON 데이터 디코딩
        return jsonData
            .map((data) => Book.fromJson(data))
            .toList(); // Book 객체 리스트로 변환
      } else {
        throw Exception(
            '도서 검색에 실패했습니다. 상태 코드: ${response.statusCode}'); // 상태 코드 오류 처리
      }
    } catch (e) {
      print('도서 검색 중 오류 발생: $e'); // 오류 로그 출력
      throw Exception('도서 검색 중 오류가 발생했습니다.'); // 오류 발생 시 예외 처리
    }
  }
}
