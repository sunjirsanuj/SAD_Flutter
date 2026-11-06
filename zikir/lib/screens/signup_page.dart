import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zikir_tracker/providers/auth_provider.dart';
import 'package:zikir_tracker/screens/login_page.dart';
import 'package:zikir_tracker/theme/app_theme.dart';
import 'package:zikir_tracker/widgets/brand_logo.dart';
import 'package:zikir_tracker/widgets/brand_name.dart';
import 'package:zikir_tracker/widgets/button.dart';
import 'package:zikir_tracker/widgets/custom_icon_text_button.dart';
import 'package:zikir_tracker/widgets/custom_textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _fullNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signup() {
    final auth = context.read<AuthProvider>();
    final error = auth.signup(
      fullName: _fullNameController.text,
      studentId: _studentIdController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Signup successful!")));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BrandLogo(),
            BrandName(fontSize: 25),
            Text(
              "Sign Up",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            CustomTextfield(
              hintText: "Full Name",
              prefixIcon: Icons.person_2_outlined,
              isPassword: false,
              controller: _fullNameController,
            ),
            const SizedBox(height: 8),
            CustomTextfield(
              hintText: "Username",
              prefixIcon: Icons.alternate_email,
              isPassword: false,
              controller: _studentIdController,
            ),
            const SizedBox(height: 8),
            CustomTextfield(
              hintText: "Email",
              prefixIcon: Icons.email_outlined,
              isPassword: false,
              controller: _emailController,
            ),
            const SizedBox(height: 8),
            CustomTextfield(
              hintText: "Password",
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 25),
            GestureDetector(
                onTap: () => _signup(),
                child: Button(buttonContent: "Sign up", borderRadius: 20)),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: Colors.grey[400], thickness: 1),
                  ),
                ),
                Text("or", style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: Colors.grey[400], thickness: 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {},
              child: CustomIconTextButton(
                buttonContent: "Continue with Google",
                borderColor: Color(0xFFE5ECF2),
                backgroundColor: Colors.white,
                buttonIcon: Image.asset("assets/images/google.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
