import 'package:apostolic_songs/models/lyrics.dart';
import 'package:apostolic_songs/pages/lyrics_page.dart';
import 'package:apostolic_songs/services/lyrics_service.dart';
import 'package:apostolic_songs/widgets/List/list_item.dart';
import 'package:flutter/material.dart';

import '../finder.dart';


class CustomSearchDelegate extends SearchDelegate {

LyricsService _lyricsService = locator<LyricsService>();

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }


  _genrateSongListItem(BuildContext context, List<Lyrics> lyrics) {
     return lyrics
        .map<Widget>(
          (lyric) => 
            ListItem(lyric.lyricTitle, lyric.lryicArtist, "/images/${lyric.albumId}.jpg".toLowerCase(), () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LyricsPage(lyric)),
              )
            })
        )
        .toList();
  }


  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "የፍለጋ ቃል ከሁለት ፊደላት በላይ መሆን አለበት ።",
            ),
          )
        ],
      );
    }


     
  return
   FutureBuilder(
          future: _lyricsService.searchLyrics(context, query),
          builder: (context,  snapshot) {
          if (!snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
              ],
            );
          } else if (snapshot.data.length == 0) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      "የፈልጋው ቃል ምንም መልስ አልሰጠም",
                    ),
                  )
                ],
              );
          } else {
            var results = snapshot.data;
            return  ListView(
              children: _genrateSongListItem(context, results)
            );
          }
        },
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes. 
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}