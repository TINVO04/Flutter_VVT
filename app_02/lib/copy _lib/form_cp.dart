import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class form_cp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _form_cpState();
}

class _form_cpState extends State<form_cp>{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _name;
  String? _email;
  String? _phone;
  String? _selectedCity;
  String? _gender;
  String? _password;
  String? _confirmPassword;
  final List<String> cities = ['Hà Nội', 'TP.HCM', 'Đà Nẵng', 'Cần Thơ'];
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Basic Demo"),
      ),

      body: Container(
      ),
      );
  }
}