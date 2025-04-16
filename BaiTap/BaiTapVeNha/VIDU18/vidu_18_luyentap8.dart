//Viết chương trình yêu cầu người dùng nhập vào một danh sách số nguyên,
//sau đó tìm và in ra số nhỏ thứ hai trong danh sách.

import 'dart:io';

void main() {
  print('Nhap vao so nguyen cach nhau boi dau cach: ');
  String input = stdin.readLineSync()!;

  List<int> numbers = input.split(' ').map(int.parse).toList();

  numbers.sort();

  print('Số nhỏ thứ 2 là: ${numbers[1]}');
}
