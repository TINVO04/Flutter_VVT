//Viết chương trình yêu cầu người dùng nhập vào một danh sách số nguyên,
//sau đó sắp xếp danh sách theo thứ tự giảm dần và in ra kết quả.
import 'dart:io';

void main() {
  print('Nhap so nguyen cach nhau boi dau cach: ');
  String input = stdin.readLineSync()!;

  List<int> numbers = input.split(' ').map(int.parse).toList();
  numbers.sort();
  numbers = numbers.reversed.toList();
  print("Danh sach giam dan la: $numbers ");
}
