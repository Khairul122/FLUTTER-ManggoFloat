import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final bool obscureText;
  final String hintText;
  final IconData icon;
  final TextEditingController? controller; // Tambahkan parameter controller

  const CustomTextfield({
    Key? key,
    required this.obscureText,
    required this.hintText,
    required this.icon,
    this.controller, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
      ),
      controller: controller, // Tambahkan controller ke TextField
    );
  }
}
