// 이 파일은 도서 대출 정보 화면을 구현하는 Flutter 위젯입니다.
// 사용자가 선택한 도서의 대출 정보를 표시하고, 예약 기능을 제공합니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트
import '../models/book.dart'; // 도서 모델 임포트
import '../models/book_loan_info.dart'; // 도서 대출 정보 모델 임포트
import '../services/book_loan_service.dart'; // 도서 대출 서비스 임포트

class BookLoanInfoScreen extends StatefulWidget {
  final Book book;

  const BookLoanInfoScreen({super.key, required this.book});

  @override
  State<BookLoanInfoScreen> createState() => _BookLoanInfoScreenState();
}

class _BookLoanInfoScreenState extends State<BookLoanInfoScreen> {
  final BookLoanService _loanService = BookLoanService();
  late Future<List<BookLoanInfo>> _loanInfoFuture;

  @override
  void initState() {
    super.initState();
    _loanInfoFuture = _loanService.fetchBookLoanInfo(widget.book.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 대출 정보'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBookInfoSection(context, widget.book),
            const Divider(height: 1),
            FutureBuilder<List<BookLoanInfo>>(
              future: _loanInfoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('오류가 발생했습니다: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('대출 정보가 없습니다.'));
                }
                return _buildLoanInfoTable(context, snapshot.data!);
              },
            ),
            _buildGuidanceSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBookInfoSection(BuildContext context, Book book) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 책 표지 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 100,
              height: 140,
              color: Colors.grey[300],
              child: (book.imageUrl.isNotEmpty)
                  ? Image.network(book.imageUrl, fit: BoxFit.cover)
                  : const Icon(Icons.book, size: 50, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          // 책 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  book.author,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  book.publisher,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanInfoTable(
      BuildContext context, List<BookLoanInfo> loanData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataTable(
          columnSpacing: 20,
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.surface,
          ),
          columns: const [
            DataColumn(label: Text('등록번호')),
            DataColumn(label: Text('청구기호')),
            DataColumn(label: Text('소장처')),
            DataColumn(label: Text('도서상태')),
            DataColumn(label: Text('반납예정일')),
            DataColumn(label: Text('예약')),
          ],
          rows: loanData.map((data) {
            return DataRow(cells: [
              DataCell(Text(data.registrationNo)),
              DataCell(Text(data.callNo)),
              DataCell(Text(data.location)),
              DataCell(_buildStatusCell(data.status)),
              DataCell(Text(data.returnDate)),
              DataCell(_buildReservationCell(context, data.reservation)),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusCell(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: status == '대출중' ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: status == '대출중' ? Colors.red[700] : Colors.green[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReservationCell(BuildContext context, String reservation) {
    if (reservation == '-') return const Text('-');

    return Container(
      constraints: const BoxConstraints(
        minWidth: 100,
        maxWidth: 150,
      ),
      child: ElevatedButton(
        onPressed: () => _showReservationDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            reservation,
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.2),
          ),
        ),
      ),
    );
  }

  Widget _buildGuidanceSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  '대출/예약 안내',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildGuidanceItem(
              context: context,
              icon: Icons.calendar_today,
              text: '대출 기간: 14일',
            ),
            _buildGuidanceItem(
              context: context,
              icon: Icons.library_books,
              text: '1인당 최대 대출 가능 권수: 5권',
            ),
            _buildGuidanceItem(
              context: context,
              icon: Icons.bookmark,
              text: '예약은 1인당 최대 3권까지 가능합니다.',
            ),
            _buildGuidanceItem(
              context: context,
              icon: Icons.notifications,
              text: '예약도서가 도착하면 SMS로 알려드립니다.',
            ),
            _buildGuidanceItem(
              context: context,
              icon: Icons.access_time,
              text: '예약도서는 도착 알림 후 3일 이내 대출하지 않으면 자동 취소됩니다.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidanceItem({
    required BuildContext context,
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showReservationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.book, color: Colors.blue),
            SizedBox(width: 8),
            Text('도서 예약'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('이 도서를 예약하시겠습니까?'),
            const SizedBox(height: 16),
            Text(
              '현재 2명이 예약 중입니다.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('도서가 예약되었습니다.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('예약'),
          ),
        ],
      ),
    );
  }
}
