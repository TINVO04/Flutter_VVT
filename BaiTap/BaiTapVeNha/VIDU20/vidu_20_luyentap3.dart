//📌 Bài tập tiếp theo:
// 💡 Yêu cầu: Viết chương trình cho phép người dùng nhập vào danh bạ (phonebook), sau đó thực hiện các chức năng sau:

// Thêm liên hệ mới: Nhập tên và số điện thoại, sau đó lưu vào danh bạ.
// Tìm kiếm liên hệ: Nhập tên, nếu có trong danh bạ thì hiển thị số điện thoại, nếu không thì thông báo không tìm thấy.
// Xóa liên hệ theo tên: Nếu tên có trong danh bạ thì xóa, ngược lại thông báo không tồn tại.
// Xóa các số bắt đầu bằng một chuỗi: Nhập chuỗi số và xóa tất cả số điện thoại bắt đầu bằng chuỗi đó.
// Hiển thị danh bạ: In toàn bộ danh bạ ra màn hình.
// Thoát chương trình

import 'dart:io';

import 'vidu_20_luyentap2.dart';

void main() {
  Map<String, String> phoneBook = {};

  while (true) {
    print("\n📞 QUẢN LÝ DANH BẠ");
    print("1. Thêm liên hệ mới (Nếu chưa có)");
    print("2. Xoá liên hệ bắt đầu bằng chuỗi số. ");
    print("3. Hiển thị danh bạ");
    print("4. Xóa liên hệ theo Tên. ");
    print("5. Thoát");
    stdout.write("Chọn chức năng: ");

    String choice = stdin.readLineSync() ?? '';

    switch (choice) {
      case '1':
        addContact(phoneBook);
        break;
      case '2':
        removeChoiceContacts(phoneBook);
        break;
      case '3':
        showContact(phoneBook);
        break;
      case '4':
        removeByNamePhone(phoneBook);
        break;
      case '5':
        print('Thoát Chương Trình');
        return;
    }
  }
}

//thêm liên hệ mới
void addContact(Map<String, String> phoneBook) {
  stdout.write('Nhập tên Liên Hệ Mới: ');
  String name = stdin.readLineSync() ?? '';
  if (!phoneBook.containsKey(name)) {
    stdout.write('Nhập số điện thoại: ');
    String phone = stdin.readLineSync() ?? '';
    if (!phoneBook.containsValue(phone)) {
      phoneBook[name] = phone;
      print('Thêm thành công $name có số $phone !!');
    } else {
      print('Số của liên hệ này đã tồn tại!!');
    }
  } else {
    print('Tên liên hệ này đã tồn tại!!');
  }
}

//In danh ba
void showContact(Map<String, String> phoneBook) {
  if (phoneBook.isEmpty) {
    print('Danh Ba Trong!!');
  } else {
    phoneBook.forEach((name, phone) {
      print('- $name: $phone');
    });
  }
}

//Xoa danh ba theo ten
void removeByNamePhone(Map<String, String> phoneBook) {
  stdout.write('Nhập tên liên hệ cần xóa: ');
  String name = stdin.readLineSync() ?? '';

  if (!phoneBook.containsKey(name)) {
    print('Tên không tồn tại');
  } else {
    phoneBook.remove(name);
    print('Xóa liên hệ $name thành công!!');
  }
}

//Xoa liên hệ bắt đầu bằng chuỗi số
void removeChoicePhone(Map<String, String> phoneBook) {
  stdout.write('Xóa những liên hệ bắt đầu từ những số: ');
  String phone = stdin.readLineSync() ?? '';

  phoneBook.removeWhere((key, value) => value.startsWith(phone));
}
