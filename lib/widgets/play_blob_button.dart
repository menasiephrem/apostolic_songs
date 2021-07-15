import 'dart:math';

import 'package:apostolic_songs/widgets/blob.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  final String itemId;

  PlayButton({
    @required this.itemId,
  }) : assert(itemId != null);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);  
  static const _kRotationDuration = Duration(seconds: 5);

  bool isPlaying;

  // rotation and scale animations
  AnimationController _rotationController;
  AnimationController _scaleController;
  double _rotation = 0;
  double _scale = 0.17;

  bool get _showWaves => !_scaleController.isDismissed;

  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController.value * 0.17);

  @override
  void initState() {
    isPlaying = true;
    _rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(() => setState(_updateRotation))
          ..repeat();

    _scaleController =
        AnimationController(vsync: this, duration: _kToggleDuration)
          ..addListener(() => setState(_updateScale));

    super.initState();
  }

  void _onToggle(bool playing) {
    setState(() => isPlaying = !isPlaying);

    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
    }
	  
     if(AudioService.running){
      if(playing) AudioService.pause();
      else AudioService.play();
    }
  }

  Widget _buildIcon() {
   return StreamBuilder<bool>(
        stream: AudioService.playbackStateStream
            .map((state) => state.playing)
            .distinct(),
        builder: (context, snapshot) {
          final playing = snapshot.data ?? false;
          return SizedBox.expand(
            key: ValueKey<bool>(isPlaying),
            child: IconButton(
              icon: playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () => _onToggle(playing),
            ),
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AudioService.currentMediaItem.id == widget.itemId ? ConstrainedBox(
      constraints: BoxConstraints(minWidth: 4, minHeight: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_showWaves) ...[
            Blob(color: Color(0xff0092ff), scale: _scale, rotation: _rotation),
            Blob(color: Color(0xff4ac7b7), scale: _scale, rotation: _rotation * 2 - 30),
            Blob(color: Color(0xffa4a6f6), scale: _scale, rotation: _rotation * 3 - 45),
          ],
          Container(
            constraints: BoxConstraints.expand(),
            child: AnimatedSwitcher(
              child: _buildIcon(),
              duration: _kToggleDuration,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    ): Text("");
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}