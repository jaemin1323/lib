// 도서관 관련 URL 상수 정의
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LibraryUrls {
  static const String PURCHASE_REQUEST =
      'https://library.kmu.ac.kr/webcontent/info/45';
  static const String ACADEMIC_INFO =
      'https://library.kmu.ac.kr/login?retUrl=/myrecom/main';

  // URL 실행을 위한 공통 메서드
  static Future<void> launchURL(String url, {BuildContext? context}) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
          ),
        );
      } else {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('URL을 열 수 없습니다.')),
          );
        }
        throw Exception('해당 URL을 열 수 없습니다: $url');
      }
    } catch (e) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
        );
      }
      rethrow;
    }
  }
}
