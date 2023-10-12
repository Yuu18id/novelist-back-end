import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class AboutPage extends StatelessWidget {
  // const AboutPage({super.key});

  List members = [
    {
      'name' : 'Bayu Arma Praja',
      'ID' : '211112007',
      'type' : 'Full-Stack Developer'
    },
    {
      'name' : 'Alvin Nonitehe Syas Putra Laia',
      'ID' : '211110558',
      'type' : 'Back-End Developer'
    },
    {
      'name' : 'Muhammad Reza Mahendra L.',
      'ID' : '211110870',
      'type' : 'Front-End Developer'
    },
    {
      'name' : 'Ryeinaldo',
      'ID' : '211111677',
      'type' : 'Back-End Developer'
    },
    {
      'name' : 'Victoria Beatrice',
      'ID' : '211110515',
      'type' : 'Back-End Developer'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About Our Team'),
        ),
        body: GridView.count(
          padding: EdgeInsets.all(10.0),
          childAspectRatio: 5.0 / 0.8,
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 1,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(members.length, (index) {
            return 
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.25,
                child: ListTile(
                  leading: members[index]['type'] == 'Front-End Developer' ? Icon(Icons.design_services) : members[index]['type'] == 'Back-End Developer' ? Icon(Icons.code) : Icon(Icons.contrast),
                  title: Text(members[index]['name'] + ' (${members[index]['ID']})', overflow: TextOverflow.ellipsis),
                  subtitle: Text(members[index]['type']),
                  contentPadding: EdgeInsets.all(5.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                )
              );
          })
        ),
      );
  }
}
