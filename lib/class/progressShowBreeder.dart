import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget progressShow(firstEnable, secondEnable, thirdEnable) {
  return Row(
    children: [
      Expanded(
          flex: 1,
          child: firstEnable
              ? selectedDotted()
              : unSelectedDotted()),
      Expanded(
          flex: 5,
          child: lineSet()),
      Expanded(
          flex: 1,
          child: secondEnable
              ? selectedDotted()
              : unSelectedDotted()),
      Expanded(
          flex: 5,
          child: lineSet()),
      Expanded(
          flex: 1,
          child: thirdEnable
              ? selectedDotted()
              : unSelectedDotted()),
    ],
  );
}

lineSet() {
  return Image.asset("assets/beederSelectionGroup/linedata.webp");
}

unSelectedDotted() {
  return Image.asset("assets/beederSelectionGroup/unselected.webp",height: 15.0);
}

selectedDotted() {
  return Image.asset("assets/beederSelectionGroup/selected.webp",height: 30.0);
}
