//Viết chương trình yêu cầu người dùng nhập vào một danh sách số nguyên, sau đó thực hiện các thao tác sau:
// Loại bỏ tất cả số chẵn khỏi danh sách.
// Tạo một danh sách mới chứa bình phương của các số còn lại.
// Sắp xếp danh sách mới theo thứ tự giảm dần.
// In kết quả ra màn hình.

import 'dart:io';

void main() {
  print('Nhap vao so nguyen cach nhau boi dau cach: ');
  String input = stdin.readLineSync()!;

  List<double> numbers = input.split(' ').map(double.parse).toList();

  List<double> squareNumbers = [];

  //Loại bỏ tất cả số chẵn khỏi danh sách.
  //Tạo một danh sách mới chứa bình phương của các số còn lại.
  for (double num in numbers) {
    if (num % 2 != 0) {
      squareNumbers.add(num * num);
    }
  }

  //Sắp xếp danh sách mới theo thứ tự giảm dần.
  // squareNumbers.sort();
  // squareNumbers = squareNumbers.reversed.toList();

  squareNumbers.sort((a, b) => a.compareTo(a));

  print('Danh sach moi la: $squareNumbers');
}
