import 'dart:io';

import 'package:apostolic_songs/models/playlist.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'List/playlist_item.dart';

class SavedPlaylists extends StatefulWidget {
  SavedPlaylists();

  @override
  _SavedPlaylistsState createState() => _SavedPlaylistsState();
}

class _SavedPlaylistsState extends State<SavedPlaylists> {

  Box<Playlist> playlistBox;
  List<Playlist> playlist;
  String downloadPath = "";

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
      _loadPlaylist();
  }

  void _loadPlaylist() async{
    var _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Apostolic Songs';
    List<Playlist> _playlist = playlistBox.values.toList();
    setState(() {
     playlist = _playlist;
     downloadPath = _localPath;
    });
  }

  Future<String> _findLocalPath() async {
    final directory =  await getExternalStorageDirectory();
    return directory.path;
  }

   _genrateSongListItem(BuildContext context) {
     return playlist
        .map<Widget>(
          (playlist) => 
            PlaylistItem(playlist, downloadPath)
        )
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
       child: playlist != null?
          playlist.length == 0 ?
          Center(child: Text("ምንም የተቀመጡ መዝሙሮች የሉም 😔")):
          ListView(
            children: _genrateSongListItem(context),
          ): 
        Center(child: CircularProgressIndicator(),)
    );
  }
}