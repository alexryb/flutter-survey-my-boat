import 'package:flutter/material.dart';

class CommonDivider extends StatelessWidget {
  double height;

  CommonDivider({super.key, this.height = 15.0});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey.shade300,
      height: height,
    );
  }
}
