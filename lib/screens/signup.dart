import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/blocs/auth/auth_bloc.dart';
import 'package:todo_app/blocs/auth/auth_event.dart';
import 'package:todo_app/blocs/auth/auth_state.dart';

import 'package:todo_app/core/cores.dart';
import 'package:todo_app/screens/homeScreen.dart';
import 'package:todo_app/widgets/customBotton.dart';
import 'package:todo_app/widgets/customTextFiels.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _decoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w600,
        fontSize: 19,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 19),
        child: Icon(icon, color: Colors.grey.shade500, size: 26),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(21),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(21),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromARGB(255, 93, 47, 173)),
        borderRadius: BorderRadius.circular(21),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 21),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(21),
        color: Colors.white,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: _decoration(hint: hint, icon: icon),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _signUp() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    // يفترض أن الحدث عندك يستقبل هذه القيم.
    context.read<AuthBloc>().add(
      SignUpRequested(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 248, 252),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully!'),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }

          // لو عندك شاشة Home، انتقلي إليها هنا.
          // Navigator.pushReplacement(...);

          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 25),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25),

                      Container(
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 36, 26, 168),
                              Color.fromARGB(255, 85, 58, 183),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.wallet,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 33,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Start tracking your expenses today',
                        style: TextStyle(
                          color: Color.fromARGB(255, 154, 153, 153),
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 24),

                      _fieldLabel('Full Name'),
                      const SizedBox(height: 13),

                      _textField(
                        controller: nameController,
                        hint: 'Ahmed Hossam',
                        icon: Icons.person,
                        validator: _validateName,
                      ),

                      const SizedBox(height: 13),

                      _fieldLabel('Email'),
                      const SizedBox(height: 13),

                      _textField(
                        controller: emailController,
                        hint: 'example@gmail.com',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),

                      const SizedBox(height: 13),

                      _fieldLabel('Password'),
                      const SizedBox(height: 13),

                      ScureTextField(
                        text: 'Password',
                        icon: Icons.visibility_off,
                        controller: passwordController,
                        validator: _validatePassword,
                      ),

                      const SizedBox(height: 13),

                      _fieldLabel('Confirm Password'),
                      const SizedBox(height: 13),

                      ScureTextField(
                        text: 'Confirm Password',
                        icon: Icons.visibility_off,
                        controller: confirmPasswordController,
                        validator: _validateConfirmPassword,
                      ),

                      const SizedBox(height: 26),

                      GesturBotton(
                        text: isLoading ? 'Creating account...' : 'Sign Up',
                        onTap: isLoading ? null : _signUp,
                      ),

                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 93, 47, 173),
                          ),
                        ),

                      const SizedBox(height: 17),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 12),

                          GestureDetector(
                            onTap: () {
                              // ضعي التنقل إلى LoginScreen هنا.
                            },
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
