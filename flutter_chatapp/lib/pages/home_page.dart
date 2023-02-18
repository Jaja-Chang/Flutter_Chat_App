import 'package:flutter/material.dart';
import 'package:flutter_chatapp/pages/auth/login_page.dart';
import 'package:flutter_chatapp/service/auth_service.dart';
import 'package:flutter_chatapp/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              child: Text("LOGOUT"),
              onPressed: () {
                authService.signOut();
              })),
    );
  }
}
