import 'package:apostolic_songs/pages/fav_page.dart';
import 'package:apostolic_songs/pages/solo_albums_list.dart';
import 'package:apostolic_songs/widgets/serach.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
          ],
      ),
      
      body: _renderBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('የህብረት'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('የግል'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite ),
            title: Text('የተመረጡ'),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow[900],
        onTap: _onTap,
      )
    );
  }
}