import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import "package:client/widgets/applogo.dart";
import 'package:http/http.dart' as http;
import 'package:client/constants/config.dart';
import 'package:client/screens/RegisterScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(
        Uri.parse(Config.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        // On successful login, save login status and email
        prefs.setBool('isLoggedIn', true);
        prefs.setString(
            'email', emailController.text); // Save email to SharedPreferences

        // Navigate to home screen
        Navigator.pushReplacementNamed(context, 'home/');
      } else {
        // Handle login error
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(153, 137, 133, 189),
                Color.fromARGB(199, 40, 191, 255),
              ],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomCenter,
              stops: [0.0, 0.8],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CommonLogo(),
                  const HeightBox(10),
                  "EMAIL SIGN-IN".text.size(22).yellow100.make(),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: "Email",
                      hintStyle: const TextStyle(color: Colors.black54),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ).p4().px24(),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.black54),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ).p4().px24(),
                  GestureDetector(
                    onTap: () {
                      loginUser();
                    },
                    child:
                        VxBox(child: "Log In".text.white.makeCentered().p16())
                            .green600
                            .roundedLg
                            .make()
                            .px16()
                            .py16(),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyRegisterPage()));
                    },
                    child: HStack([
                      "Don't have an account?".text.make(),
                      " Sign Up".text.yellow100.make()
                    ]).centered(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
