// 이 파일은 도서 상세 정보를 표시하는 Flutter 위젯을 정의합니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트
import '../models/book.dart'; // 도서 모델 임포트
import 'book_loan_info_screen.dart'; // 도서 대출 정보 스크린 임포트
import '../models/book_loan_info.dart';  // BookLoanInfo 모델
import '../services/book_loan_service.dart';  // BookLoanService

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final BookLoanService _loanService = BookLoanService();

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
                child: widget.book.imageUrl.isNotEmpty
                    ? Image.network(
                        widget.book.imageUrl,
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
                widget.book.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.book.author,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              // 출판정보와 평점을 같은 줄에 배치
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.book.publisher,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 4),
                      Text(
                        widget.book.rating.toString(),
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppBar(
                                title: const Text('도서 위치'),
                                leading: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: InteractiveViewer(
                                    maxScale: 4.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: CustomPaint(
                                        painter: FloorPlanPainter(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
                          builder: (context) => BookLoanInfoScreen(book: widget.book),
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
              // 소장정보
              _buildInfoSection('소장정보'),
              _buildStatusCard(),
              const SizedBox(height: 16),
              // 책 정보
              _buildInfoSection('책 정보'),
              _buildMDCard(),
            ],
          ),
        ),
      );
    } catch (e) {
      print('도서 상세 화면 빌드 중 에러: $e'); // 디버그 로그 추가
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
    return FutureBuilder<List<BookLoanInfo>>(
      future: _loanService.fetchBookLoanInfo(widget.book.id.toString()),  // widget. 추가
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('오류가 발생했습니다: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('소장 정보가 없습니다.'));
        }

        // 첫 번째 대출 정보를 사용
        final loanInfo = snapshot.data!.first;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildStatusRow('도서상태', loanInfo.status),
                _buildStatusRow('청구기호', loanInfo.callNo),
                _buildStatusRow('등록번호', loanInfo.registrationNo),
              ],
            ),
          ),
        );
      },
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

// FloorPlanPainter 클래스 추가
class FloorPlanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // 도서관 평면도 그리기
    void drawRoom(Offset position, Size roomSize) {
      final rect = Rect.fromLTWH(
        position.dx * size.width,
        position.dy * size.height,
        roomSize.width * size.width,
        roomSize.height * size.height,
      );
      canvas.drawRect(rect, paint);
    }

    // 각 구역 그리기
    // 왼쪽 상단 구역
    drawRoom(const Offset(0.1, 0.1), const Size(0.2, 0.2));
    // 중앙 상단 구역
    drawRoom(const Offset(0.4, 0.1), const Size(0.2, 0.2));
    // 오른쪽 상단 구역
    drawRoom(const Offset(0.7, 0.1), const Size(0.2, 0.2));
    // 중앙 구역
    drawRoom(const Offset(0.3, 0.4), const Size(0.4, 0.2));
    // 왼쪽 하단 구역
    drawRoom(const Offset(0.1, 0.7), const Size(0.2, 0.2));
    // 오른쪽 하단 구역
    drawRoom(const Offset(0.7, 0.7), const Size(0.2, 0.2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
