//Viết chương trình yêu cầu người dùng nhập vào một danh sách số nguyên,
//sau đó loại bỏ các số trùng lặp và in ra danh sách kết quả.
import 'dart:io';

void main() {
  print('Nhap vao so nguyen cach nhau boi dau cach: ');
  String input = stdin.readLineSync()!;

  Set<int> numbers = input.split(' ').map(int.parse).toSet();
  List<int> uniqueNumbers = numbers.toList();

  print('Danh sach sau khi loai bo so trung lap la: $uniqueNumbers');
}
