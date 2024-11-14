
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/model/survey_status.dart';
import 'package:surveymyboatpro/ui/page/survey/surveys_page_state_base.dart';

class SurveysPage extends StatefulWidget {

  SurveyStatus? surveyStatus;

  SurveysPage({super.key, this.surveyStatus});

  @override
  State<StatefulWidget> createState() {
    return kIsWeb ? SurveysPageStateWeb(surveyStatus!) : SurveysPageStateApp(surveyStatus!);
  }
}

class SurveysPageStateWeb extends SurveysPageStateBase<SurveysPage> {

  SurveysPageStateWeb(SurveyStatus super.surveyStatus);

}

class SurveysPageStateApp extends SurveysPageStateBase<SurveysPage> {

  SurveysPageStateApp(SurveyStatus super.surveyStatus);
}
