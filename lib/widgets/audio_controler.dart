import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/widgets/seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioControler extends StatelessWidget {
  const AudioControler(this.player, this.lyrics, this.playPause);

  final AudioPlayer player;
  final Lyrics lyrics;
  final Function playPause;
  @override
  Widget build(BuildContext context) {
    PlayerState playerState = this.player.playerState;
    String title = this.lyrics.lyricTitle;
    String subtitle = this.lyrics.lryicArtist;
    return  Container(
          margin: const EdgeInsets.only(top: 0.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10.0, left: 6.0),
                      child:   CircleAvatar(
                      backgroundImage: AssetImage("assets/images/${this.lyrics.albumId}.jpg".toLowerCase()),
                    radius: 27.0,
                  ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title.length > 20 ?
                        title.substring(0, 20): title,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        Container(
                          margin: EdgeInsets.only(top: 2.0),
                          child: Text(subtitle,
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(playerState.playing? Icons.pause : Icons.play_arrow ),
                  iconSize: 50.0,
                  onPressed: (){
                    if(playerState.playing) this.player.pause();
                    else this.player.play();
                    this.playPause();
                  } 
                )
              ],
              
            ),  
            StreamBuilder<Duration>(
                stream: this.player.durationStream,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  return StreamBuilder<PositionData>(
                    stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                        this.player.positionStream,
                        this.player.bufferedPositionStream,
                        (position, bufferedPosition) =>
                            PositionData(position, bufferedPosition)),
                    builder: (context, snapshot) {
                      final positionData = snapshot.data ??
                          PositionData(Duration.zero, Duration.zero);
                      var position = positionData.position;
                      if (position > duration) {
                        position = duration;
                      }
                      var bufferedPosition = positionData.bufferedPosition;
                      if (bufferedPosition > duration) {
                        bufferedPosition = duration;
                      }
                      return SeekBar(
                        duration: duration,
                        position: position,
                        bufferedPosition: bufferedPosition,
                        onChangeEnd: (newPosition) {
                          this.player.seek(newPosition);
                        },
                      );
                    },
                  );
                },
              )        
          ],
        ),
        );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}