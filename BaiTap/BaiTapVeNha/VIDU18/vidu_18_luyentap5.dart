//Viết chương trình yêu cầu người dùng nhập vào một danh sách số nguyên,
//sau đó kiểm tra xem có số nào bị trùng lặp hay không. Nếu có, in ra các số bị trùng.
import 'dart:io';

void main() {
  print('Nhap vao so nguyen cach nhau boi dau cach');
  String input = stdin.readLineSync()!;

  List<int> numbers = input.split(' ').map(int.parse).toList();

  //set để lưu các số đã thấy
  Set<int> seenNumbers = {};
  //set để lưu các số bị trùng lặp
  Set<int> duplicateNumbers = {};

  //duyệt qua danh sách số
  for (int num in numbers) {
    if (!seenNumbers.add(num)) {
      duplicateNumbers.add(num);
    }
  }

  if (duplicateNumbers.isEmpty) {
    print("Không có số trùng lặp.");
  } else {
    print("Các số bị trùng lặp là: ${duplicateNumbers.toList()}");
  }
}
