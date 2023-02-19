import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/helper/helper_function.dart';
import 'package:flutter_chatapp/pages/auth/login_page.dart';
import 'package:flutter_chatapp/pages/auth/profile_page.dart';
import 'package:flutter_chatapp/pages/search_page.dart';
import 'package:flutter_chatapp/service/auth_service.dart';
import 'package:flutter_chatapp/service/database_service.dart';
import 'package:flutter_chatapp/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      if (value != null) {
        setState(() {
          email = value;
        });
      } else {
        print("Something went wrong! Can't get email from SF.");
      }
    });
    await HelperFunctions.getUserNameFromSF().then((value) {
      if (value != null) {
        setState(() {
          userName = value;
        });
      } else {
        print("Something went wrong! Can't get user name from SF.");
      }
    });

    // getting the lsit of snapshots in the steam
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

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
          "Chats",
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
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 25,
                  color: Color.fromARGB(255, 96, 117, 114)),
            ),
            const SizedBox(height: 30),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
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
              onTap: () {
                nextScreenReplace(
                    context,
                    ProfilePage(
                      email: email,
                      userName: userName,
                    ));
              },
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {}

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null &&
              snapshot.data['groups'].length != 0) {
            return const Text("HELLOOOO");
          }
          return noGroupWidget();
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 4, 173, 153),
          ),
        );
      },
    );
  }

  noGroupWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: const Icon(
                Icons.add_circle,
                color: Color.fromARGB(255, 149, 185, 181),
                size: 75,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "You haven't joined any chats yet, tap on the add icon to create a new chat or tap on the search icon to search for a chat.",
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}
