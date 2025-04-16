//Viết chương trình yêu cầu người dùng nhập vào một danh sách số nguyên, sau đó thực hiện các thao tác sau:
// Loại bỏ tất cả số lẻ khỏi danh sách.
// Nhân đôi tất cả số còn lại.
// Tính tổng tất cả các số trong danh sách mới.
// In danh sách mới và tổng ra màn hình.

import 'dart:io';

void main() {
  print('Nhap so nguyen cach nhau boi dau cach: ');
  String input = stdin.readLineSync()!;

  List<int> numbers = input.split(' ').map(int.parse).toList();

  // for (int num in numbers) {
  //   if (num % 2 == 0) {
  //     soChan.add(num * 2);
  //   }
  // }
  List<int> soChan =
      numbers.where((num) => num.isEven).map((num) => num * 2).toList();

  int sum = soChan.reduce((a, b) => a + b);

  print('Danh sach moi la: $soChan');
  print('Tong danh sach moi la: $sum');
}
