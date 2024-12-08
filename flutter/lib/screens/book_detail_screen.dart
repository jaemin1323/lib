// 이 파일은 도서 상세 정보를 표시하는 Flutter 위젯을 정의합니다.
// Start of Selection
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트
import '../models/book.dart'; // 도서 모델 임포트
import 'book_loan_info_screen.dart'; // 도서 대출 정보 스크린 임포트
import 'package:android_intent_plus/android_intent.dart'; // Android 인텐트 패키지 임포트
import 'package:flutter/services.dart'; // Flutter 서비스 패키지 임포트
import 'dart:io' show Platform; // 플랫폼 확인을 위한 dart:io 임포트

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  Future<void> _launchApp() async {
    if (Platform.isAndroid) {
      try {
        final intent = AndroidIntent(
            action: 'android.intent.action.MAIN',
            package: 'com.DefaultCompany.Myproject3',
            componentName: 'com.unity3d.player.UnityPlayerActivity',
            category: 'android.intent.category.LAUNCHER');
        await intent.launch();
      } catch (e) {
        print('앱 실행 중 오류 발생: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          title: const Text('도서 상세정보'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 도서 정보 헤더
              Container(
                width: 140,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: book.imageUrl.isNotEmpty
                    ? Image.network(
                        book.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error, color: Colors.grey),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.book,
                            size: 50, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 16),
              // 책 기본 정보
              Text(
                book.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                book.author,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              // 출판정보와 평점을 같은 줄에 배치
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    book.publisher,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 4),
                      Text(
                        book.rating.toString(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 버튼 행
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _launchApp,
                    icon: const Icon(Icons.map, size: 18),
                    label: const Text('책 길찾기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookLoanInfoScreen(book: book),
                        ),
                      );
                    },
                    icon: const Icon(Icons.book, size: 18),
                    label: const Text('대출하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 소 정보
              _buildInfoSection('책 정보'),
              _buildMDCard(),
              // 소장정보를 Visibility 위젯으로 감싸서 비활성화
              Visibility(
                visible: false,
                child: Column(
                  children: [
                    _buildInfoSection('소장정보'),
                    _buildStatusCard(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    } catch (e) {
      print('도서 상세 화면 빌드 중 에러: $e');
      return Scaffold(
        appBar: AppBar(
          title: const Text('오류'),
        ),
        body: Center(
          child: Text('도서 정보를 불러오는 중 오류가 발생했습니다: $e'),
        ),
      );
    }
  }

  Widget _buildInfoSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatusRow('도서상태', '대출가능'),
            _buildStatusRow('청구기호', '813.7 한32ㅅ'),
            _buildStatusRow('등록번호', '111111'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMDCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이 책의 특징',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '2014년 제38회 이상문학상 수상작. 1980년 5월 광주에서 일어난 일들을 열 개의 이야기로 풀어낸 소설.',
              style: TextStyle(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
