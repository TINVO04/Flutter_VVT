void main() {
  // ĐỊNH NGHĨA:
  // - List là tập hợp các phần tử có thứ tự và có thể trùng lặp
  // - Các phần tử được truy cập bằng chỉ số (index) từ 0
  // - Kích thước có thể thay đổi được

  List<String> list1 = ['A', 'B', 'C'];
  var list2 = [1, 2, 3];
  ;
  List<String> list3 = [];
  var list4 = List<int>.filled(3, 0);
  print(list4);

  //Them 1 phan tu
  list1.add('D');
  list1.addAll(['A', 'C']);
  list1.insert(0, 'Z');
  list1.insertAll(1, ['1', '0']);
  print(list1);

  //xoa phan tu ben trong list
  list1.removeWhere((e) => e == 'B');
  print(list1);
}
