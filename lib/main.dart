import 'package:apostolic_songs/pages/spalsh_screen.dart';
import 'package:apostolic_songs/widgets/theme_changer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'finder.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupFinder();
  _getTheme();
}

void _getTheme() async {
  final prefs = await SharedPreferences.getInstance();
  bool theme = prefs.getBool("theme");
  runApp(MyApp(theme == null ? false : theme));
}


class MyApp extends StatelessWidget {
  MyApp(this.darkMood);
  final bool darkMood;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger(darkMood? darkTheme: lightTheme)),
      ],
      child: MaterialAppWithTheme(),
    );
  }
}
class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      theme: theme.getTheme,
      debugShowCheckedModeBanner: false,
      home: HomeSplashScreen(),
    );
  }
}