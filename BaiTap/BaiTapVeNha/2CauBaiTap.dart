/*
Câu 1: Viết một đoạn mã Dart để khai báo các kiểu dữ liệu khác nhau như số nguyên, 
số thực, chuỗi ký tự và Boolean. Sau đó, in giá trị của các biến này ra console để xem kết quả.

Câu 2: Viết một hàm trong Dart tên là calculateSum nhận vào hai tham số số nguyên 
và trả về tổng của chúng. Gọi hàm này trong chương trình chính và in kết quả ra màn hình.
*/
import 'dart:io';

void main() {
  //Cau 1:
  print("Nhap vao so nguyen: ");
  int soNguyen = int.parse(stdin.readLineSync()!);

  print("Nhap vao so thuc: ");
  double soThuc = double.parse(stdin.readLineSync()!);

  print("Nhap vao 1 chuoi: ");
  String? chuoi = stdin.readLineSync();

  print("Nhap vao 1 gia tri Bool TRUE or FALSE ");
  bool giaTriBool = stdin.readLineSync()!.toLowerCase() == "true";
  print('/n DU LIEU BAN DA NHAP LA: ');
  print("SO NGUYEN: $soNguyen");
  print("SO THUC: $soThuc");
  print("CHUOI KI TU: $chuoi");
  print("GIA TRI BOOL: $giaTriBool");
}
