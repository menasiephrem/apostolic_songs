import 'dart:async';
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
        controls: _getControls(false),
        playing: false,
        processingState: AudioProcessingState.connecting);
        
      await _loadPlayer();

    AudioServiceBackground.setState(
        controls: _getControls(false),
        playing: false,
        processingState: AudioProcessingState.ready);

    _audioPlayer.durationStream.listen((duration) {
      _updateQueueWithCurrentDuration(duration);
      
    });

    _audioPlayer.positionStream.listen((postion) {
      if(_queue.length == 1) _checkLastItemPositoin(postion);
    });
  }

  String _loadMediaItemsIntoQueue(Map<String, dynamic> params) {
    _queue.clear();
    MediaItem mediaItem = MediaItem.fromJson(params['data']);
    queue.add(mediaItem);
    return mediaItem.extras['path'];
  }

  List<MediaControl> _getControls(bool isPlaying){
    List<MediaControl> ret = [];

    if(_queue.length > 1) ret.add(MediaControl.skipToPrevious);
    if(isPlaying) ret.add(MediaControl.pause);
    else ret.add(MediaControl.play);
    if(_queue.length > 1) ret.add(MediaControl.skipToNext);
    ret.add(MediaControl.stop);
    return ret;
  }

  void _updateQueueWithCurrentDuration(Duration duration) {
    final songIndex = _audioPlayer.playbackEvent.currentIndex;
    print('current index: $songIndex, duration: $duration');
    final modifiedMediaItem = mediaItem.copyWith(duration: duration);
    _queue[songIndex] = modifiedMediaItem;
    AudioServiceBackground.setMediaItem(_queue[songIndex]);
    AudioServiceBackground.setQueue(_queue);
    AudioServiceBackground.setState(position: Duration.zero);
  }

  void _checkLastItemPositoin(Duration positon) {
    if(_audioPlayer.duration == null) return;
    if(_audioPlayer.duration <= positon){
      onStop();
    }
  }

  Future<void> _loadPlayer() async{
     await _audioPlayer.setAudioSource(ConcatenatingAudioSource(
        children:
            queue.map((item) => AudioSource.uri(Uri.parse(item.extras['path']))).toList(),
      ));
  }


  @override
  Future<void> onStop() async {
    // Stop playing audio
    await _audioPlayer.stop();
    // Shut down this background task
    AudioServiceBackground.setState(
        controls: _getControls(false),
        playing: true,
        processingState: AudioProcessingState.ready);
    await super.onStop();
  }

  @override
  Future<void> onPlay() async {
    // Broadcast that we're playing, and what controls are available.
    AudioServiceBackground.setState(
        controls: _getControls(true),
        playing: true,
        processingState: AudioProcessingState.ready);
    // Start playing audio.
    await _audioPlayer.play();
  }

  @override
  Future<void> onPause() async {
    // Broadcast that we're paused, and what controls are available.
    AudioServiceBackground.setState(
        controls: _getControls(false),
        playing: false,
        processingState: AudioProcessingState.ready);
    // Pause the audio.
    await _audioPlayer.pause();
  }

  @override
  Future<void> onSeekTo(Duration duration) async {
    // Start playing audio.
    AudioServiceBackground.setState(position: duration);
    await _audioPlayer.seek(duration);
  }

  @override
  Future<void> onSkipToNext() async {
    if(!_audioPlayer.hasNext) return;
    _playItem(_audioPlayer.nextIndex);
  }

  @override
  Future<void> onSkipToPrevious() async {
     if(!_audioPlayer.hasPrevious) return;
    _playItem(_audioPlayer.previousIndex);
  }

  @override
  Future<void> onSkipToQueueItem(String mediaItemId) async {
    int index = queue.indexWhere((item) => item.id == mediaItemId);
    if(index == -1) return;
    _playItem(index);
  }

  Future<void> _playItem(int index) async{
    _audioPlayer.seek(Duration.zero, index: index);
    _updateQueueWithCurrentDuration(_audioPlayer.duration);
    AudioServiceBackground.setState(position: Duration.zero);
  }

  @override
  Future<void> onAddQueueItem(MediaItem item) async {
    var index = queue.indexWhere((element) => element.id == item.id);
    if(index > -1){
      _playItem(index);
      return;
    }
    queue.add(item);
    AudioServiceBackground.setMediaItem(item);
    AudioServiceBackground.setQueue(_queue);
  
    await _loadPlayer();
    _playItem(queue.length - 1);
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> list) async {
    queue.clear();
    queue.addAll(list);
    AudioServiceBackground.setMediaItem(list[0]);
    AudioServiceBackground.setQueue(_queue);
  
    await _loadPlayer();
    _playItem(0);
  }
}