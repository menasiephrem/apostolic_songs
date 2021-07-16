import 'dart:math';

import 'package:apostolic_songs/models/lyrics.dart';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:apostolic_songs/widgets/theme_changer.dart';
import 'package:provider/provider.dart';

class AudioControler extends StatelessWidget {
  const AudioControler(this.lyrics, this.playPause, this.showOnlyProgress);
  final Lyrics lyrics;
  final Function playPause;
  final bool showOnlyProgress;

  Duration _getPos(MediaState state){
    if((state?.mediaItem?.duration?.inSeconds ?? 0) - (state?.position?.inSeconds ?? 0) < 1){
      return Duration.zero;
    }else return state?.position ?? Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    var _themeProvider = Provider.of<ThemeChanger>(context);
    ThemeData mode = _themeProvider.getTheme;
    String title = this.lyrics.lyricTitle;
    String subtitle = this.lyrics.lryicArtist;
    return  Container(
          margin: const EdgeInsets.only(top: 0.0),
          color: !showOnlyProgress ? mode.brightness == Brightness.dark ? Colors.grey[800]: Colors.white : null,
          child: Column(children: [
            if(!showOnlyProgress) albumArt(title, subtitle, context),  
              StreamBuilder<MediaState>(
                stream: _mediaStateStream,
                builder: (context, snapshot) {
                  final mediaState = snapshot.data;
                  return SeekBar(
                    duration:
                    mediaState?.mediaItem?.duration ?? Duration.zero,
                    position: _getPos(mediaState),
                    onChangeEnd: (newPosition) {
                      AudioService.seekTo(newPosition);
                    },
                  );
                },
              ),      
          ],
        ),
        );
  }

  Row albumArt(String title, String subtitle, BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      // do nothing
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.0, left: 6.0),
                      child:   CircleAvatar(
                      backgroundImage: AssetImage("assets/images/${this.lyrics.albumId}.jpg".toLowerCase()),
                    radius: 27.0,
                                  ),
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
               StreamBuilder<bool>(
                  stream: AudioService.playbackStateStream
                      .map((state) => state.playing)
                      .distinct(),
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    return IconButton(
                          icon: Icon(playing? Icons.pause : Icons.play_arrow ),
                          iconSize: 50.0,
                          onPressed: (){
                           if(AudioService.running){
                             if(playing) AudioService.pause();
                             else AudioService.play();
                           }else{
                            this.playPause();
                           }
                          } 
                        );
                  },
                )
              
            ],
            
          );
  }
}

  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MediaState> get _mediaStateStream =>
      Rx.combineLatest2<MediaItem, Duration, MediaState>(
          AudioService.currentMediaItemStream,
          AudioService.positionStream,
          (mediaItem, position) => MediaState(mediaItem, position));


class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
   this.duration,
    this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final value = min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
        widget.duration.inMilliseconds.toDouble());
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }
    return Stack(
      children: [
        Slider(
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: value,
          onChanged: (value) {
            if (!_dragging) {
              _dragging = true;
            }
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd(Duration(milliseconds: value.round()));
            }
            _dragging = false;
          },
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration > widget.position ? widget.duration - widget.position : Duration.zero;
}

class MediaState {
  final MediaItem mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}