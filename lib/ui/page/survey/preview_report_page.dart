
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/ui/page/survey/preview_report_state_base.dart';

class PreviewReportPage extends StatefulWidget {

  bool generate = true;
  Survey survey;
  Map<String, List<DropdownMenuItem<String>>> codes;

  String title = "Survey Report Preview";

  PreviewReportPage.Survey(this.survey, this.codes, {super.key, this.generate = true});

  @override
  State<StatefulWidget> createState() {
    return kIsWeb ?
      PreviewReportPageStateWeb(title, survey, codes)
        : PreviewReportPageStateWeb(title, survey, codes);
  }

}

class PreviewReportPageStateWeb extends PreviewReportPageStateBase<PreviewReportPage> {

  PreviewReportPageStateWeb(
    String super.title,
    Survey super.survey,
    Map<String, List<DropdownMenuItem<String>>> super.codes
  );

  void showInterstitialAd() {  }
  void hideInterstitialAd() {  }
}

class PreviewReportPageStateApp extends PreviewReportPageStateBase<PreviewReportPage> {

  PreviewReportPageStateApp(
      String super.title,
      Survey super.survey,
      Map<String, List<DropdownMenuItem<String>>> super.codes
      );

}
