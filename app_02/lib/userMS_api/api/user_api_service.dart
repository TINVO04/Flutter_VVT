import 'dart:convert';
import 'package:http/http.dart' as http;

// Class quản lý API calls
class UserAPIService {
  static final UserAPIService instance = UserAPIService._init();
  final String baseUrl = 'https://my-json-server.typicode.com/TINVO04/test_flutter';

  UserAPIService._init();

  // Create - Thêm user mới
  Future<int> insertUser(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id']; // Giả sử API trả về ID của user mới
    } else {
      throw Exception('Đụ má, thêm user thất bại! Status: ${response.statusCode}');
    }
  }

  // Read - Đọc tất cả users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Đụ má, lấy danh sách user thất bại! Status: ${response.statusCode}');
    }
  }

  // Read - Đọc user theo id
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Đụ má, lấy user theo ID thất bại! Status: ${response.statusCode}');
    }
  }

  // Update - Cập nhật user
  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user),
    );

    if (response.statusCode == 200) {
      return 1; // Giả sử API trả về thành công, trả về 1 để giống SQLite
    } else {
      throw Exception('Đụ má, cập nhật user thất bại! Status: ${response.statusCode}');
    }
  }

  // Delete - Xóa user
  Future<int> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      return 1; // Giả sử API trả về thành công, trả về 1 để giống SQLite
    } else {
      throw Exception('Đụ má, xóa user thất bại! Status: ${response.statusCode}');
    }
  }

  // Đóng (giữ lại cho giống cấu trúc DatabaseHelper, nhưng không làm gì)
  Future close() async {
    // Không cần làm gì vì không dùng SQLite
  }
}