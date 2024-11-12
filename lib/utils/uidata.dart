import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class UIData {
  //routes
  static const String homeRoute = "/home";
  static const String viewProfileRoute = "/Profile";
  static const String editProfileRoute = "/Edit Profile";
  static const String surveyorCertificatesRoute = "/Certifications";
  static const String notFoundRoute = "/No Search Result";
  static const String timelineRoute = "/Feed";
  static const String settingsRoute = "/Settings";
  static const String clientsRoute = "/Clients";
  static const String surveysRoute = "/Surveys";
  static const String regulationStandardsRoute = "/Regulation Standards";
  static const String clientDetailsRoute = "/Client Details";
  static const String paymentCreditCardRoute = "/Credit Card";
  static const String paymentGooglePlayRoute = "/Google Play";
  static const String paymentPayPalRoute = "/PayPal";
  static const String paymentSuccessRoute = "/Payment Success";
  static const String loginFormRoute = "/Log in";
  static const String logoutRoute = "/Sign Out";
  static const String signupFormRoute = "/Sign Up";
  static const String activeSurveyRoute = "/Active Surveys";
  static const String archivedSurveyRoute = "/Archived Surveys";
  static const String createNewSurveyRoute = "/Start New Survey";
  static const String vesselCatalogRoute = "/Sailboats Catalog";
  static const String paymentsHistoryRoute = "/Payments History";
  static const String privacyPolicyRoute = "/Privacy Policy";
  static const String tacRoute = "/Terms & Conditions";
  static const String supportRoute = "/Support";

  //strings
  static const String appName = "Inspect My Boat Pro";

  //fonts
  static const String quickFont = "Quicksand";
  static const String ralewayFont = "Raleway";
  static const String quickBoldFont = "Quicksand_Bold.otf";
  static const String quickNormalFont = "Quicksand_Book.otf";
  static const String quickLightFont = "Quicksand_Light.otf";

  //images
  static const String imageDir = "assets/images";

  //icons
  static const String iconDir = "assets/icons";
  static const String userIcon = "$iconDir/user.jpg";
  static const String imbLogo = "$iconDir/imb-logo.png";
  static const String imbLogoIcon = "$iconDir/imb-logo-icon.jpg";
  static const String noboatIcon = "$iconDir/noboat.jpg";
  static const String noboatIconSail = "$iconDir/noboat_sail.jpg";

  //login
  static const String enter_code_label = "Phone Number";
  static const String enter_code_hint = "10 Digit Phone Number";
  static const String enter_otp_label = "OTP";
  static const String enter_otp_hint = "4 Digit OTP";
  static const String get_otp = "Get OTP";
  static const String resend_otp = "Resend OTP";
  static const String login = "Login";
  static const String enter_valid_number = "Enter 10 digit phone number";
  static const String enter_valid_otp = "Enter 4 digit otp";

  //gneric
  static const String error = "Error";
  static const String confirm = "Please confirm";
  static const String success = "Success";
  static const String ok = "OK";
  static const String yes = "YES";
  static const String no = "NO";
  static const String accept = "Accept";
  static const String cancel = "Cancel";
  static const String forgot_password = "Forgot Password?";
  static const String something_went_wrong = "Something went wrong";
  static const String coming_soon = "Coming Soon";

  static const MaterialColor ui_kit_color = Colors.grey;

//colors
  static List<Color> kitGradients = [
    // new Color.fromRGBO(103, 218, 255, 1.0),
    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    Colors.blueGrey.shade800,
    Colors.black87,
  ];
  static List<Color> kitGradients2 = [
    Colors.cyan.shade600,
    Colors.blue.shade900
  ];

  //randomcolor
  static final Random _random = new Random();

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }
}
