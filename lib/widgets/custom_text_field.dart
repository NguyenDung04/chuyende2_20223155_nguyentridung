import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  OutlineInputBorder _border({
    Color color = const Color(0xFFE4E7EC),
    double width = 1.2,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.isPassword;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: isPassword ? _obscure : false,
      validator: widget.validator,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1F1F39),
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: const Color(0xFFF8F9FD),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF667085),
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF98A2B3),
          fontSize: 14,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 10, right: 8),
          child: Icon(
            widget.prefixIcon,
            color: const Color(0xFF7A5AF8),
            size: 22,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        suffixIcon: isPassword
            ? IconButton(
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFF667085),
          ),
        )
            : null,
        enabledBorder: _border(),
        focusedBorder: _border(
          color: const Color(0xFF7A5AF8),
          width: 1.6,
        ),
        errorBorder: _border(
          color: const Color(0xFFF04438),
          width: 1.4,
        ),
        focusedErrorBorder: _border(
          color: const Color(0xFFF04438),
          width: 1.6,
        ),
      ),
    );
  }
}