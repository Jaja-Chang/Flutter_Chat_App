import 'package:flutter/material.dart';
import 'package:flutter_chatapp/pages/home_page.dart';
import 'package:flutter_chatapp/service/auth_service.dart';

import '../../widgets/widgets.dart';
import '../search_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  String userName = "";
  String email = "";
  ProfilePage({Key? key, required this.email, required this.userName})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w300,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Color.fromARGB(255, 149, 185, 181),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 25,
                  color: Color.fromARGB(255, 96, 117, 114)),
            ),
            const SizedBox(height: 30),
            ListTile(
              onTap: () {
                nextScreen(context, const HomePage());
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 5),
              leading: const Icon(Icons.chat),
              title: const Text(
                "Chats",
                style: TextStyle(
                    color: Color.fromARGB(145, 0, 0, 0),
                    fontWeight: FontWeight.w300,
                    fontSize: 18),
              ),
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 5),
              leading: const Icon(Icons.account_box),
              title: const Text(
                "Profile",
                style: TextStyle(
                    color: Color.fromARGB(145, 0, 0, 0),
                    fontWeight: FontWeight.w300,
                    fontSize: 18),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("LOGOUT"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.cancel,
                                color: Color.fromARGB(255, 255, 0, 0)),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            icon: const Icon(Icons.exit_to_app,
                                color: Color.fromARGB(255, 0, 230, 150)),
                          )
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Logout",
                style: TextStyle(
                    color: Color.fromARGB(145, 0, 0, 0),
                    fontWeight: FontWeight.w300,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_circle,
              size: 200,
              color: Color.fromARGB(255, 149, 185, 181),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Username",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const Divider(
              height: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.email,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
