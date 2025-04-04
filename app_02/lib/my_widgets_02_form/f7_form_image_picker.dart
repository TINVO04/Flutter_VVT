import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class f7_form_image_picker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FormBasicDemoState();
}

class _FormBasicDemoState extends State<f7_form_image_picker> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dateController = TextEditingController();
  String? _name;
  String? _email;
  String? _phone;
  String? _selectedCity;
  String? _gender;
  String? _password;
  String? _confirmPassword;
  final List<String> cities = ['Hà Nội', 'TP.HCM', 'Đà Nẵng', 'Cần Thơ'];
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isSubmitted = false;
  bool _isAgreed = false;
  DateTime? _selectedDate;
  File? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form Basic Demo")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // TextFormField để nhập họ tên
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Nhập Họ và Tên: ",
                    hintText: "Nhập Họ và Tên Mày Vào Đây!!!",
                    border: OutlineInputBorder(),
                    errorText: _isSubmitted && (_name == null || _name!.isEmpty)
                        ? 'Đụ má, không được để trống!'
                        : _isSubmitted && (_name != null && _name!.length < 5)
                        ? 'Đụ mẹ, nhập ít nhất 5 ký tự!'
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Đụ má, không được để trống!';
                    }
                    if (value.length < 5) {
                      return 'Đụ mẹ, nhập ít nhất 5 ký tự!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value;
                  },
                ),
                SizedBox(height: 20),
                // FormField để chọn ảnh đại diện
                FormField<File>(
                  builder: (FormFieldState<File> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ảnh đại diện',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final XFile? image = await showDialog<XFile>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Chọn nguồn'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text('Thư viện'),
                                        onTap: () async {
                                          Navigator.pop(
                                            context,
                                            await _imagePicker.pickImage(source: ImageSource.gallery),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text('Máy ảnh'),
                                        onTap: () async {
                                          Navigator.pop(
                                            context,
                                            await _imagePicker.pickImage(source: ImageSource.camera),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              if (image != null) {
                                setState(() {
                                  _profileImage = File(image.path);
                                  state.didChange(_profileImage);
                                });
                              }
                            },
                            child: _profileImage == null
                                ? Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.grey,
                              ),
                            )
                                : ClipOval(
                              child: Image.file(
                                _profileImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        if (_isSubmitted && state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              state.errorText!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                  validator: (value) {
                    if (_profileImage == null) {
                      return 'Đụ má, chọn ảnh đại diện đi!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // TextFormField để chọn ngày sinh
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: "Ngày sinh",
                    hintText: "Chọn ngày sinh của bạn",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                    errorText: _isSubmitted && (_dateController.text.isEmpty)
                        ? 'Đụ má, chọn ngày sinh đi!'
                        : null,
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Đụ má, chọn ngày sinh đi!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // Lưu giá trị ngày sinh nếu cần
                  },
                ),
                SizedBox(height: 20),
                // TextFormField để nhập email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "example@gmail.com",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    errorText: _isSubmitted && (_emailController.text.isEmpty)
                        ? 'Đụ mẹ, email không được để trống!'
                        : _isSubmitted &&
                        !_emailController.text.contains(
                          RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                          ),
                        )
                        ? 'Đụ má, email không hợp lệ!'
                        : null,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Đụ mẹ, email không được để trống!';
                    }
                    if (!RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                    ).hasMatch(value)) {
                      return 'Đụ má, email không hợp lệ!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value;
                  },
                ),
                SizedBox(height: 20),
                // TextFormField để nhập số điện thoại
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Số điện thoại",
                    hintText: "Nhập số điện thoại của mày",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                    errorText: _isSubmitted && (_phoneController.text.isEmpty)
                        ? 'Đụ mẹ, số điện thoại không được để trống!'
                        : _isSubmitted &&
                        !_phoneController.text.contains(
                          RegExp(r'^[0-9]{10}$'),
                        )
                        ? 'Đụ má, số điện thoại phải là 10 chữ số!'
                        : null,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Đụ mẹ, số điện thoại không được để trống!';
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Đụ má, số điện thoại phải là 10 chữ số!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phone = value;
                  },
                ),
                SizedBox(height: 20),
                // DropdownButtonFormField để chọn thành phố
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Thành phố",
                    hintText: "Chọn thành phố của mày",
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                    errorText: _isSubmitted && _selectedCity == null
                        ? 'Đụ mẹ, chọn thành phố đi!'
                        : null,
                  ),
                  value: _selectedCity,
                  items: cities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCity = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Đụ mẹ, chọn thành phố đi!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _selectedCity = value;
                  },
                ),
                SizedBox(height: 8),
                // FormField để chọn giới tính
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isSubmitted && _gender == null
                          ? Colors.red
                          : Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: FormField<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng chọn giới tính';
                      }
                      return null;
                    },
                    initialValue: _gender,
                    builder: (FormFieldState<String> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              top: 8.0,
                            ),
                            child: Text(
                              "Giới tính",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text('Nam'),
                                  value: 'Nam',
                                  groupValue: _gender,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _gender = value;
                                      state.didChange(value);
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text('Nữ'),
                                  value: 'Nữ',
                                  groupValue: _gender,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _gender = value;
                                      state.didChange(value);
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text('Khác'),
                                  value: 'Khác',
                                  groupValue: _gender,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _gender = value;
                                      state.didChange(value);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (_isSubmitted && state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                bottom: 8.0,
                              ),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                // TextFormField để nhập mật khẩu
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    hintText: "Nhập mật khẩu của mày",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    errorText: _isSubmitted && (_passwordController.text.isEmpty)
                        ? 'Đụ mẹ, mật khẩu không được để trống!'
                        : _isSubmitted && (_passwordController.text.length < 6)
                        ? 'Đụ má, mật khẩu phải ít nhất 6 ký tự!'
                        : null,
                  ),
                  obscureText: !_isPasswordVisible,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Đụ mẹ, mật khẩu không được để trống!';
                    }
                    if (value.length < 6) {
                      return 'Đụ má, mật khẩu phải ít nhất 6 ký tự!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value;
                  },
                ),
                SizedBox(height: 20),
                // TextFormField để nhập lại mật khẩu
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Nhập lại mật khẩu",
                    hintText: "Nhập lại mật khẩu của mày",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    errorText: _isSubmitted &&
                        (_confirmPasswordController.text.isEmpty)
                        ? 'Đụ mẹ, nhập lại mật khẩu đi!'
                        : _isSubmitted &&
                        (_confirmPasswordController.text !=
                            _passwordController.text)
                        ? 'Đụ má, mật khẩu không khớp!'
                        : null,
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Đụ mẹ, nhập lại mật khẩu đi!';
                    }
                    if (value != _passwordController.text) {
                      return 'Đụ má, mật khẩu không khớp!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _confirmPassword = value;
                  },
                ),
                SizedBox(height: 20),
                // CheckboxListTile
                CheckboxListTile(
                  title: Text("Đồng ý với điều khoản của ABC."),
                  value: _isAgreed,
                  onChanged: (value) {
                    setState(() {
                      _isAgreed = value!;
                      print("_isAgreed");
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                SizedBox(height: 20),
                // Row chứa 2 nút Submit và Reset
                Row(
                  children: [
                    // Nút Submit
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isSubmitted = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Xin chào $_name, email: $_email, SDT: $_phone, thành phố: $_selectedCity, giới tính: $_gender, mật khẩu: $_password, ảnh đại diện: ${_profileImage != null ? 'Đã chọn' : 'Chưa chọn'}",
                              ),
                            ),
                          );
                        }
                      },
                      child: Text("Submit"),
                    ),
                    SizedBox(width: 20),
                    // Nút Reset
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                        _emailController.clear();
                        _phoneController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                        _dateController.clear();
                        setState(() {
                          _name = null;
                          _email = null;
                          _phone = null;
                          _selectedCity = null;
                          _gender = null;
                          _password = null;
                          _confirmPassword = null;
                          _isPasswordVisible = false;
                          _isConfirmPasswordVisible = false;
                          _isSubmitted = false;
                          _selectedDate = null;
                          _profileImage = null;
                        });
                      },
                      child: Text("Reset"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}