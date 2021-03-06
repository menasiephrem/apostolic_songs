import 'package:apostolic_songs/pages/fav_page.dart';
import 'package:apostolic_songs/pages/solo_albums_list.dart';
import 'package:apostolic_songs/widgets/serach.dart';
import 'package:apostolic_songs/widgets/theme_changer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chor_albums_list.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 1;

  _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _renderBody(){
    switch (_selectedIndex) {
      case 0:
       return ChoirAlbumsList();
      case 1:
       return SoloAlbumsList();
      case 2:
       return FavLyricsList();
      default:
      return Text("");
    }
  }

  void _persistThemeData(bool dark) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', dark);
  }

  @override
  Widget build(BuildContext context) {
    var _themeProvider = Provider.of<ThemeChanger>(context);
    ThemeData mode = _themeProvider.getTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("የጽዮን መዝሙሮች"),
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
            ),
            IconButton(
              icon: Icon(mode.brightness == Brightness.dark? Icons.wb_sunny: Icons.lightbulb_outline),
              onPressed: () {
                _themeProvider.setTheme(_themeProvider.getTheme==lightTheme?darkTheme:lightTheme);
                _persistThemeData(_themeProvider.getTheme==darkTheme);
              },
            ),
          ],
      ),
      
      body: _renderBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'የህብረት',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'የግል',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite ),
            label: 'የተመረጡ',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow[900],
        onTap: _onTap,
      )
    );
  }
}