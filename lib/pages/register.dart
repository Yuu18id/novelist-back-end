import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/db_helper.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/pages/login.dart';

class Daftar extends StatefulWidget {
  const Daftar({super.key});

  @override
  State<Daftar> createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  DateTime date = DateTime.now();
  bool isDataSet = false;
  final dbHelper = DBHelper.instance;

  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                controller: _usernameController,
                decoration: const InputDecoration(
                  label: Text('Username'),
                  // errorText: is
                ),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.only(top: 15),
            //   child: TextFormField(
            //     controller: _usernameController,
            //     decoration: const InputDecoration(
            //       label: Text('Email'),
            //     ),
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                horizontalTitleGap: 0,
                title: const Text(
                  'tanggal Lahir',
                  style: TextStyle(fontSize: 15),
                ),
                trailing: IconButton(
                  onPressed: () async {
                    var res = await showDatePicker(
                        initialDate: date,
                        context: context,
                        initialDatePickerMode: DatePickerMode.year,
                        firstDate: DateTime(1970, 01, 01),
                        lastDate: DateTime.now());

                    if (res != null) {
                      setState(() {
                        date = res;
                        isDataSet = true;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_month),
                ),
              ),
            ),
            isDataSet != false
                ? Text(
                    date.toString().split(' ')[0],
                    textAlign: TextAlign.left,
                  )
                : const Text(
                    'Silahkan isi tanggal lahir',
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.left,
                  ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40),
              child: ElevatedButton(
                  onPressed: () async {
                    final username = _usernameController.text;
                    final password = _passwordController.text;

                    if (username.isNotEmpty) {
                      try {
                        final existingUser =
                            await dbHelper.getUserByUsername(username);

                        if (existingUser != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Pengguna dengan username ini sudah terdaftar'),
                          ));
                        } else {
                          final newUser =
                              User(username: username, pass: password);
                          await dbHelper.addUser(newUser);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Registasi berhasil. Silahkan login'),
                          ));

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Terjadi kesalahan saat melakukan registrasi: $e')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Username dan password harus diisi!'),
                      ));
                    }
                  },
                  child: const Text('Register')),
            )
          ],
        ),
      ),
    );
  }
}
