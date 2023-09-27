import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
    TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool? isUsernameEmpty;
  bool? isEmailEmpty;
  bool? isPasswordEmpty;
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Register', style: TextStyle(
            fontSize: 29
        ),),
            Container(
                padding: EdgeInsets.only(top: 40),
              child: TextFormField(
                  controller: username,
                decoration: InputDecoration(
                  label: Text('Username'),
                  errorText:
                      isUsernameEmpty == true ? 'Username harus diisi' : null,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 15),
              child: TextFormField(
                  controller: email,
                decoration: InputDecoration(
                  label: Text('Email'),
                  errorText:
                      isEmailEmpty == true ? 'Email harus diisi' : null,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 15),
              child: TextFormField(
                  obscureText: true,
                  controller: password,
                decoration: InputDecoration(
                  label: Text('Password'),
                  errorText:
                      isPasswordEmpty == true ? 'Password harus diisi' : null,
                ),
              ),
            ),
             Container(
                padding: EdgeInsets.only(top: 15),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                horizontalTitleGap: 0,
                title: Text('Tanggal Lahir', style: TextStyle(fontSize: 15),),
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
                }, icon: Icon(Icons.calendar_month)),
              ),
            ),
            prov.isDateSet != false? Container(
                child: Text(prov.date.toString().split(' ')[0], textAlign: TextAlign.left,)) : Container(child: Text('Silahkan isi tanggal lahir', style: TextStyle(fontSize: 13), textAlign: TextAlign.left,),),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 40),
                  child: ElevatedButton(onPressed: () {
                      
                      if (username.text.isEmpty) {
                          setState(() {
                            isUsernameEmpty = true;
                          });
                      }
                      if (email.text.isEmpty) {
                          setState(() {
                            isEmailEmpty = true;
                          });
                      }
                      if (password.text.isEmpty) {
                          setState(() {
                            isPasswordEmpty = true;
                          });
                      }
                      if (prov.isDateSet == false) {
                        setState(() {
                          prov.isDateSet == false;
                        });
                      }
                      else {
                          setState(() {
                          isUsernameEmpty = false;
                          isEmailEmpty = false;
                          isPasswordEmpty = false;
                          prov.isDateSet = true;
                          prov.user['data'].add({'email' : email.text, 'username' : username.text, 'password' : password.text, 'favorites' : [], 'birthday' : prov.date.toString().split(' ')[0]});
                          });
                          
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginPage(
                          );
                        }));
                      }
                  }, child: Text('Register')),
                ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
              children: [
                
              ],
            )
          ],
        ),
      ));
  }
}