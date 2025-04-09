import 'dart:convert';

// Lớp Account đại diện cho một tài khoản người dùng trong hệ thống.
// Được sử dụng để lưu trữ thông tin tài khoản như username, password, trạng thái, thời gian đăng nhập cuối, v.v.
class Account {
  // ID của tài khoản, có thể null nếu chưa được gán (ví dụ: khi tạo mới).
  int? id;
  // ID của người dùng liên kết với tài khoản này, bắt buộc.
  int userId;
  // Tên đăng nhập của tài khoản, bắt buộc.
  String username;
  // Mật khẩu của tài khoản, bắt buộc.
  String password;
  // Trạng thái của tài khoản (ví dụ: "active", "inactive"), bắt buộc.
  String status;
  // Thời gian đăng nhập cuối cùng của tài khoản, định dạng chuỗi (ví dụ: "2023-10-01 12:00:00"), bắt buộc.
  String lastLogin;
  // Thời gian tạo tài khoản, định dạng chuỗi (ví dụ: "2023-10-01 12:00:00"), bắt buộc.
  String createdAt;

  // Constructor của lớp Account.
  // Các tham số bắt buộc (required) đảm bảo rằng các giá trị cần thiết phải được cung cấp khi tạo đối tượng.
  Account({
    this.id,
    required this.userId,
    required this.username,
    required this.password,
    required this.status,
    required this.lastLogin,
    required this.createdAt,
  });

  // Factory method để tạo một đối tượng Account từ một Map.
  // Được sử dụng khi lấy dữ liệu từ database hoặc API (dữ liệu dạng Map).
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      userId: map['userId'],
      username: map['username'],
      password: map['password'],
      status: map['status'],
      lastLogin: map['lastLogin'],
      createdAt: map['createdAt'],
    );
  }

  // Factory method để tạo một đối tượng Account từ một chuỗi JSON.
  // Chuỗi JSON sẽ được giải mã thành Map, sau đó gọi fromMap để tạo đối tượng.
  factory Account.fromJSON(String source) {
    return Account.fromMap(jsonDecode(source));
  }

  // Phương thức chuyển đổi đối tượng Account thành một Map.
  // Được sử dụng khi cần lưu dữ liệu vào database hoặc gửi lên API.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'password': password,
      'status': status,
      'lastLogin': lastLogin,
      'createdAt': createdAt,
    };
  }

  // Phương thức chuyển đổi đối tượng Account thành chuỗi JSON.
  // Gọi toMap() để lấy Map, sau đó mã hóa thành JSON.
  String toJSON() {
    return jsonEncode(toMap());
  }

  // Phương thức tạo một bản sao của đối tượng Account với các thuộc tính được cập nhật (nếu có).
  // Các thuộc tính không được cung cấp sẽ giữ nguyên giá trị cũ.
  Account copyWith({
    int? id,
    int? userId,
    String? username,
    String? password,
    String? status,
    String? lastLogin,
    String? createdAt,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Phương thức override toString để in thông tin của đối tượng Account dưới dạng chuỗi.
  // Hữu ích khi debug hoặc log thông tin tài khoản.
  @override
  String toString() {
    return 'Account(id: $id, userId: $userId, username: $username, status: $status, lastLogin: $lastLogin, createdAt: $createdAt)';
  }

  // Phương thức override để so sánh hai đối tượng Account.
  // Hai tài khoản được coi là bằng nhau nếu tất cả các thuộc tính đều giống nhau.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Account &&
        other.id == id &&
        other.userId == userId &&
        other.username == username &&
        other.password == password &&
        other.status == status &&
        other.lastLogin == lastLogin &&
        other.createdAt == createdAt;
  }

  // Phương thức override để tạo mã hash cho đối tượng Account.
  // Được sử dụng khi so sánh hoặc lưu trữ đối tượng trong các cấu trúc dữ liệu như Set, Map.
  @override
  int get hashCode {
    return id.hashCode ^
    userId.hashCode ^
    username.hashCode ^
    password.hashCode ^
    status.hashCode ^
    lastLogin.hashCode ^
    createdAt.hashCode;
  }
}