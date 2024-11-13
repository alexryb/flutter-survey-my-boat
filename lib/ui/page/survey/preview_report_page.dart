
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/ui/page/survey/preview_report_state_base.dart';

class PreviewReportPage extends StatefulWidget {

  bool generate = true;
  Survey survey;
  Map<String, List<DropdownMenuItem<String>>> codes;

  String title = "Survey Report Preview";

  PreviewReportPage.Survey(this.survey, this.codes, {this.generate = true});

  @override
  State<StatefulWidget> createState() {
    return kIsWeb ?
      PreviewReportPageStateWeb(this.title, this.survey, this.codes)
        : PreviewReportPageStateWeb(this.title, this.survey, this.codes);
  }

}

class PreviewReportPageStateWeb extends PreviewReportPageStateBase<PreviewReportPage> {

  PreviewReportPageStateWeb(
    String title,
    Survey survey,
    Map<String, List<DropdownMenuItem<String>>> codes
  ) : super(title, survey, codes);

  void showInterstitialAd() {  }
  void hideInterstitialAd() {  }
}

class PreviewReportPageStateApp extends PreviewReportPageStateBase<PreviewReportPage> {

  PreviewReportPageStateApp(
      String title,
      Survey survey,
      Map<String, List<DropdownMenuItem<String>>> codes
      ) : super(title, survey, codes);

}
