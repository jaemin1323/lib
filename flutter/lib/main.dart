// 이 파일은 도서관 앱의 메인 진입점으로, 앱의 전체 구조와 화면 전환을 관리합니다.
// Flutter Material 패키지와 로컬라이제이션을 사용하여 다국어 지원을 제공합니다.
import 'package:flutter/material.dart'; // Flutter Material 패키지 임포트
import 'package:flutter_localizations/flutter_localizations.dart'; // Flutter 로컬라이제이션 패키지 임포트
import 'theme/app_theme.dart'; // 앱의 테마 설정을 위한 파일 임포트
import 'navigation/bottom_navigation_items.dart'; // 하단 내비게이션 아이템을 위한 파일 임포트
import 'package:provider/provider.dart'; // 상태 관리를 위한 Provider 패키지 임포트
import 'providers/auth_provider.dart'; // 인증 관련 상태 관리를 위한 프로바이더 임포트
import 'builders/screen_builder.dart'; // 화면 빌더 관련 파일 임포트
import 'services/navigation_service.dart'; // 내비게이션 서비스를 위한 파일 임포트
import 'screens/settings_screen.dart'; // SettingsScreen import 추가

// 라우트 관찰자를 생성하여 화면 전환을 추적합니다.
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

// 앱의 진입점
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(), // 인증 상태를 관리하는 프로바이더 생성
      child: const MyApp(), // MyApp 위젯 실행
    ),
  );
}

// 앱의 기본 구조를 정의하는 위젯
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey, // 내비게이션 키 설정
      navigatorObservers: [routeObserver], // 라우트 관찰자 추가
      title: '도서관 앱', // 앱 제목
      theme: AppTheme.lightTheme, // 라이트 테마 설정
      darkTheme: AppTheme.darkTheme, // 다크 테마 설정
      home: const MainScreen(), // 기본 화면 설정
      routes: {
        '/settings': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final onLogout = arguments?['onLogout'] as VoidCallback?;

          if (onLogout == null) {
            Navigator.pop(context);
            return const SizedBox.shrink();
          }

          return SettingsScreen(onLogout: onLogout);
        },
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate, // 다국어 지원을 위한 위젯
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'), // 지원하는 로케일 설정 (한국어)
      ],
    );
  }
}

// 메인 화면을 정의하는 위젯
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// 메인 화면의 상태를 관리하는 클래스
class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // 홈 탭을 기본으로 선택

  // 로그인 성공 시 호출되는 메서드
  void _onLoginSuccess(String studentId) {
    context.read<AuthProvider>().login(studentId); // 인증 프로바이더에 로그인 정보 전달
  }

  // 로그아웃 시 호출되는 메서드
  void _onLogout() {
    context.read<AuthProvider>().logout(); // 인증 프로바이더에 로그아웃 요청
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>(); // 인증 상태를 감시

    return Scaffold(
      body: ScreenBuilder.buildMainScreen(
        _selectedIndex, // 선택된 인덱스
        authProvider, // 인증 프로바이더
        _onLogout, // 로그아웃 메서드
        _onLoginSuccess, // 로그인 성공 메서드
      ),
      bottomNavigationBar: _buildBottomNavigationBar(), // 하단 내비게이션 바 생성
    );
  }

  // 하단 내비게이션 바를 생성하는 메서드
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // 고정형 내비게이션 바
      currentIndex: _selectedIndex, // 현재 선택된 인덱스
      onTap: (index) {
        setState(() {
          _selectedIndex = index; // 선택된 인덱스 업데이트
        });
      },
      items: bottomNavigationItems, // 내비게이션 아이템 목록
      selectedItemColor: Colors.blue, // 선택된 아이템 색상
    );
  }
}
