class User {
  final int? id;
  final String name; // Không cho phép null
  final String birthDate;
  final String email;
  final String phone;
  final String city;
  final String gender;
  final String password;
  final String? profileImagePath; // Giữ nullable vì có thể không có ảnh

  User({
    this.id,
    required this.name,
    required this.birthDate,
    required this.email,
    required this.phone,
    required this.city,
    required this.gender,
    required this.password,
    this.profileImagePath,
  });

  // Chuyển từ Map (lấy từ API) sang User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'] ?? '', // Đảm bảo không null
      birthDate: map['birthDate'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
      gender: map['gender'] ?? '',
      password: map['password'] ?? '',
      profileImagePath: map['profileImagePath'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Chuyển từ User sang Map để gửi lên API
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate,
      'email': email,
      'phone': phone,
      'city': city,
      'gender': gender,
      'password': password,
      // Không gửi profileImagePath lên API vì API không lưu file
    };
  }
}