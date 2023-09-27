import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/screen.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isUserOrPassWrong = false;
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Log In',
              style: TextStyle(fontSize: 29),
            ),
            Container(
              padding: EdgeInsets.only(top: 50),
              child: TextFormField(
                controller: username,
                decoration: InputDecoration(
                  label: Text('Username'),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: TextFormField(
                obscureText: true,
                controller: password,
                decoration: InputDecoration(
                  label: Text('Password'),
                ),
              ),
            ),
            if (isUserOrPassWrong != false)
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Email atau password salah',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Container(
              padding: EdgeInsets.only(top: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  bool isLoginSuccessful = false;
                  String email = '';

                  for (Map userData in prov.user['data']) {
                    if (userData['username'] == username.text &&
                        userData['password'] == password.text) {
                      isLoginSuccessful = true;
                      setState(() {
                        email = userData['email'];
                        prov.setUsername = username.text;
                      });
                      break;
                    }
                  }

                  if (isLoginSuccessful) {
                    setState(() {
                      isUserOrPassWrong = false;
                    });

                    prov.login = true;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ScreenPage(
                        username: username.text,
                        email: email,
                      );
                    }));
                  } else {
                    setState(() {
                      isUserOrPassWrong = true;
                    });
                  }
                },
                child: Text('Log In'),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  child: Text('Register')),
            ),
          ],
        ),
      ),
    );
  }
}
