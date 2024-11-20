// UserService 클래스는 사용자 인증 및 사용자 정보를 관리하는 서비스입니다.
// 이 클래스는 로그인 기능과 특정 사용자의 정보를 가져오는 기능을 제공합니다.
// 실제 API 호출을 통해 사용자 인증 및 정보를 처리하며,
// 로그인 시 비밀번호 검증 로직을 포함하고 있습니다.

import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 패키지
import 'package:http/http.dart' as http; // HTTP 요청을 위한 패키지

class UserService {
  // 실제 API 엔드포인트 URL 설정
  static const String baseUrl = 'http://10.0.2.2:8080'; // API 기본 URL

  Future<bool> login(String studentId, String password) async {
    try {
      // 로그인 API 엔드포인트 URL
      final url = Uri.parse('$baseUrl/api/login');

      // POST 요청 전송
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'}, // 요청 헤더
        body: json.encode({'id': studentId, 'password': password}), // 요청 본문
      );

      if (response.statusCode == 200) {
        return true; // 로그인 성공
      } else if (response.statusCode == 401) {
        // 인증 실패
        return false;
      } else {
        // 기타 오류 처리
        throw Exception('로그인 실패: 상태 코드 ${response.statusCode}');
      }
    } catch (e) {
      print('로그인 중 오류 발생: $e');
      throw Exception('로그인 처리 중 오류가 발생했습니다.');
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String Id) async {
    try {
      // 사용자 정보 API 엔드포인트 URL
      final url = Uri.parse('$baseUrl/api/users/$Id');

      // GET 요청 전송
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 필요한 경우 인증 토큰 추가
          // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
     // JSON 응답을 Map으로 변환
      } else {
        throw Exception('사용자 정보를 가져오는데 실패했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('사용자 정보 조회 중 오류 발생: $e');
      throw Exception('사용자 정보를 가져오는 중 오류가 발생했습니다.');
    }
  }
}
