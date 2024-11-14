import 'package:flutter/material.dart';
import 'package:surveymyboatpro/ui/widgets/common_scaffold.dart';
import 'package:surveymyboatpro/ui/widgets/survey_tile.dart';

class NotFoundPage extends StatelessWidget {
  final String? appTitle;
  final String? title;
  final String? message;
  final IconData? icon;
  final Color? iconColor;

  const NotFoundPage(
      {super.key,
      this.appTitle = "Search",
      this.title = "No Result",
      this.message = "Try a more general keyword.",
      this.icon = Icons.search,
      this.iconColor = Colors.black});

  Widget bodyData() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 100.0,
              color: iconColor,
            ),
            SizedBox(
              height: 20.0,
            ),
            ApplicationTitle(
              title: title,
              subtitle: message,
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appTitle: appTitle,
      bodyWidget: bodyData(),
      showDrawer: false,
      showFAB: false,
    );
  }
}
