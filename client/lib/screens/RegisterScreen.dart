import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:client/widgets/applogo.dart';
import 'loginPageScreen.dart';
import 'package:http/http.dart' as http;
import 'package:client/constants/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<MyRegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool _isNotValidate = false;

  void registerUser() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text,
        "username": usernameController.text,
        "phone": phoneController.text
      };

      var response = await http.post(
        Uri.parse(Config.registrationUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        // Save email to SharedPreferences after registration
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', emailController.text); // Save email

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        print("Something Went Wrong");
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
                  "CREATE YOUR ACCOUNT".text.size(22).yellow100.make(),
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: "Username",
                      hintStyle: const TextStyle(color: Colors.black54),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: "Phone Number",
                      hintStyle: const TextStyle(color: Colors.black54),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: "Email",
                      hintStyle: const TextStyle(color: Colors.black54),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          final data =
                              ClipboardData(text: passwordController.text);
                          Clipboard.setData(data);
                        },
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.password),
                        onPressed: () {
                          String randomPassword = generateRandomPassword();
                          passwordController.text = randomPassword;
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.black54),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  GestureDetector(
                    onTap: () {
                      registerUser();
                    },
                    child:
                        VxBox(child: "Register".text.white.makeCentered().p16())
                            .green600
                            .roundedLg
                            .make()
                            .px16()
                            .py16(),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: HStack([
                      "Already have an account?".text.make(),
                      " Sign In".text.yellow100.make()
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

  String generateRandomPassword() {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(
        8, (index) => characters[random.nextInt(characters.length)]).join();
  }
}
