import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateApp {

  static RateMyApp rateMyApp = RateMyApp();
  static bool initInd = false;

  static void initialize() async {
    if(rateMyApp == null) {
      rateMyApp = RateMyApp(
        preferencesPrefix: 'RateApp_',
        minDays: 5,
        minLaunches: 5,
        remindDays: 10,
        remindLaunches: 10,
        googlePlayIdentifier: 'ca.realico.imb.ui.inspectmyboatpro',
      );
      await rateMyApp.init();
      initInd = true;
    }
  }

  void load(BuildContext context) {
    if (initInd && rateMyApp.shouldOpenDialog) {
      rateMyApp.showRateDialog(
        context,
        title: 'Rate Inspect My Boat', // The dialog title.
        message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
        rateButton: 'RATE', // The dialog "rate" button text.
        noButton: 'NO THANKS', // The dialog "no" button text.
        laterButton: 'MAYBE LATER', // The dialog "later" button text.
        listener: (button) { // The button click listener (useful if you want to cancel the click event).
          switch(button) {
            case RateMyAppDialogButton.rate:
              print('Clicked on "Rate".');
              break;
            case RateMyAppDialogButton.later:
              print('Clicked on "Later".');
              break;
            case RateMyAppDialogButton.no:
              print('Clicked on "No".');
              break;
          }
          return true; // Return false if you want to cancel the click event.
        },
        ignoreNativeDialog: Platform.isIOS, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
        dialogStyle: const DialogStyle(), // Custom dialog styles.
        onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
        // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
        // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
      );
    };
  }
}