import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import '../models/notice.dart';

class NoticeService {
  static const String baseUrl = 'https://library.kmu.ac.kr';

  Future<List<Notice>> fetchNotices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bbs/list/7'));
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final notices = <Notice>[];

        // 상단 고정 공지사항 처리 (최대 3개)
        final fixedNotices = document.querySelectorAll('tr.always').take(3);
        for (var row in fixedNotices) {
          final title = row.querySelector('.title a')?.text.trim() ?? '';
          final date = row.querySelector('.reportDate')?.text.trim() ?? '';
          final category = row.querySelector('.subject')?.text.trim() ?? '';
          final url = row.querySelector('.title a')?.attributes['href'] ?? '';

          notices.add(Notice(
            title: title,
            date: date,
            url: url.startsWith('http') ? url : '$baseUrl$url',
            category: category,
          ));
        }

        // 일반 공지사항 처리 (최대 3개)
        var normalNoticeCount = 0;
        final normalNotices = document.querySelectorAll('tr:not(.always)');
        for (var row in normalNotices) {
          // 테이블 헤더 행 제외
          if (row.querySelector('.num') == null) continue;

          final title = row.querySelector('.title a')?.text.trim() ?? '';
          final date = row.querySelector('.reportDate')?.text.trim() ?? '';
          final category = row.querySelector('.subject')?.text.trim() ?? '';
          final url = row.querySelector('.title a')?.attributes['href'] ?? '';

          notices.add(Notice(
            title: title,
            date: date,
            url: url.startsWith('http') ? url : '$baseUrl$url',
            category: category,
          ));

          normalNoticeCount++;
          if (normalNoticeCount >= 3) break; // 일반 공지사항 3개만 가져오기
        }

        return notices;
      }
      throw Exception('공지사항을 불러오는데 실패했습니다.');
    } catch (e) {
      throw Exception('공지사항을 불러오는데 실패했습니다: $e');
    }
  }
}
