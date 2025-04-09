
import 'package:flutter/material.dart';

class CardBody extends StatelessWidget{
  const CardBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xffDFDFDF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tập Thể Dục Buổi Sáng',
              style: TextStyle(
                color: Color(0xff4B4B4B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.delete_outline, color: Color(0xff4B4B4B),
                size: 30),
          ],
        ),
      ),
    );
  }
}