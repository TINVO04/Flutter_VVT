import 'dart:convert';
import 'package:app_02/notes_app/data/note_account.dart';
import 'package:http/http.dart' as http;

class AccountApiService {
  static const String baseUrl = 'https://notes-api-zrfp.onrender.com';

  Future<Account?> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Tên đăng nhập và mật khẩu không được để trống');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/accounts?username=$username&password=$password'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.isNotEmpty ? Account.fromMap(data.first) : null;
      } else {
        throw Exception('Lỗi đăng nhập: Mã trạng thái ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi đăng nhập: ${e.toString()}');
    }
  }

  Future<Account> register(Account account) async {
    if (account.username.isEmpty || account.password.isEmpty) {
      throw Exception('Thông tin tài khoản không hợp lệ');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(account.toMap()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return Account.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Lỗi đăng ký: Mã trạng thái ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi đăng ký: ${e.toString()}');
    }
  }

  Future<void> updateLastLogin(int id, String lastLogin) async {
    if (id <= 0 || lastLogin.isEmpty) {
      throw Exception('ID hoặc thời gian đăng nhập không hợp lệ');
    }

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/accounts/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'lastLogin': lastLogin}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Lỗi cập nhật thời gian: Mã trạng thái ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật thời gian đăng nhập: ${e.toString()}');
    }
  }

  Future<void> updateAccount(Account account) async {
    if (account.id == null || account.username.isEmpty) {
      throw Exception('Thông tin tài khoản không hợp lệ');
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/accounts/${account.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(account.toMap()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Lỗi cập nhật tài khoản: Mã trạng thái ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật tài khoản: ${e.toString()}');
    }
  }
}