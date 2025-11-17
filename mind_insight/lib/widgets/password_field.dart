import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Color iconColor;
  final Color borderColor;
  final Color textColor;

  const PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    this.iconColor = Colors.black,
    this.borderColor = Colors.black,
    this.textColor = Colors.black,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      cursorColor: widget.textColor,
      style: TextStyle(color: widget.textColor),
      decoration: InputDecoration(
        labelText: widget.hintText,
        labelStyle: TextStyle(color: widget.textColor),
        prefixIcon: Icon(Icons.lock, color: widget.iconColor),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: widget.iconColor,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor, width: 2),
        ),
      ),
    );
  }
}
