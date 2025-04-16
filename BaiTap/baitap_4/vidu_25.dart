void main() {
  var r = ('first', a: 2, 5, 10.5); // record

  // Định nghĩa record có 2 giá trị
  var point = (123, 456); // x, y

  // Định nghĩa person
  var person = (name: 'Alice', age: 25, 5);

  // Truy cập giá trị trong record
  // Dùng chỉ số
  print(point.$1); // 123
  print(point.$2); // 456
  print(person.$1); // 5

  // Dùng tên
  print(person.name);
  print(person.age);
}
