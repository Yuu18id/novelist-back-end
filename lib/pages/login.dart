import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/screen.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/components/firebase_auth.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:localization/localization.dart';
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
  String userId = "";

  Future<void> _checkInternetAndLogin() async {
    var connectivityResult = await Connectivity().checkConnectivity();

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
      // Ada koneksi internet, lakukan login
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
                builder: (context) => ScreenPage(username: username)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('wrong_pass'.i18n())));
      }
    }
  }

  Future<void> _signInWithGoogleAndCheckInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    final prov = Provider.of<ScreenPageProvider>(context, listen: false);

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
      // Ada koneksi internet, lakukan login dengan Google

      final result = await auth.signInWithGoogle();
      if (result != null) {
        prov.isLogInWithGoogle = true;
        setState(() {
          auth.getUser().then((value)  async{
            username = value!.email.toString();
            userId = value.uid.toString();
            await auth.addUserData(userId, username, username.split('@')[0], "");
          });
        });

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenPage(username: username)));
        
      } else {
        prov.isLogInWithGoogle = true;
        setState(() {
          auth.getUser().then((value) async {
            username = value!.email.toString();
            userId = value.uid.toString();
            await auth.addUserData(userId, username, username.split('@')[0], "");
          });
        });

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenPage(username: username)));
        
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('login_success'.i18n())));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    auth = AuthFirebase();
    auth.getUser().then((value) {
      MaterialPageRoute route;
      if (value != null) {
        route = MaterialPageRoute(
            builder: (context) => ScreenPage(username: username));
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    auth.getUser().then((value) {
      username = value!.email!;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('login'.i18n()),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'login'.i18n(),
              style: const TextStyle(fontSize: 29),
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
                decoration: InputDecoration(
                  label: Text('password'.i18n()),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _checkInternetAndLogin();
                },
                child: Text('login'.i18n()),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  child: Text('register'.i18n())),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              width: double.infinity,
              child: Align(
                  alignment: Alignment.center,
                  child: Text('login_alter'.i18n())),
            ),
            Container(
              padding: const EdgeInsets.only(top: 13),
              width: double.infinity,
              child: IconButton(
                  onPressed: () async {
                    await _signInWithGoogleAndCheckInternet();
                  },
                  icon: const Icon(FontAwesomeIcons.google)),
            )
          ],
        ),
      ),
    );
  }
}
