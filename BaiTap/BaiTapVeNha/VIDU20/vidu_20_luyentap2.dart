// 📝 Bài tập áp dụng kiến thức nâng cao về Map
// Bài tập 1: Cập nhật và xóa nhiều phần tử trong danh bạ
// Viết chương trình quản lý danh bạ điện thoại, cho phép:

// Thêm liên hệ mới (nếu chưa có).
// Cập nhật số điện thoại nếu liên hệ đã tồn tại.
// Xóa tất cả liên hệ có số điện thoại bắt đầu bằng "090".
// In danh sách danh bạ sau khi cập nhật.

import 'dart:io';

void main() {
  Map<String, String> phoneBook = {};

  while (true) {
    print("\n📞 QUẢN LÝ DANH BẠ");
    print("1. Thêm liên hệ mới (Nếu chưa có)");
    print("2. Cập nhật sdt ");
    print("3. Hiển thị danh bạ");
    print("4. Xóa liên hệ có sdt bắt đâu bằng.");
    print("5. Thoát");
    stdout.write("Chọn chức năng: ");

    String choice = stdin.readLineSync() ?? '';

    switch (choice) {
      case '1':
        addContact(phoneBook);
        break;
      case '2':
        updateContact(phoneBook);
        break;
      case '3':
        showContacts(phoneBook);
        break;
      case '4':
        removeChoiceContacts(phoneBook);
        break;
      case '5':
        print('Thoát chương trình');
        return;
      default:
        print('Lựa chọn không hợp lệ, vui lòng chọn lại. ');
    }
  }
}

//Thêm liên hệ mới nếu chưa có
void addContact(Map<String, String> phoneBook) {
  stdout.write('Nhap ten Lien He: ');
  String name = stdin.readLineSync() ?? '';
  stdout.write('Nhap so dien thoai: ');
  String phone = stdin.readLineSync() ?? '';

  if (!phoneBook.containsKey(name)) {
    phoneBook[name] = phone;
    print('Them Lien He $name Thanh Cong!!!');
  } else {
    print('Lien He Da Co Trong Danh Ba ');
  }
}

//Cập nhật số điện thoại, nếu tên đã tồn tại thì update
void updateContact(Map<String, String> phoneBook) {
  stdout.write('Nhập tên người cần cập nhật: ');
  String name = stdin.readLineSync() ?? '';

  if (phoneBook.containsKey(name)) {
    stdout.write(
      'Liên Hệ $name có số ${phoneBook[name]} bạn muốn thay đổi số mới là: ',
    );
    String phone = stdin.readLineSync() ?? '';
    phoneBook.update(name, (phone) => phone);
    print('Đã cập nhật thành công !!');
  } else {
    print('Liên hệ không tồn tại!!');
  }
}

//xóa các số bắt đầu bằng tùy chỉnh
void removeChoiceContacts(Map<String, String> phonebook) {
  stdout.write('Số cần xóa bắt đầu bằng: ');
  String rmvPhone = stdin.readLineSync() ?? '';

  phonebook.removeWhere((key, phone) => phone.startsWith(rmvPhone));
}

//in danh sach
void showContacts(Map<String, String> phoneBook) {
  if (phoneBook.isEmpty) {
    print('Danh Ba Trong !!');
  } else {
    phoneBook.forEach((name, phone) {
      print('- $name: $phone');
    });
  }
}
