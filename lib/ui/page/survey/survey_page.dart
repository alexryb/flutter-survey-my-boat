
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/ui/page/survey/survey_page_state_base.dart';

class SurveyPage extends StatefulWidget {
  String surveyGuid;
  Survey survey;
  Map<String, List<DropdownMenuItem<String>>> codes;

  SurveyPage.Survey({this.surveyGuid, this.survey, this.codes});

  @override
  State<StatefulWidget> createState() {
    return kIsWeb ?
      SurveyPageStateWeb.withSurvey(
        surveyGuid: surveyGuid, survey: survey, codes: codes) :
      SurveyPageStateApp.withSurvey(
        surveyGuid: surveyGuid, survey: survey, codes: codes)
    ;
  }
}

class SurveyPageStateWeb extends SurveyPageStateBase<SurveyPage> {

  SurveyPageStateWeb.withSurvey({
    String surveyGuid,
    Survey survey,
    Map<String, List<DropdownMenuItem<String>>> codes
  }) : super.withSurvey(surveyGuid: surveyGuid, survey: survey, codes: codes);

  void showInterstitialAd() {  }
  void hideInterstitialAd() {  }

}

class SurveyPageStateApp extends SurveyPageStateBase<SurveyPage> {

  SurveyPageStateApp.withSurvey({
    String surveyGuid,
    Survey survey,
    Map<String, List<DropdownMenuItem<String>>> codes
  }) : super.withSurvey(surveyGuid: surveyGuid, survey: survey, codes: codes);

}
