import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surveymyboatpro/model/survey_status.dart';
import 'package:surveymyboatpro/ui/page/home_page.dart';
import 'package:surveymyboatpro/ui/page/login/login_form_page.dart';
import 'package:surveymyboatpro/ui/page/login/logout_page.dart';
import 'package:surveymyboatpro/ui/page/login/signup_form_page.dart';
import 'package:surveymyboatpro/ui/page/notfound/notfound_page.dart';
import 'package:surveymyboatpro/ui/page/profile/profile_certification_page.dart';
import 'package:surveymyboatpro/ui/page/profile/profile_edit_page.dart';
import 'package:surveymyboatpro/ui/page/profile/profile_view_page.dart';
import 'package:surveymyboatpro/ui/page/settings/settings_page.dart';
import 'package:surveymyboatpro/ui/page/survey/create_survey_page.dart';
import 'package:surveymyboatpro/ui/page/survey/surveys_page.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/client_detail_page.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/clients_page.dart';
import 'package:surveymyboatpro/ui/page/surveyor/reg_std/regulation_standards_page.dart';
import 'package:surveymyboatpro/ui/page/timeline/payment_page.dart';
import 'package:surveymyboatpro/ui/page/timeline/timeline_page.dart';
import 'package:surveymyboatpro/ui/page/vessel/vessel_catalog_page.dart';
import 'package:surveymyboatpro/ui/widgets/file_source_dialog.dart';
import 'package:surveymyboatpro/utils/overrides.dart';
import 'package:surveymyboatpro/utils/rate_app.dart';
import 'package:surveymyboatpro/utils/translations.dart';
import 'package:surveymyboatpro/utils/uidata.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wiredash/wiredash.dart';

void main() async {
  HttpOverrides.global = new AppHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) RateApp.initialize();
  runApp(InspectMyBoatApplication());
}

class InspectMyBoatApplication extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InspectMyBoatApplicationState();
  }
}

class InspectMyBoatApplicationState extends State<InspectMyBoatApplication> with WidgetsBindingObserver {

  final _navigatorKey = GlobalKey<NavigatorState>();
  final _wiredashKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      projectId: "inspect-my-boat-intrmfe",
      secret: "7iohsin0stgxtx4tet8jq5jyxv6v2jijqo9bvpm6s8pr8gj7",
      key: _wiredashKey,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: UIData.appName,
        builder: (context, widget) => ResponsiveBreakpoints.builder(           
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ], child: widget!,
        ),
        // theme: ThemeData(
        //     primaryColor: Colors.blueGrey,
        //     fontFamily: UIData.quickFont,
        //     primarySwatch: Colors.orange),
        theme: Theme.of(context).copyWith(platform: TargetPlatform.android),
        debugShowCheckedModeBanner: true,
        showPerformanceOverlay: false,
        home: HomePage(),
        localizationsDelegates: [
          const TranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale("en", "US"),
          //const Locale("fr", "FR"),
        ],
        // initialRoute: UIData.notFoundRoute,
        //routes
        routes: <String, WidgetBuilder>{
          UIData.homeRoute: (BuildContext context) => HomePage(),
          UIData.viewProfileRoute: (BuildContext context) => ProfileViewPage(),
          UIData.editProfileRoute: (BuildContext context) => ProfileEditPage(),
          UIData.timelineRoute: (BuildContext context) => TimelinePage(),
          UIData.notFoundRoute: (BuildContext context) => NotFoundPage(),
          UIData.settingsRoute: (BuildContext context) => SettingsPage(),
          UIData.clientsRoute: (BuildContext context) => ClientsPage(),
          UIData.surveysRoute: (BuildContext context) => SurveysPage(),
          UIData.regulationStandardsRoute: (BuildContext context) => RegulationStandardsPage(),
          UIData.clientDetailsRoute: (BuildContext context) => ClientDetailPage(),
          UIData.loginFormRoute: (BuildContext context) => LoginFormPage(),
          UIData.logoutRoute: (BuildContext context) => LogoutPage(),
          UIData.signupFormRoute: (BuildContext context) => SignUpFormPage(),
          UIData.activeSurveyRoute: (BuildContext context) => SurveysPage(),
          UIData.archivedSurveyRoute: (BuildContext context) => SurveysPage(surveyStatus: SurveyStatus.Archived()),
          UIData.createNewSurveyRoute: (BuildContext context) => CreateSurveyPage(),
          UIData.vesselCatalogRoute: (BuildContext context) => VesselCatalogPage(),
          UIData.surveyorCertificatesRoute: (BuildContext context) => SurveyorCertificationPage(),
          UIData.paymentsHistoryRoute: (BuildContext context) => PaymentPage(),
          UIData.privacyPolicyRoute: (BuildContext context) => AnimatedFileSourceDialog(mdFileName: 'help/privacy.md',),
          UIData.tacRoute: (BuildContext context) => AnimatedFileSourceDialog(mdFileName: 'help/tac.md',),
        },
        onUnknownRoute: (RouteSettings rs) => new MaterialPageRoute(
          builder: (context) => new NotFoundPage(
            appTitle: UIData.coming_soon,
            icon: FontAwesomeIcons.solidSmile,
            title: UIData.coming_soon,
            message: "Under Development",
            iconColor: Colors.green,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.paused) {
      print("App paused");
    }
    if(state == AppLifecycleState.resumed) {
      print("App resumed");
    }
  }
}
