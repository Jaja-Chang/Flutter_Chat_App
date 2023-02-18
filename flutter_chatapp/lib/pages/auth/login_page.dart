import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/pages/auth/register_page.dart';
import 'package:flutter_chatapp/service/auth_service.dart';
import 'package:flutter_chatapp/widgets/widgets.dart';

import '../home_page.dart';

class LoginPage extends StatefulWidget {
  // const LoginPage({Key? key}) : super(key: key);
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Friends",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                          "Login now to see what they are talking about!",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400)),
                      Image.asset("assets/login.png"),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                            print(email);
                          });
                        },

                        // check the validation (not sure if there's a shorter version)
                        validator: (val) {
                          if (val != null) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]")
                                    .hasMatch(val)
                                ? null
                                : "Please enter a valid email!";
                          }
                          return "Please enter an email!";
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                            labelText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            )),

                        // add more constrains for passwords
                        validator: (val) {
                          if (val != null) {
                            if (val.length < 8) {
                              return "Password must be at least 8 characters";
                            }
                            return null;
                          }
                          return "Please enter a password!";
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                            print(password);
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              primary: Theme.of(context).primaryColor),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16),
                          ),
                          onPressed: () {
                            login();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Register here!",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const RegisterPage());
                                })
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ToDo: login function
  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserEmailandPassword(email, password)
          .then((value) async {
        if (value == true) {
          nextScreenReplace(context, HomePage());
        } else {
          showSnackbar(context, Color.fromARGB(255, 255, 0, 0), value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
    // ignore: avoid_print
    print("There is something wrong with the formkey.");
  }
}
