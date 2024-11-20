// 이 파일은 도서관 메뉴 화면을 구성하는 위젯을 정의합니다.
// 사용자가 좌석 예약, 대출 현황, 정보, 도서, 학술정보 이용자별 안내 등의 기능에 접근할 수 있는 메뉴를 제공합니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트
import 'package:flutter/services.dart'; // Flutter의 서비스 패키지 임포트
import 'loan_history_screen.dart'; // 대출 기록 화면
import 'loan_extension_screen.dart'; // 대출 연장 화면
import 'usage_history_screen.dart'; // 이용 내역 화면
import 'seat_status_screen.dart'; // 좌석 현황 화면
import 'notice_screen.dart'; // 공지사항 화면
import 'popular_book_screen.dart'; // 인기 도서 화면
import 'recommended_books_screen.dart'; // 추천 도서 화면
import 'student_info_screen.dart'; // 학생 정보 화면
import 'alumni_info_screen.dart'; // 졸업생 정보 화면
import 'staff_info_screen.dart'; // 직원 정보 화면
import 'other_info_screen.dart'; // 기타 정보 화면
import '../constants/urls.dart'; // URL 상수 파일 임포트

// 각 화면 클래스들을 먼저 정의
class SeatChangeScreen extends StatelessWidget {
  const SeatChangeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('좌석 변경')),
      body: const Center(child: Text('좌석 변경 화면')),
    );
  }
}

// 나머지 화면 클래스들도 동일한 패턴으로 구현
class ReservationChangeScreen extends StatelessWidget {
  const ReservationChangeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('예약 변경')),
      body: const Center(child: Text('예약 변경 화면')),
    );
  }
}

// ... 다른 화면 클래스들 생략 ...

class LibraryMenuScreen extends StatefulWidget {
  const LibraryMenuScreen({super.key});

  @override
  State<LibraryMenuScreen> createState() => _LibraryMenuScreenState();
}

class _LibraryMenuScreenState extends State<LibraryMenuScreen> {
  late final List<Map<String, dynamic>> _allMenuItems;

  @override
  void initState() {
    super.initState();
    _initializeMenuItems();
  }

  void _initializeMenuItems() {
    _allMenuItems = [
      {
        'category': '좌석 예약',
        'icon': Icons.chair,
        'items': [
          {
            'title': '좌석 변경',
            'screen': const SeatChangeScreen(),
            'icon': Icons.swap_horiz
          },
          {
            'title': '예약 변경',
            'screen': const ReservationChangeScreen(),
            'icon': Icons.edit_calendar
          },
          {
            'title': '좌석 현황',
            'screen': const SeatStatusScreen(),
            'icon': Icons.grid_view
          },
          {
            'title': '이용 내역',
            'screen': const UsageHistoryScreen(),
            'icon': Icons.history
          },
        ],
      },
      {
        'category': '대출 현황',
        'icon': Icons.book,
        'items': [
          {
            'title': '대출 연장',
            'screen': const LoanExtensionScreen(),
            'icon': Icons.update
          },
          {
            'title': '대출 기록',
            'screen': const LoanHistoryScreen(),
            'icon': Icons.history_edu
          },
        ],
      },
      {
        'category': '정보',
        'icon': Icons.info,
        'items': [
          {
            'title': '공지사항',
            'screen': const NoticeScreen(),
            'icon': Icons.notifications
          },
          {
            'title': '자료 구입신청',
            'onTap': () => _handlePurchaseRequest(),
            'icon': Icons.shopping_cart
          },
        ],
      },
      {
        'category': '도서',
        'icon': Icons.library_books,
        'items': [
          {
            'title': '인기도서',
            'screen': const PopularBookScreen(),
            'icon': Icons.trending_up
          },
          {
            'title': '추천도서',
            'screen': const RecommendedBooksScreen(),
            'icon': Icons.recommend
          },
        ],
      },
      {
        'category': '학술정보 이용자별 안내',
        'icon': Icons.school,
        'items': [
          {
            'title': '재학생',
            'screen': const StudentInfoScreen(),
            'icon': Icons.person
          },
          {
            'title': '휴학생 및 졸업생',
            'screen': const AlumniInfoScreen(),
            'icon': Icons.people
          },
          {
            'title': '교직원',
            'screen': const StaffInfoScreen(),
            'icon': Icons.work
          },
          {
            'title': '기타',
            'screen': const OtherInfoScreen(),
            'icon': Icons.more_horiz
          },
        ],
      },
    ];
  }

  // URL 실행이 필요한 곳에서는 LibraryUrls.launchURL 사용
  Future<void> _handlePurchaseRequest() async {
    if (!mounted) return;
    await LibraryUrls.launchURL(
      LibraryUrls.PURCHASE_REQUEST,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('도서관 메뉴'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView.builder(
        itemCount: _allMenuItems.length,
        itemBuilder: (context, index) {
          final category = _allMenuItems[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Row(
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category['category'],
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              ...((category['items'] as List).map((item) => ListTile(
                    leading: Icon(item['icon'] as IconData),
                    title: Text(
                      item['title'],
                      style: theme.textTheme.titleMedium,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      if (item.containsKey('onTap')) {
                        item['onTap']();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => item['screen'],
                          ),
                        );
                      }
                    },
                  ))),
              const Divider(),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
