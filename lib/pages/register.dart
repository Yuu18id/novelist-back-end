import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/firebase_auth.dart';
import 'package:flutter_application_1/pages/login.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Register',
                style: TextStyle(fontSize: 29),
              ),
              Container(
                padding: const EdgeInsets.only(top: 40),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    label: const Text('Username'),
                    errorText:
                        isUsernameEmpty == true ? 'Username harus diisi' : null,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 15),
                child: TextFormField(
                  obscureText: isObscure,
                  controller: _pass,
                  decoration: InputDecoration(
                    label: const Text('Password'),
                    suffixIcon: IconButton(
                      icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                    errorText:
                        isPasswordEmpty == true ? 'Password harus diisi' : null,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                    onPressed: () async {
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
                      final userId = await auth.signUp(email, password);

                      if (userId != null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Register gagal')));
                      }
                    },
                    child: const Text('Register')),
              ),
            ],
          ),
        ));
  }
}
