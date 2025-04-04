import 'package:flutter/material.dart';

enum Priority {
  low(name: '低', color: Color(0xFF64B5F6)),
  middle(name: '中', color: Color(0xFFFFF176)),
  high(name: '高', color: Color(0xFFE57373));

  const Priority({
    required this.name,
    required this.color,
  });

  final String name;
  final Color color;
}
