import 'dart:isolate';
import 'dart:ui';
import 'dart:io';
import 'dart:async';

import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/services/lyrics_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../finder.dart';


class LyricsPage extends StatefulWidget {
  LyricsPage(this.lyrics);
  final Lyrics lyrics;
  @override
  _LyricsPageState createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  LyricsService _lyricsService = locator<LyricsService>();


  bool isFav = false;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;
  Lyrics lyrics;
  bool loading = false;
  bool showProgress = false;
  ReceivePort _port = ReceivePort();
  String downloadPath = "";

    @override
    void initState() { 
      super.initState();
      setState(() {
        lyrics = this.widget.lyrics;
      });
      _isFav();
      _getScaleConfig();
      _bindBackgroundIsolate();

      FlutterDownloader.registerCallback(downloadCallback);
    }

    @override
    void dispose() {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
      super.dispose();
    }

    void _bindBackgroundIsolate() {
      bool isSuccess = IsolateNameServer.registerPortWithName(
          _port.sendPort, 'downloader_send_port');
      if (!isSuccess) {
        _unbindBackgroundIsolate();
        _bindBackgroundIsolate();
        return;
      }
      _port.listen((dynamic data) {
        DownloadTaskStatus status = data[1];
        int progress = data[2];
        if(progress > 85){
          setState(() {
            showProgress = false;        
          });
        }

        if(status ==  DownloadTaskStatus.complete){
          Fluttertoast.showToast(
          msg: "Download Complete",
          toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
          );
        }
      });
    }

     void _unbindBackgroundIsolate() {
        IsolateNameServer.removePortNameMapping('downloader_send_port');
      }

    static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
      final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
      
      send.send([id, status, progress]);
    }

    _isFav() async {
      var _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Apostolic Songs';
      bool fav = await _lyricsService.isFav(this.widget.lyrics);
      setState(() {
        isFav = fav;
        downloadPath = _localPath;
      });
   }


     Future<String> _findLocalPath() async {
      final directory =  await getExternalStorageDirectory();
      return directory.path;
     }

    _setFav() async{
      await _lyricsService.setFav(this.widget.lyrics, !isFav);
      setState(() {
        isFav = !isFav;
      });
    }

      void _requestDownload() async {
        String albumid = lyrics.albumId;
        String albumNumber = albumid.substring(albumid.length - 1);
        String albumName = albumid.substring(0, albumid.length - 1);
        String url = "https://res.cloudinary.com/evolunt/raw/upload/v1620205036/apostolicSongsMp3/$albumName/$albumNumber/${lyrics.trackNumber}.mp3";
        var syncPath ="$downloadPath/$albumName/$albumNumber/";

        var exists = await File(syncPath +"${lyrics.trackNumber}.mp3").exists() ;
        if(exists){
          return;
        }
        
        final savedDir = Directory(syncPath);
        bool hasExisted = await savedDir.exists();
        if (!hasExisted) {
          await savedDir.create(recursive: true);
        }

        await FlutterDownloader.enqueue(
            url: url,
            savedDir: syncPath,
            showNotification: false,
            openFileFromNotification: false);
        setState(() {
          showProgress = true;        
        });
      }

    _updateScaleFactor(double scale){
       setState(() {
          _scaleFactor = _baseScaleFactor * scale;
      });
      _saveScaleConfig(scale);
    }

    _saveScaleConfig(double scale) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setDouble('font', _scaleFactor);
    }

     _getScaleConfig() async {
      final prefs = await SharedPreferences.getInstance();
      double scale = prefs.getDouble('font');
      setState(() {
        _scaleFactor = scale == null? 1 : scale;
      });
    }

    String _prepareShareText() {
      return "${lyrics.lyricTitle}\n\n${lyrics.lyricText}\n\n";
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Column(
          crossAxisAlignment: Platform.isAndroid? CrossAxisAlignment.start: CrossAxisAlignment.center,
          children: [
            Text(lyrics.lyricTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(lyrics.lryicArtist, style: TextStyle(fontSize: 16))
        ],),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(_prepareShareText());
            },
          )
        ]
      ),
      body:
      loading? Center(child: CircularProgressIndicator(),):
      Container(
       alignment: Alignment.topCenter,
       padding: EdgeInsets.only(top: 16),
       child: Flex(
         direction: Axis.vertical,
         children: [
            Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: GestureDetector(
                  onScaleStart: (details) {
                    _baseScaleFactor = _scaleFactor;
                  },
                  onScaleUpdate: (details) {
                    _updateScaleFactor(details.scale);
                  },
                  child: Text(lyrics.lyricText, textAlign: TextAlign.center, textScaleFactor: _scaleFactor, ),
                ),
              ),
            ),
               ( showProgress ? CircularProgressIndicator() : Text("")),
       ],) 
    ),
    floatingActionButton: SpeedDial(
      marginEnd: 18,
      marginBottom: 20,
      icon: Icons.add,
      activeIcon: Icons.remove,
      buttonSize: 56.0,
      visible: true,
      closeManually: false,
      renderOverlay: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      backgroundColor: Colors.orange[100],
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: isFav?  Icon(Icons.favorite, color: Colors.red[400],) : Icon(Icons.favorite_border),
          backgroundColor: Colors.orange[100],
          onTap: () => _setFav(),
          onLongPress: () => print('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(Icons.music_note),
          backgroundColor: Colors.orange[100],
          onTap: () => _requestDownload(),
          onLongPress: () => print('SECOND CHILD LONG PRESS'),
        ),
      ],
    ),
    );
  }
}