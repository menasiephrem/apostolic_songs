import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import '../theme_changer.dart';

class MusicBoardControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _themeProvider = Provider.of<ThemeChanger>(context);
    ThemeData mode = _themeProvider.getTheme;
    bool dark = mode.brightness == Brightness.dark ;
    int primaryColor = dark? 0xFF263652 : 0xFF7B92CA;
    int secondaryColor = dark? 0xFF9c9c9c:  0xFFDCE4F4 ;

    return Container(
      height: 100,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 245,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(secondaryColor),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 0,
                    offset: Offset(2, 1.5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: GestureDetector(
                      onTap: () => AudioService.skipToPrevious(),
                      child: Icon(
                        Icons.fast_rewind,
                        color: Color(primaryColor),
                        size: 40,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () => AudioService.skipToNext(),
                      child: Icon(
                        Icons.fast_forward,
                        color: Color(primaryColor),
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<bool>(
                stream: AudioService.playbackStateStream
                      .map((state) => state.playing)
                      .distinct(),
                builder:  (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  final playing = snapshot.data ?? false;
                  return GestureDetector(
                    onTap: () {
                      if (!playing) {
                        AudioService.play();
                      } else {
                        AudioService.pause();
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dark? Color(0xFFd1d1d1):  Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: Offset(2, 1.5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedCrossFade(
                          duration: Duration(milliseconds: 200),
                          crossFadeState: playing
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Icon(
                            Icons.pause,
                            size: 50,
                            color: Color(primaryColor),
                          ),
                          secondChild: Icon(
                            Icons.play_arrow,
                            size: 50,
                            color: Color(primaryColor),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
