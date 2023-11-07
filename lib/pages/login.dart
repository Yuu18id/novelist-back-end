import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/screen.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/components/firebase_auth.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  late AuthFirebase auth;
  bool isUserOrPassWrong = false;
  String username = "";

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Log In',
              style: TextStyle(fontSize: 29),
            ),
            Container(
              padding: const EdgeInsets.only(top: 50),
              child: TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  label: Text('Email'),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: TextFormField(
                obscureText: true,
                controller: _pass,
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _pass.text;

                  final userId = await auth.login(email, password);
                  setState(() {
                    auth.getUser().then((value) {
                      username = value!.email.toString();
                    });
                  });

                  if (userId != null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ScreenPage(username: username)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email or Password is Wrong')));
                  }
                },
                child: const Text('Log In'),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  child: const Text('Register')),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              width: double.infinity,
              child: const Align(
                  alignment: Alignment.center, child: Text('Or Login With')),
            ),
            Container(
              padding: const EdgeInsets.only(top: 13),
              width: double.infinity,
              child: IconButton(
                  onPressed: () async {
                    final result = await auth.signInWithGoogle();
                    if (result != null) {
                        prov.isLogInWithGoogle = true;
                      setState(() {
                        auth.getUser().then((value) {
                          username = value!.email.toString();
                        });
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ScreenPage(username: username)));
                    } else {
                        prov.isLogInWithGoogle = true;
                      setState(() {
                        auth.getUser().then((value) {
                          username = value!.email.toString();
                        });
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ScreenPage(username: username)));
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login Success')));
                    }
                  },
                  icon: const Icon(FontAwesomeIcons.google)),
            )
          ],
        ),
      ),
    );
  }
}
