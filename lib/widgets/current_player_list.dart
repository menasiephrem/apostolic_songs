import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/pages/player_page.dart';
import 'package:apostolic_songs/widgets/audio_controler.dart';
import 'package:apostolic_songs/widgets/play_blob_button.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

import 'List/list_item.dart';

class CurrentPlayerList extends StatelessWidget {
  const CurrentPlayerList();

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
                return  AudioServiceWidget(child: AudioControler(lyrics, (){}, false));
              },
            )
          );
        }
      )
    ],
  );
 }
}