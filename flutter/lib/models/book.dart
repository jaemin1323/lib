/// Book 클래스는 도서 정보를 나타내며, JSON 데이터를 기반으로 객체를 생성하는 기능을 제공합니다. // 역할: 도서 정보를 나타내는 모델
/// 이 클래스는 도서의 ID, 제목, 저자, 출판사, 평점 및 이미지 URL을 포함하며, // 역할: 도서의 속성 정의
/// JSON 형식의 데이터를 사용하여 Book 객체를 생성하는 팩토리 메서드를 제공합니다. // 역할: JSON 데이터를 객체로 변환
class Book {
  final String id; // 도서 ID
  final String title; // 도서 제목
  final String author; // 저자
  final String publisher; // 출판사
  final double rating; // 평점
  final String imageUrl; // 이미지 URL

  Book({
    required this.id, // ID 필수
    required this.title, // 제목 필수
    required this.author, // 저자 필수
    required this.publisher, // 출판사 필수
    required this.rating, // 평점 필수
    required this.imageUrl, // 이미지 URL 필수
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '', // ID 초기화
      title: json['title'] ?? '', // 제목 초기화
      author: json['author'] ?? '', // 저자 초기화
      publisher: json['publisher'] ?? '', // 출판사 초기화
      rating: (json['rating'] ?? 0.0).toDouble(), // 평점 초기화
      imageUrl: json['imageUrl'] ?? '', // 이미지 URL 초기화
    );
  }
}
