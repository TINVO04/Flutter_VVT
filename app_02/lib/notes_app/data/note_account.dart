import 'dart:convert';

class Account {
  final int? id;
  final int userId;
  final String username;
  final String password;
  final String status;
  final String lastLogin;
  final String createdAt;

  Account({
    this.id,
    required this.userId,
    required this.username,
    required this.password,
    required this.status,
    required this.lastLogin,
    required this.createdAt,
  }) {
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Tên đăng nhập và mật khẩu không được để trống');
    }
    if (userId <= 0) {
      throw ArgumentError('User ID phải lớn hơn 0');
    }
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: int.tryParse(map['id']?.toString() ?? ''),
      userId: int.tryParse(map['userId']?.toString() ?? '0') ?? 0,
      username: map['username'] as String? ?? '',
      password: map['password'] as String? ?? '',
      status: map['status'] as String? ?? 'inactive',
      lastLogin: map['lastLogin'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
    );
  }

  factory Account.fromJson(String source) => Account.fromMap(jsonDecode(source));

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'username': username,
      'password': password,
      'status': status,
      'lastLogin': lastLogin,
      'createdAt': createdAt,
    };
  }

  String toJson() => jsonEncode(toMap());

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

  @override
  String toString() {
    return 'Account(id: $id, userId: $userId, username: $username, status: $status)';
  }

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

  @override
  int get hashCode {
    return Object.hash(id, userId, username, password, status, lastLogin, createdAt);
  }
}