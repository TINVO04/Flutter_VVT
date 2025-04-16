void main() {
  var a = 1;
  print(a);

  dynamic b;
  print(b);

  // ??= : se gan gia tri neu bien dang null

  int c = 3;
  b ??= c;
  print(b);

  // int? b;
  // b ??= 5;
  // print('b = $b');

  // b ??= 10;
  // print('b = $b');
}
