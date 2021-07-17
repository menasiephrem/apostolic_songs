import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_changer.dart';

class ListItem extends StatefulWidget {
 const ListItem(this.title, this.subtitle, this.imaAddress, this.callback, {this.musicButton});

 final String title;
 final String subtitle;
 final String imaAddress;
 final VoidCallback callback;
 final Widget musicButton;


  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {

  String userName;
  String lastMessage;

  buildAvater(String imagAddress){
    return  CircleAvatar(
              backgroundImage: AssetImage('assets$imagAddress'),
              radius: 27.0,
            );
  }


  @override
  Widget build(BuildContext context) {
    String title = this.widget.title;
    String subtitle = this.widget.subtitle;
    var _themeProvider = Provider.of<ThemeChanger>(context);
    ThemeData mode = _themeProvider.getTheme;
    return 
    InkWell( 
      onTap: this.widget.callback,
      child: Container(
        child: Container(
          margin: const EdgeInsets.only(top: 7.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10.0, left: 6.0, top: 2.0),
                      child: buildAvater(this.widget.imaAddress),
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
                Spacer(),
                Spacer(),
                Expanded(
                    child: SizedBox(
                      height: 40,
                      child: widget.musicButton
                    )
                  )
              ],
            ),
          Padding( padding: const EdgeInsets.only(top: 3.0), ),
          Padding( padding: const EdgeInsets.only(left: 65.0), child: 
            Divider(color: Colors.grey[ mode.brightness == Brightness.dark ? 700: 400], height: 2,)
          ),
          
          ],
        ),
        ),
    ));
  }
}
