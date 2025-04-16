// Bài đầu tiên bạn cần làm là "Quản lý danh bạ điện thoại" bằng Map trong Dart.

// 📌 Yêu cầu bài toán
// Viết chương trình quản lý danh bạ điện thoại.
// Sử dụng Map<String, String> để lưu danh bạ, trong đó:
// Key là tên của người trong danh bạ.
// Value là số điện thoại của người đó.
// Cung cấp các chức năng sau:
// Thêm liên hệ vào danh bạ.
// Tìm số điện thoại theo tên.
// Hiển thị toàn bộ danh bạ.
// Xóa một liên hệ khỏi danh bạ.

import 'dart:io';

void main() {
  Map<String, String> phoneBook = {};

  while (true) {
    print("\n📞 QUẢN LÝ DANH BẠ");
    print("1. Thêm liên hệ");
    print("2. Tìm số điện thoại");
    print("3. Hiển thị danh bạ");
    print("4. Xóa liên hệ");
    print("5. Thoát");
    stdout.write("Chọn chức năng: ");

    String choice = stdin.readLineSync() ?? '';

    switch (choice) {
      case '1':
        addContact(phoneBook);
        break;
      case '2':
        findContact(phoneBook);
        break;
      case '3':
        showContacts(phoneBook);
        break;
      case '4':
        removeContact(phoneBook);
        break;
      case '5':
        print('Thoát chương trình');
        return;
      default:
        print('Lựa chọn không hợp lệ, vui lòng chọn lại. ');
    }
  }
}

//hàm thêm liên hệ vào danh bạ
void addContact(Map<String, String> phoneBook) {
  stdout.write('Nhap ten: ');
  String name = stdin.readLineSync() ?? '';
  stdout.write('Nhap so dien thoai: ');
  String phone = stdin.readLineSync() ?? '';

  phoneBook[name] = phone;
  print('Đã thêm Liên Hệ $name: $phone');
}

//Hàm tìm số điện thoại theo tên
void findContact(Map<String, String> PhoneBook) {
  stdout.write('Nhập tên cần tìm: ');
  String name = stdin.readLineSync() ?? '';

  if (PhoneBook.containsKey(name)) {
    print('Số điện thoại của $name là: ${PhoneBook[name]}');
  } else {
    print('Không tìm thất liên hệ với tên $name');
  }
}

//Hiển thị danh bạ điện thoại
void showContacts(Map<String, String> phoneBook) {
  if (phoneBook.isEmpty) {
    print('Danh bạ Trống');
  } else {
    print('Danh bạ hiện tại: ');
    phoneBook.forEach((name, phone) {
      print("- $name: $phone");
    });
  }
}

//Xoá liên hệ ra khỏi danh bạ
void removeContact(Map<String, String> phoneBook) {
  stdout.write('Nhập tên cần xóa: ');
  String name = stdin.readLineSync() ?? '';

  // /Hàm remove() trả về giá trị (value) của key vừa bị xóa nếu key tồn tại.
  //Nếu key không tồn tại, hàm remove() sẽ trả về null.
  if (phoneBook.remove(name) != null) {
    print('Đã xóa liên hệ $name');
  } else {
    print('Không tìm thấy liên hệ $name ');
  }
}
