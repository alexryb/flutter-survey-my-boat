import 'package:flutter/material.dart';

class ApplicationTitle extends StatelessWidget {
  final title;
  final subtitle;
  final titleTextColor;
  final subTitleTextColor;
  const ApplicationTitle({super.key, this.title, this.subtitle, this.titleTextColor = Colors.black54, this.subTitleTextColor});
  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 5.0,
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 30.0, fontWeight: FontWeight.w700, color: titleTextColor),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          subtitle ?? "",
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: subTitleTextColor ?? titleTextColor),
        ),
      ],
    );
  }
}
