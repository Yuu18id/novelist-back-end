import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/screen.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
        ChangeNotifierProvider(create: (_) => ScreenPageProvider()),
    ]
    ,child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ScreenPageProvider>(context);
    return MaterialApp(
      title: 'Novelist',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ScreenPage(username: '', email: '',),
      debugShowCheckedModeBanner: false,
    );
  }
}
