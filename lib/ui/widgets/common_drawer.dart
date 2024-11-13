import 'package:flutter/material.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/ui/page/home_page.dart';
import 'package:surveymyboatpro/ui/page/profile/profile_view_page.dart';
import 'package:surveymyboatpro/ui/page/settings/settings_page.dart';
import 'package:surveymyboatpro/ui/page/survey/surveys_page.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/clients_page.dart';
import 'package:surveymyboatpro/ui/widgets/about_tile.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

class CommonDrawer extends StatelessWidget {

  String? currentPage;

  CommonDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
                Injector.SETTINGS!.onlineMode! ? "OnLine Mode ${Injector.SETTINGS?.buildType}" : "Offline Mode ${Injector.SETTINGS?.buildType}",
                style: TextStyle(
                  color: Injector.SETTINGS!.onlineMode! ? Colors.white : Colors.amber,
                  fontWeight: Injector.SETTINGS!.onlineMode! ? FontWeight.normal : FontWeight.bold,
                ),
            ),
            accountEmail: Text(
              Injector.SETTINGS!.onlineMode! ? Injector.SETTINGS!.syncOnDataNetwork! ? "Sync over Data" : "Sync over WiFi" : "",
            ),
            currentAccountPicture: new CircleAvatar(
              radius: 60,
              backgroundImage: new AssetImage(UIData.imbLogoIcon),
              backgroundColor: Colors.transparent,
            ),
          ),
          Divider(),
          new ListTile(
            title: Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.home,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage()));
            },
          ),
          Divider(),
          new ListTile(
            title: Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.person,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileViewPage()));
            },
          ),
          Divider(),
          new ListTile(
            title: Text(
              "Clients",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.people,
              color: Colors.green,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClientsPage()));
            },
          ),
          Divider(),
          new ListTile(
            title: Text(
              "Surveys",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.dashboard,
              color: Colors.cyan,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SurveysPage()));
            },
          ),
          // Divider(),
          // new ListTile(
          //   title: Text(
          //     "Vessels",
          //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
          //   ),
          //   leading: Icon(
          //     Icons.directions_boat,
          //     color: Colors.cyan,
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => VesselCatalogPage()));
          //   },
          // ),
          Divider(),
          new ListTile(
            title: Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.settings,
              color: Colors.brown,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPage()));
            },
          ),
          Divider(),
          new ListTile(
            title: Text(
              "About",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.question_answer_outlined,
              color: Colors.blueGrey,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyAboutTile()));
            },
          ),
          Divider(),
          new ListTile(
            title: Text(
              "Exit",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.brown,
            ),
            onTap: () {
              confirmExitDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
