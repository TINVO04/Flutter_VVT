import 'dart:io';

//Viết chương trình yêu cầu người dùng nhập vào một danh sách
// các số nguyên và tính tổng của chúng.
void main() {
  //nhap danh sach so nguyen tu nguoi dung
  print("Nhập các số cách nhau bởi dấu cách: ");
  String input = stdin.readLineSync()!;
  //input 1 4 3 7
  //split(' ') "1,4,3,7" string => map(int.parse) 1,4,3,7 => tolist() [1,4,3,7]
  //Chuyen chuoi nhap thanh list<int>
  List<int> numbers = input.split(' ').map(int.parse).toList();

  //Tinh Tong cac phan tu trong list
  //[1, 3, 6, 2]
  //reduce((a,b)
  //return a + b;
  //)
  int sum = numbers.reduce((a, b) => a + b);

  print("Tổng các số trong list là: $sum");
}
