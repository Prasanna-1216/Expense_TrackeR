import 'package:expense_tracker/login%20Signup/Screen/home_screen.dart';
import 'package:expense_tracker/login%20Signup/Screen/sign_up.dart';
import 'package:expense_tracker/login%20Signup/Services/authentication.dart';
import 'package:expense_tracker/login%20Signup/Widget/button.dart';
import 'package:expense_tracker/login%20Signup/Widget/snack_bar.dart';
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
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  // email and passowrd auth part
  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthService().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the home screen
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
                    height: height / 2.7,
                    child: Image.asset("images/login.jpg"),
                  ),
                  TextFieldInpute(
                      textEditingController: emailController,
                      hintText: "Enter your email",
                      icon: Icons.email),
                  TextFieldInpute(
                    isPass: true,
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
                  MyButton(
                    onTab: loginUser,
                    text: "Log In"
                    ),
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
