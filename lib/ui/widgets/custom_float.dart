import 'package:flutter/material.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

class CustomFloat extends StatelessWidget {
  final IconData? icon;
  final String? heroTag;
  final Widget? builder;
  final VoidCallback? floatingActionCallback;
  final isMini;

  CustomFloat(
      {this.icon,
      this.builder,
      this.floatingActionCallback,
      this.isMini = false,
      this.heroTag});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      clipBehavior: Clip.antiAlias,
      heroTag: heroTag,
      mini: isMini,
      onPressed: floatingActionCallback,
      child: Ink(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: UIData.kitGradients)),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            builder != null
                ? Positioned(
                    right: 7.0,
                    top: 7.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: builder,
                      radius: 10.0,
                    ),
                  )
                : Container(),
            // builder
          ],
        ),
      ),
    );
  }
}
