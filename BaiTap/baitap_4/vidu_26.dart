typedef IntList = List<int>;
typedef ListMapper<X> = Map<X, List<X>>;
typedef ComplexMap = Map<String, Map<int, List<double>>>;
void main() {
  IntList l1 = [1, 2, 3, 4, 5];
  print(l1);

  IntList l2 = [1, 2, 3, 4, 5, 6, 7];

  Map<String, List<String>> m1 = {}; // Khá dài
  ListMapper<String> m2 = {}; // m1 và m2 là cùng 1 kiểu

  ComplexMap betterComplexMap = {
    "categoryA": {
      10: [10.1, 10.2, 10.3],
      20: [20.4, 20.5],
    },
    "categoryB": {
      30: [30.6, 30.7],
    },
  };

  print(betterComplexMap);
}
