import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/survey_bloc.dart';
import 'package:surveymyboatpro/model/checkpoint_status.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/ui/page/survey/survey_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/survey_tile.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SeaTraillPage extends StatefulWidget {
  Survey? survey;
  Map<String, List<DropdownMenuItem<String>>>? codes;

  SeaTraillPage.withSurvey({super.key, required Survey survey, required Map<String, List<DropdownMenuItem<String>>> codes}) {
    this.survey = survey;
    this.codes = codes;
  }

  @override
  State<StatefulWidget> createState() {
    return SeaTraillPageState();
  }
}

class SeaTraillPageState extends State<SeaTraillPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static Size? deviceSize;

  final FocusNode _dateConductedFocusNode = FocusNode();
  final FocusNode _weatherConditionFocusNode = FocusNode();
  final FocusNode _commentsFocusNode = FocusNode();
  final FocusNode _engineStartupFocusNode = FocusNode();
  final FocusNode _attendedPersonsFocusNode = FocusNode();
  final FocusNode _vibrationsFocusNode = FocusNode();
  final FocusNode _engineControlOperationFocusNode = FocusNode();
  final FocusNode _steeringTestFocusNode = FocusNode();
  final FocusNode _enginePerformanceFocusNode = FocusNode();
  final FocusNode _vesselLoadFocusNode = FocusNode();
  final FocusNode _doneWithFocusNode = FocusNode();

  TextEditingController? _seaTrailDateTextController;

  final _dateMaskFormatter = new MaskTextInputFormatter(
      mask: "####-##-##", filter: {"#": RegExp(r'[0-9]')});

  SurveyBloc? _surveyBloc;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;

  Widget _seaTrailCard() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.0),
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            keyboardType: TextInputType.datetime,
                            maxLines: null,
                            inputFormatters: [_dateMaskFormatter],
                            controller: _seaTrailDateTextController,
                            focusNode: _dateConductedFocusNode,
                            autofocus: true,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Date of Sea Trial",
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            onChanged: (un) {
                              widget.survey?.seaTrail?.dateConducted = un;
                              setState(() => _seaTrailDateTextController);
                            },
                            textInputAction: TextInputAction.next,
                            onTap: () {
                              selectDate(context, _seaTrailDateTextController!);
                            },
                            onFieldSubmitted: (_) {
                              fieldFocusChange(context, _dateConductedFocusNode,
                                  _weatherConditionFocusNode);
                            },
                            validator: (value) {
                                if (value!.isEmpty) {
                                  return "Required Field";
                                }
                                final components = value.split("-");
                                if (components.length == 3) {
                                  final day = int.tryParse(components[2]);
                                  final month = int.tryParse(components[1]);
                                  final year = int.tryParse(components[0]);
                                  if (day != null &&
                                      month != null &&
                                      year != null) {
                                    final date = DateTime(year, month, day);
                                    if (date.year == year &&
                                        date.month == month &&
                                        date.day == day) {
                                      return null;
                                    }
                                  }
                                }
                                return "Wrong date format (yyyy-mm-dd)";
                            }
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              initialValue:
                                  widget.survey?.seaTrail?.weatherCondition,
                              focusNode: _weatherConditionFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Weather Condition",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                widget.survey?.seaTrail?.weatherCondition =
                                    un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context,
                                    _weatherConditionFocusNode,
                                    _attendedPersonsFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty || '*' == value) {
                                  return "Required field";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              initialValue:
                                  widget.survey?.seaTrail?.attendedPersons,
                              focusNode: _attendedPersonsFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Attended Persons",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                widget.survey?.seaTrail?.attendedPersons =
                                    un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context,
                                    _attendedPersonsFocusNode,
                                    _engineStartupFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty || '*' == value) {
                                  return "Required field";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              initialValue:
                                  widget.survey?.seaTrail?.engineStartup,
                              focusNode: _engineStartupFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Engine Start Up",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                widget.survey?.seaTrail?.engineStartup = un;
                              },
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context,
                                    _engineStartupFocusNode,
                                    _engineControlOperationFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty || '*' == value) {
                                  return "Required field";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              initialValue: widget
                                  .survey
                                  ?.seaTrail
                                  ?.engineControlOperation,
                              focusNode: _engineControlOperationFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Engine Control Operations",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                widget
                                    .survey
                                    ?.seaTrail
                                    ?.engineControlOperation = un;
                              },
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context,
                                    _engineControlOperationFocusNode,
                                    _enginePerformanceFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty || '*' == value) {
                                  return "Required field";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              initialValue:
                                  widget.survey?.seaTrail?.enginePerformance,
                              focusNode: _enginePerformanceFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Engine Performance",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                widget.survey?.seaTrail?.enginePerformance =
                                    un;
                              },
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context,
                                    _enginePerformanceFocusNode,
                                    _steeringTestFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty || '*' == value) {
                                  return "Required field";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              initialValue:
                                  widget.survey?.seaTrail?.steeringTest,
                              focusNode: _steeringTestFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Steering Test",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                widget.survey?.seaTrail?.steeringTest = un;
                              },
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context,
                                    _steeringTestFocusNode,
                                    _vibrationsFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty || '*' == value) {
                                  return "Required field";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              initialValue:
                                  widget.survey?.seaTrail?.vibrations,
                              focusNode: _vibrationsFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Vibrations Noted",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                widget.survey?.seaTrail?.vibrations = un;
                              },
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context, _vibrationsFocusNode,
                                    _vesselLoadFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty || '*' == value) {
                                  return "Required field";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              initialValue:
                                  widget.survey?.seaTrail?.vesselLoad,
                              focusNode: _vesselLoadFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Vessel Load",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                widget.survey?.seaTrail?.vesselLoad = un;
                              },
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context, _vesselLoadFocusNode,
                                    _commentsFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty || '*' == value) {
                                  return "Required field";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              initialValue:
                                  widget.survey?.seaTrail?.comments,
                              focusNode: _commentsFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Comments",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                widget.survey?.seaTrail?.comments = un;
                              },
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context, _commentsFocusNode,
                                    _doneWithFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty || '*' == value) {
                                  return "Required field";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 30.0),
                            width: double.infinity,
                            child: MaterialButton(
                              focusNode: _doneWithFocusNode,
                              padding: EdgeInsets.all(12.0),
                              shape: StadiumBorder(),
                              color: Colors.green,
                              onPressed: () {
                                if(widget.survey?.seaTrail?.status != CheckPointStatus.NotAvailable()) {
                                  if (validateSubmit(_formKey, _scaffoldKey, context)) {
                                    widget.survey?.seaTrail?.status = CheckPointStatus.Completed();
                                    _navigateToSurvey();
                                  }
                                } else {
                                  _navigateToSurvey();
                                }
                              },
                              child: Text(
                                "Done with Sea Trial",
                                style: TextStyle(color: Colors.white),
                                textScaleFactor: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _topBannerCard() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 18.0),
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(
                      defaultTargetPlatform == TargetPlatform.android
                          ? Icons.arrow_back
                          : Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    onPressed: () => _navigateToSurvey(),
                  ),
                  new ApplicationTitle(
                    title: "Survey ${widget.survey?.surveyNumber}",
                    subtitle: "\"${widget.survey?.vessel?.name}\" Sea Trial",
                    titleTextColor: Colors.black,
                  ),
                  new IconButton(
                    icon: new Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget allCards() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _topBannerCard(),
            _skipSeaTrailForm(),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _seaTrailCard(),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
     { deviceSize = MediaQuery.of(context).size; }
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              allCards(),
            ],
          ),
          bottomNavigationBar: feedbackBottomBar(context, callBackAction: () {  }),
        ));
  }

  @override
  void initState() {
    super.initState();
    _surveyBloc = new SurveyBloc();
    _seaTrailDateTextController =
        TextEditingController(text: widget.survey?.seaTrail?.dateConducted);
    _apiStreamSubscription =
        apiCallSubscription(_surveyBloc!.apiResult, context, widget: widget);
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _navigateToSurvey() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SurveyPage.Survey(survey: widget.survey!, codes: widget.codes!)));
    // int count = 0;
    // Navigator.of(context)
    //     .popUntil((_) => count++ >= 1);
  }

  Widget _skipSeaTrailForm() => Container (
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        const Text("Skip Sea Trial", textScaleFactor: 1.2,),
        Checkbox(
          value: widget.survey?.seaTrail?.status == CheckPointStatus.NotAvailable(),
          onChanged: (value) {
            setState(() {
              if(value!) {
                widget.survey?.seaTrail?.status = CheckPointStatus.NotAvailable();
              } else {
                widget.survey?.seaTrail?.status = CheckPointStatus.UnCompleted();
              }
            });
          },
        )
      ],
    ),
  );

  @override
  void dispose() {
    _surveyBloc?.dispose();
    _apiStreamSubscription?.cancel();
    super.dispose();
  }
}
