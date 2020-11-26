import 'package:apostolic_songs/pages/spalsh_screen.dart';
import 'package:flutter/material.dart';

import 'finder.dart';

void main() {
  setupFinder();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'የጽዮን መዝሙሮች',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey,
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeSplashScreen(),
    );
  }
}