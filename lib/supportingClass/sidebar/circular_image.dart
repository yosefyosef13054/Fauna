import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final double _width, _height;
  final ImageProvider image;

  CircularImage(this.image, {double width = 120, double height = 120})
      : _width = width,
        _height = height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: image, fit: BoxFit.cover),
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 10,
        //     color: Colors.black45,
        //   )
        // ]
      ),
    );
  }
}
