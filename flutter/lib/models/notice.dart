class Notice {
  final String title; // 공지 제목
  final String date; // 공지 날짜
  final String url; // 공지 링크
  final String category; // 공지 카테고리

  Notice({
    required this.title, // 제목 필수
    required this.date, // 날짜 필수
    required this.url, // 링크 필수
    required this.category, // 카테고리 필수
  });
}
