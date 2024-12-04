import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_loan_info.dart';

class BookLoanService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  Future<List<BookLoanInfo>> fetchBookLoanInfo(String bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/$bookId/loan-info'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        return jsonData.map((data) => BookLoanInfo.fromJson(data)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('도서 대출 정보를 불러오는데 실패했습니다. (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('네트워크 오류: $e');
    }
  }
}
