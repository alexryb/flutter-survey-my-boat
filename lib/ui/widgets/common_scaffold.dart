import 'package:flutter/material.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_drawer.dart';
import 'package:surveymyboatpro/ui/widgets/custom_float.dart';

class CommonScaffold extends StatelessWidget {
  final String? appTitle;
  final Widget? bodyWidget;
  final Widget? bottomNavigationWidget;
  final showFAB;
  final VoidCallback? floatAction1Callback;
  final VoidCallback? floatAction2Callback;
  final VoidCallback? floatAction3Callback;
  final VoidCallback? floatAction4Callback;
  final VoidCallback? firstActionCallback;
  final VoidCallback? secondActionCallback;
  final VoidCallback? thirdActionCallback;
  final showDrawer;
  final backGroundColor;
  final actionFirstIcon;
  final actionSecondIcon;
  final actionThirdIcon;
  final scaffoldKey;
  final showBottomNav;
  final floatingIcon1;
  final floatingIcon2;
  final floatingIcon3;
  final floatingIcon4;
  final centerDocked;
  final elevation;
  final automaticallyImplyLeading;

  CommonScaffold({
      this.appTitle,
      this.bodyWidget,
      this.bottomNavigationWidget,
      this.showFAB = false,
      this.floatAction1Callback,
      this.floatAction2Callback,
      this.floatAction3Callback,
      this.floatAction4Callback,
      this.firstActionCallback,
      this.secondActionCallback,
      this.thirdActionCallback,
      this.showDrawer = true,
      this.backGroundColor,
      this.actionFirstIcon = Icons.search,
      this.actionSecondIcon = Icons.report,
      this.actionThirdIcon = Icons.help_outline,
      this.scaffoldKey,
      this.showBottomNav = false,
      this.centerDocked = false,
      this.floatingIcon1,
      this.floatingIcon2,
      this.floatingIcon3,
      this.floatingIcon4,
      this.automaticallyImplyLeading = true,
      this.elevation = 4.0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey != null ? scaffoldKey : null,
      backgroundColor: backGroundColor != null ? backGroundColor : null,
      appBar: AppBar(
        elevation: elevation,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: Colors.black,
        title: Text(appTitle!),
        actions: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          IconButton(
            onPressed: firstActionCallback,
            icon: Icon(actionFirstIcon),
          ),
          IconButton(
            onPressed: secondActionCallback,
            icon: Icon(actionSecondIcon),
          ),
          IconButton(
            onPressed: thirdActionCallback,
            icon: Icon(actionThirdIcon),
          )
        ],
      ),
      drawer: showDrawer ? CommonDrawer() : null,
      body: bodyWidget,
      floatingActionButton: _floatingActionButtons(),
      floatingActionButtonLocation: centerDocked
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: showBottomNav ? (bottomNavigationWidget ?? feedbackBottomBar(context, callBackAction: () {  })) : null,
    );
  }

  Widget? _floatingActionButtons() {
    if(!showFAB) return null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if(floatAction1Callback != null)
          CustomFloat(
            builder: centerDocked ?
              Text(
                "5",
                style: TextStyle(color: Colors.white, fontSize: 10.0),
              ) : null,
            heroTag: "btn1",
            icon: floatingIcon1,
            floatingActionCallback: floatAction1Callback,
          ),
        if(floatAction2Callback != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CustomFloat(
              builder: centerDocked ?
              Text(
                "5",
                style: TextStyle(color: Colors.white, fontSize: 10.0),
              ) : null,
              heroTag: "btn2",
              icon: floatingIcon2,
              floatingActionCallback: floatAction2Callback,
            ),
          ),
        if(floatAction3Callback != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CustomFloat(
              builder: centerDocked ?
              Text(
                "5",
                style: TextStyle(color: Colors.white, fontSize: 10.0),
              ) : null,
              heroTag: "btn3",
              icon: floatingIcon3,
              floatingActionCallback: floatAction3Callback,
            ),
          ),
        if(floatAction4Callback != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CustomFloat(
              builder: centerDocked ?
              Text(
                "5",
                style: TextStyle(color: Colors.white, fontSize: 10.0),
              ) : null,
              heroTag: "btn4",
              icon: floatingIcon4,
              floatingActionCallback: floatAction4Callback,
            ),
          ),
      ],
    );
  }

}
