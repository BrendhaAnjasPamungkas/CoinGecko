import 'package:blockchain/app/main_widget.dart';
import 'package:blockchain/app/presentation/colors.dart';
import 'package:blockchain/app/presentation/controllers/auth_controller.dart';
import 'package:blockchain/app/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  final AuthController authController = Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController =
      TextEditingController(); // Add this for name

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 370, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  W.text(
                    data: "Register",
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                  W.gap(height: 26),

                  // Input untuk Name
                  TextField(
                    controller: nameController, // Controller untuk name
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: 'Name',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                  W.gap(height: 27),

                  // Input untuk Email
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: 'Email',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                  W.gap(height: 27),

                  // Input untuk Password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: 'Password',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                  W.gap(height: 10),

                  // Navigasi ke halaman login
                  TextButton(
                    onPressed: () => Get.offAll(() => LoginView()),
                    child: Text(
                      'Already have an account? Login here',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            right: 10, // Adjusted position
            child: W.button(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                final name =
                    nameController.text; // Get name from the text field

                // Panggil fungsi register di AuthController dan masukkan name
                authController.register(email, password, name);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                child: W.text(
                  data: "Register",
                  color: Colors.white,
                  fontSize: 22,
                ),
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
