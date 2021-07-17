import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/models/playlist.dart';
import 'package:apostolic_songs/pages/player_page.dart';
import 'package:apostolic_songs/widgets/audio_controler.dart';
import 'package:apostolic_songs/widgets/play_blob_button.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:miniplayer/miniplayer.dart';

import 'List/list_item.dart';

class CurrentPlayerList extends StatefulWidget {
  const CurrentPlayerList();

  @override
  _CurrentPlayerListState createState() => _CurrentPlayerListState();
}

class _CurrentPlayerListState extends State<CurrentPlayerList> {

  bool showSavePlaylist = true;
  TextEditingController _textFieldController = TextEditingController();
  Box<Playlist> playlistBox;

  @override
  void initState() {
    _openBox();
    
    super.initState();
  }

  void _openBox() async{
      var b = await Hive.openBox<Playlist>("playlistBox");
      setState(() {
        playlistBox = b;
      });
  }


  _genrateSongListItem(List<Lyrics> items, BuildContext context) {
     return items == null? [] : items
        .map<Widget>(
          (lyric) => 
            ListItem(lyric.lyricTitle, lyric.lryicArtist, "/images/${lyric.albumId}.jpg".toLowerCase(), (){
              print(AudioService.currentMediaItem?.id != lyric.id);
              if(AudioService.currentMediaItem?.id != lyric.id){
                AudioService.skipToQueueItem(lyric.id);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayerPage()),
              );
            }, musicButton: PlayButton(itemId: lyric.id))
        )
        .toList();
  }



  Future<void> _displayTextInputDialog(BuildContext context) async {  
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Playlist Name'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Name..."),
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                _savePlaylist(_textFieldController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _savePlaylist(String name) {

    Playlist playlist = Playlist();

    playlist.name = name;
    playlist.ids = AudioService.queue.map((q) => q.id).toList();
    playlist.createdAt = DateTime.now();

    playlistBox.add(playlist);


    setState((){
      showSavePlaylist = false;
    });
    
    Fluttertoast.showToast(
          msg: "Playlist Saved",
          toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
  }

  void _showDialog(BuildContext context){
    _displayTextInputDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
        child: StreamBuilder<List<MediaItem>>(
        stream: AudioService.queueStream,
        builder: (context, snapshot) {
          List<MediaItem> items = snapshot.data;
          List<Lyrics> lyrics = items == null ? [] : items.map((l) => Lyrics.fromMediaItem(l)).toList();
          return (
            lyrics.length == 0?
            Center(
              child: SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width - 40,
                child: Image.asset( 
                    "assets/images/no_music.png",
                    alignment: Alignment.center,
                  )
            )):
            ListView(
              children: _genrateSongListItem(lyrics ?? [],context),
            )
          );
        },
      )), 
      Align(
        alignment: Alignment(1,.50),
        child: showSavePlaylist ? FloatingActionButton(
          child: Icon(Icons.save),
          backgroundColor: Colors.orange[100],
          onPressed: () => _showDialog(context)
        ): Text(""),
      ),
      StreamBuilder<MediaItem>(
        stream: AudioService.currentMediaItemStream,
        builder: (context, snapshot){
          if(!snapshot.hasData) return Text("");
          Lyrics lyrics = Lyrics.fromMediaItem(snapshot.data);
          return (
            Miniplayer(
              backgroundColor: Colors.red,
              minHeight: 120,
              maxHeight: 120,
              onDismissed: (){},
              builder: (height, percentage) {
                return AudioControler(lyrics, (){}, false);
              },
            )
          );
        }
      )
    ],
  );
 }
 }