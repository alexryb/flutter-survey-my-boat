import 'package:about/about.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAboutTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS ||
        theme.platform == TargetPlatform.macOS;

    Widget aboutPage = AboutPage(
      values: {
        'version': '1.0.0',
        'year': DateTime.now().year.toString(),
        'buildNumber': '24',
      },
      dialog: true,
      applicationVersion: 'Version {{ version }}, build #{{ buildNumber }}',
      applicationDescription: Text(
        'The application allows marine surveyors to log findings during the survey across more than 200 check points (Hull, Keel, Rudder, Cabin, Bridge, Marine Electronics, Galley, Sanitation, etc.) \nand get the final printable report in PDF format.',
        textAlign: TextAlign.justify,
      ),
      applicationIcon: FlutterLogo(size: 60),
      applicationLegalese: '© Realico Inc., {{ year }}',
      children: <Widget>[
        LicensesPageListTile(
          title: Text('Open source Licenses'),
          icon: Icon(Icons.local_police),
        ),
      ],
    );

    if (isIos) {
      return CupertinoApp(
        title: 'About Demo (Cupertino)',
        home: aboutPage,
        theme: CupertinoThemeData(
          brightness: theme.brightness,
        ),
      );
    }
    return aboutPage;
  }
}


