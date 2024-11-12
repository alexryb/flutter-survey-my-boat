import 'package:flutter/material.dart';

class Menu {
  String? title;
  IconData? icon;
  String? image;
  List<String>? items;
  BuildContext? context;
  Color? menuColor;
  String? path;
  bool? visible;

  Menu(
      {this.title,
      this.icon,
      this.image,
      this.items,
      this.context,
      this.menuColor = Colors.blueGrey,
      this.path,
      this.visible});
}
