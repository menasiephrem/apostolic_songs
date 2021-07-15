import 'package:flutter/material.dart';

class Blob extends StatelessWidget {
  final double rotation;
  final double scale;
  final Color color;

  const Blob({this.color, this.rotation = 0, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(22),
              bottomRight: Radius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}
