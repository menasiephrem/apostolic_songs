import 'package:apostolic_songs/widgets/current_player_list.dart';
import 'package:flutter/material.dart';

class MusicPage extends StatefulWidget {
  MusicPage();

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [TabBar (
        labelColor: Color(0xffa59671),
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        tabs: [ Tab(text: "Curret Playing"), Tab(text: "Saved Playlist") ],
      ),
       Expanded(
        child: TabBarView(
          children:_getTabChildren(),
        ),
      )
    ] 
            
      ));
  }

  _getTabChildren() {
    return [
      CurrentPlayerList(),
      Center(
        child: SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width - 40,
          child: Image.asset(
              "assets/images/no_music.png",
              alignment: Alignment.center,
            )
      ))
    ];
  }
}

