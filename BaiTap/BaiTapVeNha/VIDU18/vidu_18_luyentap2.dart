//Viết chương trình yêu cầu người dùng nhập vào một danh sách số nguyên, sau đó tìm và in ra số lớn nhất trong danh sách.
import 'dart:io';

void main() {
  stdout.write('Nhap vao danh sach so cach nhau boi dau cach: ');
  String input = stdin.readLineSync()!;

  List<int> numbers = input.split(' ').map(int.parse).toList();

  print('Danh sach chua sort: $numbers');
  numbers.sort();

  print('danh sach sort: $numbers');
  print('So lon nhat trong danh sach la: ${numbers.last}');
}
