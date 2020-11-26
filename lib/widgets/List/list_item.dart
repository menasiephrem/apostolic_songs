import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
 const ListItem(this.title, this.subtitle, this.imaAddress, this.callback);

 final String title;
 final String subtitle;
 final String imaAddress;
 final VoidCallback callback;


  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {

  String userName;
  String lastMessage;



  buildAvater(String imagAddress){
    return  CircleAvatar(
              backgroundColor: Colors.transparent,
              child:  Container(
                  child: Image.asset('assets$imagAddress'),
              ),
              radius: 25.0,
            );
  }


  @override
  Widget build(BuildContext context) {
    String title = this.widget.title;
    String subtitle = this.widget.subtitle;
    return 
    InkWell( 
      onTap: this.widget.callback,
      child: Container(
        child: Container(
          margin: const EdgeInsets.only(top: 7.0),
          child: Column(children: [
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
          Padding( padding: const EdgeInsets.only(top: 3.0), ),
          Divider(color: Colors.grey, height: 2,)
          ],
        ),
        ),
    ));
  }
}
