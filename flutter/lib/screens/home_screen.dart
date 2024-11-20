// 이 파일은 홈 화면을 구성하는 위젯을 정의합니다.
// 메타버스 카드, 아이콘 메뉴, 공지사항 및 인기 도서 섹션을 포함합니다.
import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트
import 'notice_screen.dart'; // 공지사항 화면 임포트
import 'loan_status_screen.dart'; // 대출 현황 화면 임포트
import 'popular_book_screen.dart'; // 인기 도서 화면 임포트
import '../services/notice_service.dart'; // 경로 수정
import '../models/notice.dart'; // Notice 모델 추가
import '../constants/urls.dart'; // URL 상수 파일 임포트

class HomeScreen extends StatelessWidget {
  // 홈 화면 클래스 정의
  const HomeScreen({super.key}); // 생성자

  @override
  Widget build(BuildContext context) {
    // UI 빌드 메서드
    return SingleChildScrollView(
      // 스크롤 가능한 단일 자식 위젯
      child: SafeArea(
        // 안전 영역 내에서 UI 구성
        child: Column(
          // 세로 방향으로 자식 위젯을 배치
          children: [
            _buildMetaverseCard(), // 메타버스 카드 빌드
            _buildIconMenu(context), // 아이콘 메뉴 빌드
            _buildNoticeSection(context), // 공지사항 섹션 빌드
            _buildPopularBooksSection(context), // 인기 도서 섹션 빌드
          ],
        ),
      ),
    );
  }

  Widget _buildMetaverseCard() {
    // 메타버스 카드 빌드 메서드
    return Container(
      // 컨테이너 위젯
      margin: const EdgeInsets.all(16), // 외부 여백 설정
      height: 200, // 높이 설정
      decoration: BoxDecoration(
        // 배경 스타일 설정
        borderRadius: BorderRadius.circular(12), // 둥근 모서리 설정
        color: Colors.purple[200], // 배경 색상 설정
      ),
      child: const Stack(
        // 스택 위젯
        children: [
          Positioned(
            // 위치 지정 위젯
            left: 16, // 왼쪽 여백
            bottom: 16, // 아래쪽 여백
            child: Column(
              // 세로 방향으로 자식 위젯 배치
              crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
              children: [
                Text(
                  // 텍스트 위젯
                  '추천도서', // 텍스트 내용
                  style: TextStyle(color: Colors.white, fontSize: 14), // 스타일 설정
                ),
                Text(
                  // 텍스트 위젯
                  '메타버스', // 텍스트 내용
                  style: TextStyle(
                    color: Colors.white, // 텍스트 색상
                    fontSize: 24, // 텍스트 크기
                    fontWeight: FontWeight.bold, // 텍스트 두께
                  ),
                ),
                Text(
                  // 텍스트 위젯
                  '당신은 메타버스에 살고 있는가?', // 텍스트 내용
                  style: TextStyle(color: Colors.white, fontSize: 16), // 스타일 설정
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconMenu(BuildContext context) {
    // 아이콘 메뉴 빌드 메서드
    final List<Map<String, dynamic>> menuItems = [
      // 메뉴 아이템 리스트
      {
        'icon': Icons.notifications, // 아이콘
        'label': '공지사항', // 레이블
        'onTap': () => Navigator.push(
              // 탭 시 동작
              context,
              MaterialPageRoute(
                  builder: (context) => const NoticeScreen()), // 공지사항 화면으로 이동
            ),
      },
      {
        'icon': Icons.calendar_today, // 아이콘
        'label': '대출현황', // 레이블
        'onTap': () => Navigator.push(
              // 탭 시 동작
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const LoanStatusScreen()), // 대출 현황 화면으로 이동
            ),
      },
      {
        'icon': Icons.library_books, // 아이콘
        'label': '자료 구입신청', // 레이블
        'onTap': () {
          LibraryUrls.launchURL(LibraryUrls.PURCHASE_REQUEST, context: context);
        },
      },
      {
        'icon': Icons.public, // 아이콘
        'label': '학술정보', // 레이블
        'onTap': () {
          LibraryUrls.launchURL(LibraryUrls.ACADEMIC_INFO, context: context);
        },
      },
    ];

    return Container(
      // 컨테이너 위젯
      padding: const EdgeInsets.symmetric(vertical: 16), // 수직 여백 설정
      child: Row(
        // 수평 방향으로 자식 위젯 배치
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 균등 배치
        children: menuItems
            .map((item) => _buildIconMenuItem(item, context))
            .toList(), // 메뉴 아이템 빌드
      ),
    );
  }

  Widget _buildIconMenuItem(Map<String, dynamic> item, BuildContext context) {
    return GestureDetector(
      onTap: item['onTap'],
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(item['icon'], size: 30, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            item['label'],
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('공지사항',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NoticeScreen()),
                ),
                child: const Text('더보기',
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<Notice>>(
            future: NoticeService().fetchNotices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                    child: Text('공지사항을 불러오는데 실패했습니다: ${snapshot.error}'));
              }

              final notices = snapshot.data ?? [];
              return Column(
                children: notices
                    .map((notice) => _buildNoticeItem(context, notice))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(BuildContext context, Notice notice) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeScreen(
              initialUrl: notice.url,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                notice.category,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                notice.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              notice.date,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularBooksSection(BuildContext context) {
    // 인기 도서 섹션 빌드 메서드
    return Container(
      // 컨테이너 위젯
      padding: const EdgeInsets.all(16), // 여백 설정
      child: Column(
        // 세로 방향으로 자식 위젯 배치
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          Row(
            // 수평 방향으로 자식 위젯 배치
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 균등 배치
            children: [
              const Text('인기도서', // 텍스트 위젯
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)), // 스타일 설정
              TextButton(
                // 텍스트 버튼
                onPressed: () => Navigator.push(
                  // 탭 시 동작
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PopularBookScreen()), // 인기 도서 화면으로 이동
                ),
                child: const Text('더보기', // 텍스트 위젯
                    style:
                        TextStyle(color: Colors.grey, fontSize: 14)), // 스타일 설정
              ),
            ],
          ),
          const SizedBox(height: 12), // 여백 설정
          SizedBox(
            // 고정 높이의 위젯
            height: 160, // 높이 설정
            child: ListView.builder(
              // 리스트 뷰 빌더
              scrollDirection: Axis.horizontal, // 수평 스크롤
              itemCount: 5, // 아이템 수
              itemBuilder: (context, index) => _buildBookItem(), // 도서 아이템 빌드
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookItem() {
    // 도서 아이템 빌드 메서드
    return Container(
      // 컨테이너 위젯
      width: 100, // 너비 설정
      margin: const EdgeInsets.only(right: 16), // 오른쪽 여백 설정
      child: Column(
        // 세로 방향으로 자식 위젯 배치
        children: [
          Container(
            // 도서 이미지 컨테이너
            height: 140, // 높이 설정
            decoration: BoxDecoration(
              // 배경 스타일 설정
              color: Colors.grey[300], // 배경 색상 설정
              borderRadius: BorderRadius.circular(8), // 둥근 모서리 설정
            ),
          ),
          const SizedBox(height: 8), // 여백 설정
          const Text(
            // 텍스트 위젯
            '도서명', // 도서명
            style: TextStyle(fontSize: 12), // 스타일 설정
            maxLines: 1, // 최대 줄 수
            overflow: TextOverflow.ellipsis, // 오버플로우 처리
          ),
        ],
      ),
    );
  }
}
