import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../api/user_api_service.dart';
import '../model/user.dart';

class User_Form extends StatefulWidget {
  const User_Form({super.key});

  @override
  State<StatefulWidget> createState() => _FormBasicDemoState();
}

class _FormBasicDemoState extends State<User_Form> {
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
      appBar: AppBar(title: const Text("Thêm người dùng")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Nhập Họ và Tên: ",
                    hintText: "Nhập Họ và Tên Mày Vào Đây!!!",
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 20),
                FormField<File>(
                  builder: (FormFieldState<File> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ảnh đại diện',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final XFile? image = await showDialog<XFile>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Chọn nguồn'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.photo_library),
                                        title: const Text('Thư viện'),
                                        onTap: () async {
                                          Navigator.pop(
                                            context,
                                            await _imagePicker.pickImage(source: ImageSource.gallery),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('Máy ảnh'),
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
                              child: const Icon(
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
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: "Ngày sinh",
                    hintText: "Chọn ngày sinh của bạn",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
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
                        _dateController.text = pickedDate.toString().split(' ')[0]; // Format: yyyy-MM-dd
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Đụ má, chọn ngày sinh đi!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "example@gmail.com",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Số điện thoại",
                    hintText: "Nhập số điện thoại của mày",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Thành phố",
                    hintText: "Chọn thành phố của mày",
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isSubmitted && _gender == null ? Colors.red : Colors.grey,
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                            child: Text(
                              "Giới tính",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: 'Nam',
                                    groupValue: _gender,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _gender = value;
                                        state.didChange(value);
                                      });
                                    },
                                  ),
                                  const Text('Nam'),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: 'Nữ',
                                    groupValue: _gender,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _gender = value;
                                        state.didChange(value);
                                      });
                                    },
                                  ),
                                  const Text('Nữ'),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<String>(
                                    value: 'Khác',
                                    groupValue: _gender,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _gender = value;
                                        state.didChange(value);
                                      });
                                    },
                                  ),
                                  const Text('Khác'),
                                ],
                              ),
                            ],
                          ),
                          if (_isSubmitted && state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                              child: Text(
                                state.errorText!,
                                style: const TextStyle(
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Mật khẩu",
                    hintText: "Nhập mật khẩu của mày",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.visibility),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: "Nhập lại mật khẩu",
                    hintText: "Nhập lại mật khẩu của mày",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.visibility),
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
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: const Text("Đồng ý với điều khoản của ABC."),
                  value: _isAgreed,
                  onChanged: (value) {
                    setState(() {
                      _isAgreed = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isSubmitted = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          if (!_isAgreed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Đụ má, phải đồng ý với điều khoản trước!")),
                            );
                            return;
                          }
                          _formKey.currentState!.save();
                          final user = User(
                            name: _name ?? '',
                            birthDate: _dateController.text,
                            email: _email ?? '',
                            phone: _phone ?? '',
                            city: _selectedCity ?? '',
                            gender: _gender ?? '',
                            password: _password ?? '',
                            profileImagePath: _profileImage?.path,
                          );
                          try {
                            await UserAPIService.instance.insertUser(user.toMap());
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Đã thêm ${user.name} thành công!")),
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Đụ má, lỗi khi thêm user: $e")),
                            );
                          }
                        }
                      },
                      child: const Text("Submit"),
                    ),
                    const SizedBox(width: 20),
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
                      child: const Text("Reset"),
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