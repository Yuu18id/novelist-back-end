import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  'KELOMPOK 7',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Text('211112007 - Bayu Arma Praja'),
              Text('211111151 - Herri Suba L. Tobing'),
              Text('211111943 - Martin Simanjuntak'),
              Text('211112727 - Tongam S.P Lubis')
            ],
          ),
        ),
      ),
    );
  }
}
