import 'dart:async';

import 'package:apostolic_songs/models/media_item.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final _audioPlayer = AudioPlayer();
  List<MediaItem> _queue = [];
  List<MediaItem> get queue => _queue;

  int get index => _audioPlayer.playbackEvent.currentIndex;
  MediaItem get mediaItem => index == null ? null : queue[index];

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    _loadMediaItemsIntoQueue(params);
    // Connect to the URL
    AudioServiceBackground.setState(
        controls: [MediaControl.play, MediaControl.stop],
        playing: false,
        processingState: AudioProcessingState.connecting);
      
      
        
      await _audioPlayer.setFilePath(params['path']);
    // Now we're ready to play
   // _audioPlayer.play();

    AudioServiceBackground.setState(
        controls: [MediaControl.play, MediaControl.stop],
        playing: false,
        processingState: AudioProcessingState.ready);

    _audioPlayer.durationStream.listen((duration) {
      _updateQueueWithCurrentDuration(duration);
    });
  }

  void _loadMediaItemsIntoQueue(Map<String, dynamic> params) {
    _queue.clear();
    ASMediaItem mediaItem = ASMediaItem.fromJson(params['data']);
    queue.add(mediaItem.item);
  }

  void _updateQueueWithCurrentDuration(Duration duration) {
    final songIndex = _audioPlayer.playbackEvent.currentIndex;
    print('current index: $songIndex, duration: $duration');
    final modifiedMediaItem = mediaItem.copyWith(duration: duration);
    _queue[songIndex] = modifiedMediaItem;
    AudioServiceBackground.setMediaItem(_queue[songIndex]);
    AudioServiceBackground.setQueue(_queue);
  }

  @override
  Future<void> onStop() async {
    // Stop playing audio
    await _audioPlayer.stop();
    // Shut down this background task
    AudioServiceBackground.setState(
        controls: [MediaControl.pause, MediaControl.stop],
        playing: true,
        processingState: AudioProcessingState.ready);
    await super.onStop();
  }

  @override
  Future<void> onPlay() async {
    // Broadcast that we're playing, and what controls are available.
    AudioServiceBackground.setState(
        controls: [MediaControl.pause, MediaControl.stop],
        playing: true,
        processingState: AudioProcessingState.ready);
    // Start playing audio.
    await _audioPlayer.play();
  }

  @override
  Future<void> onPause() async {
    // Broadcast that we're paused, and what controls are available.
    AudioServiceBackground.setState(
        controls: [MediaControl.play, MediaControl.stop],
        playing: false,
        processingState: AudioProcessingState.ready);
    // Pause the audio.
    await _audioPlayer.pause();
  }
}