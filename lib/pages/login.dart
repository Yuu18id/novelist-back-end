import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/auth_provider.dart';
import 'package:flutter_application_1/pages/screen.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/db_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final dbHelper = DBHelper.instance;

  @override
  Widget build(BuildContext context) {
    final provAuth = Provider.of<AuthProvider>(context);

    return Scaffold(
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
                controller: _usernameController,
                decoration: const InputDecoration(
                  label: Text('Username'),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(label: Text('Password')),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 40),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final username = _usernameController.text;
                    final password = _passwordController.text;

                    if (username.isNotEmpty && password.isNotEmpty) {
                      try {
                        final existingUser = await dbHelper
                            .getUserByUsernameAndPass(username, password);

                        if (existingUser != null) {
                          if (existingUser.pass == password) {
                            await provAuth.login(username, password);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Login Berhasil'),
                              duration: Duration(seconds: 2),
                            ));

                            // Mengambil ID pengguna setelah login berhasil
                            final userId = existingUser.id;

                            // Mengambil data pengguna berdasarkan ID
                            final userById =
                                await dbHelper.getUserById(userId!);

                            if (userById != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScreenPage(
                                    username: userById.username,
                                  ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password salah')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Username tidak ditemukan')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login gagal: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Username dan password harus diisi'),
                        ),
                      );
                    }
                  },
                  child: const Text('Log In'),
                )),
            Container(
              padding: const EdgeInsets.only(top: 10),
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Daftar()));
                },
                child: const Text('Register'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
