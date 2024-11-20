// 하단 네비게이션 바 아이템을 정의하는 파일입니다.
import 'package:flutter/material.dart';

final List<BottomNavigationBarItem> bottomNavigationItems = const [
  BottomNavigationBarItem(icon: Icon(Icons.menu), label: '메뉴'),
  BottomNavigationBarItem(icon: Icon(Icons.people), label: '좌석'),
  BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
  BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
];
