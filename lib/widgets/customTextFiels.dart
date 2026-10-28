import 'package:flutter/material.dart';

class ScureTextField extends StatefulWidget {
  const ScureTextField({
    super.key,
    required this.text,
    required this.icon,
    this.controller,
    this.validator,
  });

  final String text;
  final IconData icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<ScureTextField> createState() => _ScureTextFieldState();
}

class _ScureTextFieldState extends State<ScureTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(21),
        color: Colors.white,
        child: TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(21),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(21),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 93, 47, 173),
              ),
              borderRadius: BorderRadius.circular(21),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 19),
              child: Icon(Icons.lock_outlined, color: Colors.grey.shade500),
            ),
            hintText: widget.text,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              fontSize: 19,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade500,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 21,
            ),
          ),
        ),
      ),
    );
  }
}
