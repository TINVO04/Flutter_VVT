//Viết chương trình yêu cầu người dùng nhập vào một danh sách số nguyên, sau đó thực hiện các thao tác sau:
// Tìm số lớn nhất và nhỏ nhất trong danh sách.
// Loại bỏ tất cả số trùng lặp, chỉ giữ lại các số duy nhất.
// Sắp xếp danh sách theo thứ tự tăng dần.
// In kết quả ra màn hình.

import 'dart:io';
import 'dart:math';

void main() {
  print('nhap vao so nguyen cach nhau dau cach: ');
  String input = stdin.readLineSync()!;

  List<int> numbers = input.split(' ').map(int.parse).toList();

  int minNumbers = numbers.reduce(min);
  int maxNumbers = numbers.reduce(max);

  List<int> uniqueNumbers = numbers.toSet().toList();
  uniqueNumbers.sort();

  print('so lon nhat la: $maxNumbers');
  print('so nho nhat la: $minNumbers');
  print('Danh sach moi la: $uniqueNumbers');
}
