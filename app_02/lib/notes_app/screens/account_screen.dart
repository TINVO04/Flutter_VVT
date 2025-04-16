import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/account_api_service.dart';
import '../data/note_account.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AccountApiService _apiService = AccountApiService();
  bool _isLoading = false;
  String? _errorMessage;
  int? _accountId;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _accountId = int.tryParse(prefs.getString('accountId') ?? '');
      _usernameController.text = prefs.getString('username') ?? '';
    });
  }

  Future<void> _updateAccount() async {
    if (_accountId == null) {
      setState(() {
        _errorMessage = 'Không tìm thấy tài khoản';
      });
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập đầy đủ thông tin';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final account = Account(
        id: _accountId,
        userId: _accountId!,
        username: username,
        password: password,
        status: 'active',
        lastLogin: DateTime.now().toIso8601String(),
        createdAt: DateTime.now().toIso8601String(),
      );

      await _apiService.updateAccount(account);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Cập nhật tài khoản thất bại: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa tài khoản'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Tên đăng nhập',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                errorText: _errorMessage != null && _usernameController.text.isEmpty
                    ? 'Tên đăng nhập không được để trống'
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                errorText: _errorMessage != null && _passwordController.text.isEmpty
                    ? 'Mật khẩu không được để trống'
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null && !_usernameController.text.isEmpty && !_passwordController.text.isEmpty)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cập nhật',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}