import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/ui/page/home_page_state_base.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  State<StatefulWidget> createState() {
    return kIsWeb ? HomePageStateWeb() : HomePageStateApp();
  }
}

class HomePageStateWeb extends HomePageStateBase<HomePage> {

}

class HomePageStateApp extends HomePageStateBase<HomePage> {
}
