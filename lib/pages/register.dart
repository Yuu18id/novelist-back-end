import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/models/db_helper.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  DateTime date = DateTime.now();
  bool isDateSet = false;
  final dbHelper = DBHelper.instance;

  bool? isUsernameEmpty;
  bool? isEmailEmpty;
  bool? isPasswordEmpty;

  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
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
            const Text('Register', style: TextStyle(
            fontSize: 29
        ),),
            Container(
                padding: const EdgeInsets.only(top: 40),
              child: TextFormField(
                  controller: _usernameController,
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
                controller: _passwordController,
                decoration: InputDecoration(
                  label: const Text('Password'),
                  suffixIcon: IconButton(
                    icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off), 
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
                padding: const EdgeInsets.only(top: 15),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                horizontalTitleGap: 0,
                title: const Text('Tanggal Lahir', style: TextStyle(fontSize: 15),),
                trailing: IconButton(onPressed: () async {
                    var res = await showDatePicker(
                        initialDatePickerMode: DatePickerMode.year,
                        context: context,
                    initialDate: prov.date, firstDate: DateTime(1970, 01, 01), lastDate: DateTime.now());
      
                    if (res != null) {
                        print(res.toString());
                        setState(() {
                          prov.date = res;
                          prov.isDateSet = true;
                        });
                    }
                }, icon: const Icon(Icons.calendar_month)),
              ),
            ),
            prov.isDateSet != false? Container(
                child: Text(prov.date.toString().split(' ')[0], textAlign: TextAlign.left,)) : Container(child: const Text('Silahkan isi tanggal lahir', style: TextStyle(fontSize: 13), textAlign: TextAlign.left,),),
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
            ),
          ],
        ),
      ));
  }
}