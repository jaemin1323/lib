import 'package:flutter/material.dart'; // Flutter의 Material 디자인 패키지 임포트
import '../services/user_service.dart'; // UserService 임포트 추가

class LoginScreen extends StatefulWidget {
  final Function(String) onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String studentId = _studentIdController.text.trim();
    String password = _passwordController.text.trim();

    if (studentId.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = '학번과 비밀번호를 입력하세요.';
        _isLoading = false;
      });
      return;
    }

    try {
      // 실제 백엔드 연동 시 이 부분을 수정하면 됩니다
      final userService = UserService();
      final bool isValid = await userService.login(studentId, password);

      if (isValid) {
        widget.onLoginSuccess(studentId);
      } else {
        setState(() {
          _errorMessage = '학번 또는 비밀번호가 올바르지 않습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '로그인 중 오류가 발생했습니다.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _studentIdController,
              decoration: const InputDecoration(
                labelText: '학번',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text, // 숫자뿐만 아니라 문자도 허용
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Text('로그인'),
              ),
            ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
