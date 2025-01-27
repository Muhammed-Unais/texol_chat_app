import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomField({
    super.key,
    required this.hintText,
    this.controller,
    this.isObscureText = false,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: validator,
      obscureText: isObscureText,
    );
  }
}
