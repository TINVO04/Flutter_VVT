import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/account.dart';

// Lớp AccountAPIService cung cấp các phương thức để tương tác với API quản lý tài khoản.
// Sử dụng HTTP requests để thực hiện các thao tác CRUD (Create, Read, Update, Delete) và các chức năng khác như đăng nhập, đổi mật khẩu, v.v.
class AccountAPIService {
  // Singleton instance của AccountAPIService, đảm bảo chỉ có một instance duy nhất trong ứng dụng.
  static final AccountAPIService instance = AccountAPIService._init();

  // URL cơ bản của API, nơi lưu trữ dữ liệu tài khoản.
  final String baseUrl = 'https://my-json-server.typicode.com/lenhattung/testflutter';

  // Constructor private để ngăn việc tạo instance từ bên ngoài.
  AccountAPIService._init();

  // Tạo một tài khoản mới trên API.
  // [account] là đối tượng Account chứa thông tin tài khoản cần tạo.
  // Trả về đối tượng Account nếu tạo thành công, hoặc ném lỗi nếu thất bại.
  Future<Account> createAccount(Account account) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts'),
      headers: {'Content-Type': 'application/json'},
      body: account.toJSON(),
    );

    if (response.statusCode == 201) {
      return Account.fromJSON(response.body);
    } else {
      throw Exception('Failed to create account: ${response.statusCode}');
    }
  }

  // Lấy danh sách tất cả tài khoản từ API.
  // Trả về một danh sách các đối tượng Account nếu thành công, hoặc ném lỗi nếu thất bại.
  Future<List<Account>> getAllAccounts() async {
    final response = await http.get(Uri.parse('$baseUrl/accounts'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Account.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load accounts: ${response.statusCode}');
    }
  }

  // Lấy thông tin tài khoản theo ID.
  // [id] là ID của tài khoản cần lấy.
  // Trả về đối tượng Account nếu tìm thấy, trả về null nếu không tìm thấy, hoặc ném lỗi nếu thất bại.
  Future<Account?> getAccountById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/accounts/$id'));

    if (response.statusCode == 200) {
      return Account.fromMap(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get account: ${response.statusCode}');
    }
  }

  // Lấy thông tin tài khoản theo userId.
  // [userId] là ID của người dùng liên kết với tài khoản.
  // Trả về đối tượng Account nếu tìm thấy, hoặc null nếu không tìm thấy.
  Future<Account?> getAccountByUserId(int userId) async {
    final accounts = await getAllAccounts();
    try {
      return accounts.firstWhere((account) => account.userId == userId);
    } catch (e) {
      return null;
    }
  }

  // Cập nhật thông tin tài khoản trên API.
  // [account] là đối tượng Account chứa thông tin cần cập nhật.
  // Trả về đối tượng Account đã được cập nhật nếu thành công, hoặc ném lỗi nếu thất bại.
  Future<Account> updateAccount(Account account) async {
    final response = await http.put(
      Uri.parse('$baseUrl/accounts/${account.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(account.toMap()),
    );

    if (response.statusCode == 200) {
      return Account.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update account: ${response.statusCode}');
    }
  }

  // Xóa tài khoản theo ID.
  // [id] là ID của tài khoản cần xóa.
  // Trả về true nếu xóa thành công, hoặc ném lỗi nếu thất bại.
  Future<bool> deleteAccount(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/accounts/$id'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete account: ${response.statusCode}');
    }
  }

  // Đếm số lượng tài khoản hiện có trên API.
  // Trả về số lượng tài khoản dưới dạng số nguyên.
  Future<int> countAccounts() async {
    final accounts = await getAllAccounts();
    return accounts.length;
  }

  // Xử lý lỗi chung cho các HTTP response.
  // [response] là HTTP response cần kiểm tra.
  // Ném lỗi nếu mã trạng thái >= 400.
  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception('API error: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  // Đăng nhập vào hệ thống bằng username và password.
  // [username] là tên đăng nhập.
  // [password] là mật khẩu.
  // Trả về đối tượng Account nếu đăng nhập thành công, hoặc null nếu thất bại (tài khoản không tồn tại hoặc không active).
  Future<Account?> login(String username, String password) async {
    final accounts = await getAllAccounts();
    try {
      final account = accounts.firstWhere(
              (account) => account.username == username && account.password == password && account.status == 'active');

      // Cập nhật thời gian đăng nhập gần nhất
      account.lastLogin = DateTime.now().toIso8601String();
      await updateAccount(account);

      return account;
    } catch (e) {
      return null;
    }
  }

  // Cập nhật trạng thái của tài khoản.
  // [id] là ID của tài khoản.
  // [status] là trạng thái mới (ví dụ: "active", "inactive").
  // Trả về đối tượng Account đã được cập nhật.
  Future<Account> updateAccountStatus(int id, String status) async {
    return await patchAccount(id, {'status': status});
  }

  // Đổi mật khẩu của tài khoản.
  // [id] là ID của tài khoản.
  // [oldPassword] là mật khẩu cũ.
  // [newPassword] là mật khẩu mới.
  // Trả về đối tượng Account đã được cập nhật nếu thành công, hoặc ném lỗi nếu mật khẩu cũ không đúng hoặc tài khoản không tồn tại.
  Future<Account> changePassword(int id, String oldPassword, String newPassword) async {
    final account = await getAccountById(id);

    if (account == null) {
      throw Exception('Account not found');
    }

    if (account.password != oldPassword) {
      throw Exception('Incorrect old password');
    }

    return await patchAccount(id, {'password': newPassword});
  }

  // Kiểm tra xem username đã tồn tại trên API hay chưa.
  // [username] là tên đăng nhập cần kiểm tra.
  // Trả về true nếu username đã tồn tại, false nếu chưa.
  Future<bool> isUsernameExists(String username) async {
    final accounts = await getAllAccounts();
    return accounts.any((account) => account.username == username);
  }

  // Cập nhật một phần thông tin tài khoản bằng phương thức PATCH.
  // [id] là ID của tài khoản.
  // [data] là Map chứa các trường cần cập nhật (ví dụ: {'password': 'newPass'}).
  // Trả về đối tượng Account đã được cập nhật nếu thành công, hoặc ném lỗi nếu thất bại.
  Future<Account> patchAccount(int id, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/accounts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return Account.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to patch account: ${response.statusCode}');
    }
  }

  // Lấy danh sách tài khoản theo trạng thái.
  // [status] là trạng thái cần lọc (ví dụ: "active", "inactive").
  // Trả về danh sách các đối tượng Account có trạng thái tương ứng.
  Future<List<Account>> getAccountsByStatus(String status) async {
    final accounts = await getAllAccounts();
    return accounts.where((account) => account.status == status).toList();
  }

  // Reset mật khẩu của tài khoản.
  // [id] là ID của tài khoản.
  // Tạo một mật khẩu ngẫu nhiên và cập nhật trạng thái tài khoản thành "active".
  // Trả về đối tượng Account đã được cập nhật nếu thành công, hoặc ném lỗi nếu tài khoản không tồn tại.
  Future<Account> resetPassword(int id) async {
    final account = await getAccountById(id);

    if (account == null) {
      throw Exception('Account not found');
    }

    // Tạo mật khẩu ngẫu nhiên
    final newPassword = 'Reset${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}';

    return await patchAccount(id, {'password': newPassword, 'status': 'active'});
  }
}