// 이 파일은 도서 검색 화면을 구성하는 위젯을 정의합니다.
// 사용자가 도서명, 저자, 출판사 등을 검색할 수 있으며, 최근 검색어를 저장하고 관리하는 기능을 제공합니다.

import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 패키지 임포트
import '../models/book.dart'; // 상대 경로로 수정
import 'book_detail_screen.dart'; // 도서 상세 화면 임포트
import 'package:flutter/services.dart'; // 앱 종료를 위한 import 추가
import '../main.dart'; // RouteObserver import
import '../services/book_service.dart'; // 백엔드 서비스 임포트

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with RouteAware {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _hasSearched = false;
  bool _isLoading = false;
  List<String> recentSearches = [];
  List<Book> searchResults = [];
  String? _errorMessage;
  final BookService _bookService = BookService();
  DateTime? _lastPressedAt; // 마지막으로 뒤가기 버튼을 누른 간

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _searchController.addListener(_onSearchChanged);

    // 화면이 처음 생성될 때 포커스 해제
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.unfocus();
    });
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _hasSearched = false;
      });
    }
  }

  void _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  void _saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentSearches', recentSearches);
  }

  void _addSearchItem(String query) {
    if (query.isEmpty) return;

    setState(() {
      recentSearches.remove(query);
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }
    });
    _saveRecentSearches();
  }

  void _removeSearchItem(String query) {
    setState(() {
      recentSearches.remove(query);
    });
    _saveRecentSearches();
  }

  void _handleSearch() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      setState(() {
        _hasSearched = true;
        _addSearchItem(query);
      });
      FocusScope.of(context).unfocus();
    }
  }

  void _clearAllSearches() async {
    setState(() {
      recentSearches.clear();
    });
    _saveRecentSearches();
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _hasSearched = true;
    });

    try {
      final results = await _bookService.searchBooks(query);
      setState(() {
        searchResults = results;
        _isLoading = false;
      });

      // 검색어 저장
      _addSearchItem(query);
    } catch (e) {
      setState(() {
        _errorMessage = '도서 검색 중 오류가 발생했습니다.';
        _isLoading = false;
        searchResults = [];
      });
      print('검색 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: _buildSearchBar(),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _hasSearched ? _buildSearchResults() : _buildSearchHistory(),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_hasSearched) {
      // 검색 결과 화면일 경우 최근 검색어 목록으로 돌아가기
      setState(() {
        _hasSearched = false;
        _searchController.clear();
      });
      return false;
    } else if (recentSearches.isNotEmpty) {
      // 최근 검색어가 있는 경우 최근 검색어 목록 표시
      setState(() {
        _hasSearched = false;
      });
      return false;
    } else {
      // 최근 검색어가 없는 경우 앱 종료 여부 확인
      if (_lastPressedAt == null ||
          DateTime.now().difference(_lastPressedAt!) >
              const Duration(seconds: 2)) {
        // 처음 누르거나 2초가 지난 후 다시 누른 경우
        _lastPressedAt = DateTime.now();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('한번 더 누르면 앱이 종료됩니다'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
      return true; // 2초 이내에 두 번 누른 경우 앱 종료
    }
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      textInputAction: TextInputAction.search,
      autofocus: false,
      onSubmitted: (_) => _handleSearch(),
      decoration: InputDecoration(
        hintText: '도서명, 저자, 출판사 검색',
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _handleSearch,
        ),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '최근 검색',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (recentSearches.isNotEmpty)
                TextButton(
                  onPressed: _clearAllSearches,
                  child: const Text(
                    '전체 삭제',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recentSearches.length,
            itemBuilder: (context, index) {
              final query = recentSearches[index];
              return ListTile(
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _removeSearchItem(query),
                ),
                onTap: () {
                  _searchController.text = query;
                  _handleSearch();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (!_hasSearched) {
      return const Center(
        child: Text('검색어를 입력하세요.'),
      );
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!),
      );
    }

    if (searchResults.isEmpty) {
      return const Center(
        child: Text('검색 결과가 없습니다.'),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return _buildBookItem(searchResults[index]);
      },
    );
  }

  Widget _buildBookItem(Book book) {
    return InkWell(
      onTap: () {
        print('도서 아이템 탭됨: ${book.title}');
        _navigateToBookDetail(book);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: book.imageUrl.isNotEmpty
                  ? Image.network(
                      book.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
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
                      child:
                          const Icon(Icons.book, size: 50, color: Colors.grey),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    book.publisher,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBookDetail(Book book) {
    print('도서 상세 화면으로 이동 시도: ${book.title}');
    print(
        'Book 객체 정보: id=${book.id}, author=${book.author}, publisher=${book.publisher}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailScreen(book: book),
      ),
    ).then((_) {
      print('도서 상세 화면에서 돌아옴');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didPushNext() {
    // 다른 화면으로 이동할 때
    _searchFocusNode.unfocus();
  }

  @override
  void didPopNext() {
    // 다른 화면에서 돌아올 때
    _searchFocusNode.unfocus();
  }
}
