import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/User.dart'; // Cập nhật import

// Lớp UserAPIService cung cấp các phương thức để tương tác với API quản lý người dùng.
// Sử dụng HTTP requests để thực hiện các thao tác CRUD (Create, Read, Update, Delete).
class UserAPIService {
  // Singleton instance của UserAPIService, đảm bảo chỉ có một instance duy nhất trong ứng dụng.
  static final UserAPIService instance = UserAPIService._init();

  // URL cơ bản của API, nơi lưu trữ dữ liệu người dùng.
  final String baseUrl = 'https://my-json-server.typicode.com/lenhattung/testflutter';

  // Constructor private để ngăn việc tạo instance từ bên ngoài.
  UserAPIService._init();

  // Tạo một người dùng mới trên API.
  // [user] là Map chứa thông tin người dùng cần tạo.
  // Trả về ID của người dùng mới nếu thành công, hoặc ném lỗi nếu thất bại.
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

  // Lấy danh sách tất cả người dùng từ API.
  // Trả về danh sách các Map chứa thông tin người dùng nếu thành công, hoặc ném lỗi nếu thất bại.
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Đụ má, lấy danh sách user thất bại! Status: ${response.statusCode}');
    }
  }

  // Lấy thông tin người dùng theo ID.
  // [id] là ID của người dùng cần lấy.
  // Trả về Map chứa thông tin người dùng nếu tìm thấy, trả về null nếu không tìm thấy, hoặc ném lỗi nếu thất bại.
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

  // Cập nhật thông tin người dùng trên API.
  // [id] là ID của người dùng cần cập nhật.
  // [user] là Map chứa thông tin cần cập nhật.
  // Trả về 1 nếu thành công (để giống SQLite), hoặc ném lỗi nếu thất bại.
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

  // Xóa người dùng theo ID.
  // [id] là ID của người dùng cần xóa.
  // Trả về 1 nếu thành công (để giống SQLite), hoặc ném lỗi nếu thất bại.
  Future<int> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      return 1; // Giả sử API trả về thành công, trả về 1 để giống SQLite
    } else {
      throw Exception('Đụ má, xóa user thất bại! Status: ${response.statusCode}');
    }
  }

  // Phương thức đóng (giữ lại để tương thích với cấu trúc DatabaseHelper, nhưng không làm gì).
  Future close() async {
    // Không cần làm gì vì không dùng SQLite
  }
}