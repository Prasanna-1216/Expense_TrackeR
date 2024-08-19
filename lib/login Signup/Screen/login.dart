import 'package:expense_tracker/login%20Signup/Screen/sign_up.dart';
import 'package:expense_tracker/login%20Signup/Widget/button.dart';
import 'package:expense_tracker/login%20Signup/Widget/text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
// for controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                    height: height / 2.7,
                    child: Image.asset("images/login.jpg"),
                  ),
                  TextFieldInpute(
                      textEditingController: emailController,
                      hintText: "Enter your email",
                      icon: Icons.email),
                  TextFieldInpute(
                      textEditingController: passwordController,
                      hintText: "Enter your password",
                      icon: Icons.lock),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  MyButton(onTab: () {}, text: "Log In"),
                  SizedBox(height: height / 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                          );
                    },
                    child: const Text(
                      "SignUp",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
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
