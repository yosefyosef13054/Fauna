import 'package:flutter/material.dart';

class ChoosePostType extends StatefulWidget {
  @override
  _ChoosePostTypeState createState() => _ChoosePostTypeState();
}

class _ChoosePostTypeState extends State<ChoosePostType> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("How do you want to post?"),
          Text(
              "You have 3 featured posts remaining. You can post normally or make your post featured also."),
        ],
      ),
    );
  }
}
