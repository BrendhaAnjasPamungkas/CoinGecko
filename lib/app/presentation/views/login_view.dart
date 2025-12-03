import 'package:blockchain/app/main_widget.dart';
import 'package:blockchain/app/presentation/controllers/auth_controller.dart';
import 'package:blockchain/app/presentation/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../colors.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final AuthController authController = Get.put(AuthController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background image and form content
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0f172a), // slate-900
                  Color(0xFF1e3a8a), // blue-900
                  Color(0xFF1e293b), // slate-800
                ],
                stops: [0.0, 0.5, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 390, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  W.text(
                    data: "Login",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                  W.gap(height: 40),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: emailController,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: 'Email',

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                    ),
                  ),
                  W.gap(height: 27),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: 'Password',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Get.offAll(() => RegisterView()),
                    child: const Text(
                      'Don\'t have an account? Register here',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Elevated Button positioned at the bottom right
          Positioned(
            bottom: 60,
            right: 25, // Adjusted position
            child: W.button(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                authController.login(email, password);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                child: W.text(data: "Login", color: Colors.white, fontSize: 22),
              ),
              backgroundColor: AppColors.primaryColor,
              borderColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
