//Viết chương trình yêu cầu người dùng nhập vào một danh sách số nguyên.
//Sau đó, tìm và in ra số nhỏ nhất và lớn nhất trong danh sách.
import 'dart:io';
import 'dart:math';

void main() {
  print('Nhap vao so nguyen cach nhau boi dau cach: ');
  String input = stdin.readLineSync()!;

  List<int> numbers = input.split(' ').map(int.parse).toList();

  int minValue = numbers.reduce(min);
  int maxValue = numbers.reduce(max);

  print('Số lớn nhất là: $maxValue \n' + 'Số nhỏ nhất là: $minValue');
}
