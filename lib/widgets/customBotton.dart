import 'package:flutter/material.dart';
import 'package:todo_app/core/cores.dart';

class GesturBotton extends StatelessWidget {
  const GesturBotton({super.key, required this.text, required this.onTap});
  final String text;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 68,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: AppTheme.primaryGradient,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
