import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/code_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/survey_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/survey_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_list.dart';
import 'package:surveymyboatpro/model/survey_search_filter.dart';
import 'package:surveymyboatpro/model/survey_status.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/ui/page/home_page.dart';
import 'package:surveymyboatpro/ui/page/login/identity_page.dart';
import 'package:surveymyboatpro/ui/page/survey/create_survey_page.dart';
import 'package:surveymyboatpro/ui/page/survey/survey_page.dart';
import 'package:surveymyboatpro/ui/page/survey/surveys_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_scaffold.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

import '../generic/analytics_page_state.dart';

abstract class SurveysPageStateBase<T> extends AnalyticsState<SurveysPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  SurveysPageStateBase(this.surveyStatus);

  Widget displayWidget = progressWithBackground();
  static Size? deviceSize;

  Surveyor? _surveyor;
  SurveyList? _surveys;
  SurveyStatus? surveyStatus;
  SurveyBloc? _surveyBloc;
  CodeBloc? _codeBloc;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;

  Widget buttonStack(Image _img, Survey _survey) => Positioned(
    top: 5,
    left: 5,
    right: 5,
    bottom: 60,
    child: Container(
      child: MaterialButton(
        child: _img,
        onPressed: () {
          //if(!kIsWeb) showInterstitialAd();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SurveyPage.Survey(surveyGuid: _survey.surveyGuid)));
        },
        color: Color(0xff0c2b20).withOpacity(1),
      ),
    ),
  );

  //stack2
  Widget descStack(Survey _survey) => Positioned (
    bottom: 5.0,
    left: 5.0,
    right: 5.0,
    child: Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                '${_survey.surveyNumber} \n (${_survey.vessel!.model}) \n ${_survey.client!.fullName()}',
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget surveyGrid() => GridView.count(
    crossAxisCount:
    MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
    shrinkWrap: true,
    mainAxisSpacing: 5.0,
    crossAxisSpacing: 5.0,
    childAspectRatio: 1.0,
    children: _surveyCardList(),
  );

  List<Widget> _surveyCardList() {
    List<Widget> _result = List.empty(growable: true);
    int _count = 0;
    for (Survey _survey in _surveys!.elements!) {
      _result.add(
        Dismissible(
          key: ObjectKey(_survey.surveyGuid),
          onDismissed: (direction) {
            _surveys!.elements!.remove(_survey);
            setState(() => displayWidget = _surveysScaffold());
            _archiveSurvey(_survey);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              splashColor: Color(0xff0c2b20).withOpacity(1),
              borderRadius: BorderRadius.circular(15),
              onLongPress: () => _showSurveyDetailsQuickBar(_survey),
              onDoubleTap: () {
                //if(!kIsWeb) showInterstitialAd();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CreateSurveyPage.Clone(
                          _survey,
                          title: "Clone Survey from ${_survey.surveyNumber}",
                        )));
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                elevation: 2.0,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: <Widget>[
                    //menuColor(),
                    buttonStack(_image(_survey), _survey),
                    descStack(_survey),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      _count ++;
    }
    return _result;
  }

  Future<void> _archiveSurvey(Survey _survey) async {
    //If paid we set status Completed otherwise just Archived
    _survey.surveyStatus == SurveyStatus.Paid() ? SurveyStatus.Completed() : SurveyStatus.Archived();
    this._surveyBloc?.archiveSurvey(SurveyViewModel.archive(_survey.surveyGuid!));
    setState(() => displayWidget = _surveysScaffold());
  }

  Image _image(Survey survey) {
    return survey.vessel!.images!.isEmpty
        ? Image.asset(survey.vessel!.vesselType!.code == 'POWERBOAT' ?  UIData.noboatIcon : UIData.noboatIconSail,
        fit: BoxFit.fill, alignment: Alignment.topCenter)
        : Image.memory(survey.vessel!.images!.first.content!);
  }

  void _showSurveyDetailsQuickBar(Survey _survey) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        " " + _survey.toString(),
        textAlign: TextAlign.left,
      ),
      action: SnackBarAction(
        label: "Close",
        onPressed: () {},
      ),
    ));
  }

  @override
  initState() {
    super.initState();
    _surveys = new SurveyList();
    _surveyBloc = SurveyBloc();
    _codeBloc = new CodeBloc();
    _apiStreamSubscription =
        apiCallSubscription(_surveyBloc!.apiResult, context, widget: widget);
    _gotoNextScreen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _apiStreamSubscription?.cancel();
    _surveyBloc?.dispose();
    _codeBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    { deviceSize = MediaQuery.of(context).size; }
    return new WillPopScope(onWillPop: _homePage, child: displayWidget);
  }

  Future<bool> _homePage() {
    //hideInterstitialAd();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    return new Future.value(true);
  }

  Widget _surveysScaffold() {
    return CommonScaffold(
      scaffoldKey: _scaffoldKey,
      appTitle: "Surveys",
      showDrawer: true,
      showFAB: surveyStatus == null,
      showBottomNav: true,
      // actionSecondIcon: Icons.book,
      // secondActionCallback: () {},
      actionThirdIcon: Icons.help_outline,
      thirdActionCallback: () {
        showHelpScreen(context, "Select Survey Help", "surveys.md");
      },
      backGroundColor: Colors.blueGrey,
      bodyWidget: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshData,
          child: surveyGrid()
      ),
      floatingIcon1: Icons.add,
      floatAction1Callback: () {
        //if(!kIsWeb) showInterstitialAd();
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateSurveyPage()));
      },
    );
  }

  Future<Null> _refreshData() async {
    SurveySearchFilter searchFilter = new SurveySearchFilter();
    searchFilter.surveyorGuid = this._surveyor?.surveyorGuid;
    if(surveyStatus != null) {
      if(surveyStatus == SurveyStatus.Archived()) {
        searchFilter.appendStatus(surveyStatus!.code!);
        searchFilter.appendStatus(SurveyStatus.Completed().code!);
      } else if(surveyStatus == SurveyStatus.Completed()) {
        searchFilter.appendStatus(surveyStatus!.code!);
        searchFilter.appendStatus(SurveyStatus.Archived().code!);
      } else {
        searchFilter.appendStatus(surveyStatus!.code!);
      }
    } else {
      searchFilter.appendStatus(SurveyStatus.UnCompleted().code!);
      searchFilter.appendStatus(SurveyStatus.NotStarted().code!);
      searchFilter.appendStatus(SurveyStatus.Paid().code!);
    }
    _surveyBloc?.getSurveys(SurveyViewModel.search(searchFilter));
    return;
  }

  void _gotoNextScreen() {
    if (this._surveyor == null) {
      StorageBloc _localStorageBloc = new StorageBloc();
      _localStorageBloc.loadSurveyor().then((_surveyor) {
        if (_surveyor != null) {
          this._surveyor = _surveyor;
          _refreshData();
          _surveyBloc?.surveys.listen((surveyList) {
            if(surveyList != null) {
              this._surveys = surveyList;
            }
            setState(() => displayWidget = _surveysScaffold());
          });
          _localStorageBloc.dispose();
        } else {
          //hideInterstitialAd();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IdentityPage()));
        }
      });
      _localStorageBloc.dispose();
    } else {
      _refreshData();
      _surveyBloc?.surveys.listen((surveyList) {
        if(surveyList != null) {
          this._surveys = surveyList;
        }
        setState(() => displayWidget = _surveysScaffold());
      });
    }
  }
}
