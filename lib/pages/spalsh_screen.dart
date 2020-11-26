import 'dart:async';

import 'package:apostolic_songs/pages/home_page.dart';
import 'package:flutter/material.dart';


class HomeSplashScreen extends StatefulWidget {
  HomeSplashScreen();

  @override
  _HomeSplashScreenState createState() => _HomeSplashScreenState();
}

class _HomeSplashScreenState extends State<HomeSplashScreen> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

    @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1400));
    animation = Tween<double>(begin: -350, end: 0).animate(animationController);
    animationController.forward();
    Timer(
        Duration(milliseconds: 2200),
            () {
          Navigator.of(context)
          .pushReplacement( MaterialPageRoute(builder: (BuildContext context) => HomePage() ));
            }
    );
  }
  @override
Widget build(BuildContext context) {
    return Scaffold(
      body:  InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
             Container(
              decoration:  BoxDecoration(
                gradient: RadialGradient(
                    colors: [const Color(0xffCCCCCC), const Color(0xffffffff),],
                    radius: 1.5,
                     ),
              ),
            ),
             Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                 Expanded(
                  flex: 2,
                  child:  Container(
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                          ),
                           AnimatedBuilder(animation: animation, builder: (BuildContext context, Widget chile){
                              return Transform.translate(
                                offset: Offset(animation.value, 0),
                                child: Column(
                                  children: [
                                   CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child:  Container(
                                          child: Image.asset('assets/icons/logo.png'),
                                      ),
                                      radius: 110.0,
                                   ),
                                   Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                   ),
                                   Text("በማስተዋል ዘምሩ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                                ],)  
                              );
                            }),
                        ],
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("")
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}