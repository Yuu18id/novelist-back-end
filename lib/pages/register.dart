import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/firebase_auth.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:localization/localization.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  late AuthFirebase auth;

  bool? isUsernameEmpty;
  bool? isEmailEmpty;
  bool? isPasswordEmpty;
  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('register'.i18n()),
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'register'.i18n(),
                style: TextStyle(fontSize: 29),
              ),
              Container(
                padding: const EdgeInsets.only(top: 40),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    label: Text('email'.i18n()),
                    errorText: isUsernameEmpty == true
                        ? 'email_alert'.i18n()
                        : null,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  obscureText: isObscure,
                  controller: _pass,
                  decoration: InputDecoration(
                    label: Text('password'.i18n()),
                    suffixIcon: IconButton(
                      icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                    errorText: isPasswordEmpty == true
                        ? 'password_alert'.i18n()
                        : null,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                    onPressed: () async {
                      var connectivityResult =
                          await Connectivity().checkConnectivity();

                      if (connectivityResult == ConnectivityResult.none) {
                        // Tidak ada koneksi internet
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('no_internet'.i18n()),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        final email = _email.text;
                        final password = _pass.text;

                        if (email.isEmpty) {
                          setState(() {
                            isEmailEmpty = true;
                          });
                          return;
                        }
                        if (password.isEmpty) {
                          setState(() {
                            isPasswordEmpty = true;
                          });
                        }
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);

                          await auth.addUserData(userCredential.user!.uid,
                              email, email.split('@')[0], "");

                          if (context.mounted) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          }
                        } on FirebaseAuthException catch (e) {
                          displayMessage(e.code);
                        }
                      }
                    },
                    child: Text('register'.i18n())),
              ),
            ],
          ),
        ));
  }
}
