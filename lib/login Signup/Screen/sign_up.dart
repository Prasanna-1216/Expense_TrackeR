import 'package:expense_tracker/login%20Signup/Screen/home_screen.dart';
import 'package:expense_tracker/login%20Signup/Screen/login.dart';
import 'package:expense_tracker/login%20Signup/Services/authentication.dart';
import 'package:expense_tracker/login%20Signup/Widget/snack_bar.dart';
import 'package:flutter/material.dart';

import '../Widget/button.dart';
import '../Widget/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // for controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthService().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the next screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // show error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: height / 2.8,
                    child: Image.asset("images/signup.jpeg"),
                  ),
                  TextFieldInpute(
                      textEditingController: nameController,
                      hintText: "Enter your name",
                      icon: Icons.person),
                  TextFieldInpute(
                      textEditingController: emailController,
                      hintText: "Enter your email",
                      icon: Icons.email),
                  TextFieldInpute(
                      textEditingController: passwordController,
                      hintText: "Enter your password",
                      isPass: true,
                      icon: Icons.lock),
                  MyButton(onTab: signUpUser, text: "Sign Up"),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account ?",
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
