import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CommonSwitch extends StatelessWidget {
  final defValue;
  final ValueChanged<bool> onChanged;

  CommonSwitch({this.defValue = false, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.android
        ? Switch(
            value: defValue,
            onChanged: (val) => onChanged(val),
          )
        : CupertinoSwitch(
            value: defValue,
            onChanged: (val) => onChanged(val),
          );
  }


}
