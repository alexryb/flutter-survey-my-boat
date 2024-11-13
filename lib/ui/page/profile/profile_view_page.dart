import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/ui/page/home_page.dart';
import 'package:surveymyboatpro/ui/page/login/identity_page.dart';
import 'package:surveymyboatpro/ui/page/profile/profile_edit_page.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_divider.dart';
import 'package:surveymyboatpro/ui/widgets/common_scaffold.dart';
import 'package:surveymyboatpro/ui/widgets/survey_tile.dart';

class ProfileViewPage extends StatefulWidget {
  ProfileViewPage();

  @override
  State<StatefulWidget> createState() {
    return ProfileViewPageState();
  }
}

class ProfileViewPageState extends State<ProfileViewPage> {
  static Size? deviceSize;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget? displayWidget = progressWithBackground();

  Surveyor? _surveyor;
  bool? _readOnly = true;

  //Column1
  Widget profileColumn() => Container(
        height: deviceSize!.height * 0.3,
        child: FittedBox(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ApplicationTitle(
                  title: _surveyor?.fullname,
                  subtitle: _surveyor?.title,
                  subTitleTextColor: Colors.black,
                ),
                CommonDivider(height: 25,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(80.0)),
                          border: new Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: _surveyor?.image()!.image,
                          foregroundColor: Colors.black,
                          radius: 80.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  //column2

  //column3
  Widget certificationsColumn() => Container(
        width: 500,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              _getCertificatesString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
      );

  String _getCertificatesString() {
    String _result = "";
    for (var i = 0; i < _surveyor!.certifications!.length; i++) {
      _result = _result +
          _surveyor!.certifications![i].description! + '\n' +
          "(" +
          _surveyor!.certifications![i].certificateNumber! +
          ")\n\n";
    }
    return _result;
  }

  //column4
  Widget persColumn() => Container(
          height: deviceSize!.height * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ApplicationTitle(
                      title: "Phone",
                      subtitle: _surveyor?.phoneNumber,
                      subTitleTextColor: Colors.black,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ApplicationTitle(
                      title: "Email",
                      subtitle: _surveyor?.emailAddress,
                      subTitleTextColor: Colors.black,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Address",
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w700, color: Colors.black54),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 500,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            _surveyor?.addressLine == null ? "" : _surveyor!.addressLine!,
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      );

  Widget orgColumn() => Container(
          height: deviceSize!.height * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.fill,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ApplicationTitle(
                      title: "Business #",
                      subtitle: _surveyor?.organization?.businessNumber,
                      subTitleTextColor: Colors.black,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    ApplicationTitle(
                      title: "Company Name",
                      subtitle: _surveyor?.organization?.name,
                      subTitleTextColor: Colors.black,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    ApplicationTitle(
                      title: "Business Email",
                      subtitle: _surveyor?.organization?.emailAddress,
                      subTitleTextColor: Colors.black,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    ApplicationTitle(
                      title: "Business Phone",
                      subtitle: _surveyor?.organization?.phoneNumber,
                      subTitleTextColor: Colors.black,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Mailing Address",
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w700, color: Colors.black54),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 500,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            _surveyor?.organization?.addressLine == null ? "" : _surveyor!.organization!.addressLine!,
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      );

  Widget _profileBodyData() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          profileColumn(),
          SizedBox(
            height: 10.0,
          ),
          if (_surveyor?.organization == null) persColumn(),
          if (_surveyor?.organization != null) orgColumn(),
          Divider(
            height: 40,
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
          certificationsColumn(),
        ],
      ),
    );
  }

  Widget _profileScaffold() => CommonScaffold(
      scaffoldKey: _scaffoldKey,
      appTitle: "My Profile",
      showDrawer: true,
      showFAB: true,
      showBottomNav: false,
      //automaticallyImplyLeading: false,
      // actionSecondIcon: Icons.book,
      // secondActionCallback: () {},
      // actionThirdIcon: Icons.help_outline,
      // thirdActionCallback: () {
      //   showHelpScreen(context, "Select Survey Help", "surveys.md");
      // },
      //backGroundColor: Colors.blueGrey,
      bodyWidget: _profileBodyData(),
      floatingIcon1: Icons.edit,
      floatAction1Callback: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileEditPage.withUser(_surveyor!)));
      },
    );

  @override
  initState() {
    super.initState();
    _gotoNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    { deviceSize = MediaQuery.of(context).size; }
    return new PopScope(onPopInvokedWithResult: _homePage, child: displayWidget!);
  }

  void _homePage(bool val, dynamic Object) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void _gotoNextScreen() {
    if (_surveyor == null) {
      StorageBloc _localStorageBloc = new StorageBloc();
      Future.delayed(Duration(seconds: 3));
      _localStorageBloc.loadSurveyor().then((_surveyor) {
        if (_surveyor != null) {
          this._surveyor = _surveyor;
          setState(() => displayWidget = _profileScaffold());
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IdentityPage()));
        }
      });
      _localStorageBloc.dispose();
    } else {
      setState(() => displayWidget = _profileScaffold());
    }
  }
}
