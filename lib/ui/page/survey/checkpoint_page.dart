import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/code_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/survey_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/survey_view_model.dart';
import 'package:surveymyboatpro/model/checkpoint.dart';
import 'package:surveymyboatpro/model/checkpoint_condition_list.dart';
import 'package:surveymyboatpro/model/checkpoint_fix_priority.dart';
import 'package:surveymyboatpro/model/checkpoint_fix_priority_list.dart';
import 'package:surveymyboatpro/model/checkpoint_status.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/ui/page/generic/image_picker_page.dart';
import 'package:surveymyboatpro/ui/page/survey/survey_page.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/survey_tile.dart';

class CheckPointPage extends StatefulWidget {
  Survey? survey;
  Map<String, List<DropdownMenuItem<String>>>? codes;
  CheckPoint? checkPoint;

  CheckPointPage.withSurvey(
      {
        Survey? survey,
        CheckPoint? checkPoint,
        Map<String, List<DropdownMenuItem<String>>>? codes,
        CheckPoint? parentCheckPoint
      }) {
    this.survey = survey;
    this.checkPoint = checkPoint;
    this.codes = codes;
  }

  @override
  State<StatefulWidget> createState() {
    return CheckPointPageState();
  }
}

class CheckPointPageState extends State<CheckPointPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static Size? deviceSize;
  bool? wildCard = true;
  List<List<CheckPoint>>? rowList;

  FocusNode _manufacturerFocusNode = FocusNode();
  FocusNode _modelFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _changesNotedFocusNode = FocusNode();
  FocusNode _severityNotesFocusNode = FocusNode();
  FocusNode _constructionMaterialFocusNode = FocusNode();
  FocusNode _conditionFocusNode = FocusNode();
  FocusNode _fixPriorityFocusNode = FocusNode();

  SurveyBloc? _surveyBloc;
  CodeBloc? _codeBloc;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;

  Widget _checkPointCard() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
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
                              vertical: 0.0, horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            initialValue:
                                this.widget.checkPoint.generalDescription,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            focusNode: _descriptionFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Description",
                              suffixIcon: Icon(Icons.description),
                            ),
                            onChanged: (un) {
                              this.widget.checkPoint.setStatus(CheckPointStatus.UnCompleted());
                              this.widget.checkPoint.generalDescription = un;
                            },
                            textInputAction: TextInputAction.newline,
                            onFieldSubmitted: (_) {
                              this.widget.checkPoint.setStatus(CheckPointStatus.UnCompleted());
                              fieldFocusChange(context, _descriptionFocusNode,
                                  _changesNotedFocusNode);
                            },
                          ),
                        ),
                        if (this.widget.checkPoint.constructionMaterial != null)
                          Visibility(
                            visible: true,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 30.0),
                              child: DropdownButtonFormField<String>(
                                value: this
                                    ._codeBloc
                                    .getSelectedDropdownMenuItem(
                                        this
                                            .widget
                                            .codes["constructionMaterial"],
                                        this
                                            .widget
                                            .checkPoint
                                            .constructionMaterial)
                                    .value,
                                items:
                                    this.widget.codes["constructionMaterial"],
                                focusNode: _constructionMaterialFocusNode,
                                autofocus: true,
                                decoration: InputDecoration(
                                  labelText: "Construction Material",
                                  //suffixIcon: Icon(Icons.short_text),
                                ),
                                onChanged: (un) {
                                  this.widget.checkPoint.setStatus(CheckPointStatus.UnCompleted());
                                  this
                                      .widget
                                      .checkPoint
                                      .constructionMaterial
                                      .code = un;
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
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              initialValue: this.widget.checkPoint.changesNoted,
                              focusNode: _changesNotedFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Changes Noted",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.widget.checkPoint.setStatus(CheckPointStatus.UnCompleted());
                                this.widget.checkPoint.changesNoted = un;
                              },
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                this.widget.checkPoint.setStatus(CheckPointStatus.UnCompleted());
                                fieldFocusChange(
                                    context,
                                    _changesNotedFocusNode,
                                    _severityNotesFocusNode);
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: DropdownButtonFormField<String>(
                              value: this
                                  ._codeBloc
                                  .getSelectedDropdownMenuItem(
                                      this.widget.codes["checkPointCondition"],
                                      this.widget.checkPoint.condition)
                                  .value,
                              items: this.widget.codes["checkPointCondition"],
                              focusNode: _conditionFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Condition",
                                suffixIcon: Icon(Icons.short_text),
                              ),
                              onChanged: (un) {
                                this.widget.checkPoint.condition = CheckPointConditionList.getByCode(un);
                                _surveyBloc.setCheckPointStatusRecursive(
                                    this.widget.checkPoint, un);
                                setState(() {
                                  childCheckPointsCard();
                                });
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: this.widget.checkPoint.fixPriority != null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: DropdownButtonFormField<String>(
                              value: this
                                  ._codeBloc
                                  .getSelectedDropdownMenuItem(
                                      this
                                          .widget
                                          .codes["checkPointFixPriority"],
                                      this.widget.checkPoint.fixPriority)
                                  .value,
                              items: this.widget.codes["checkPointFixPriority"],
                              focusNode: _fixPriorityFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Fix Priority",
                                //suffixIcon: Icon(Icons.short_text),
                              ),
                              onChanged: (un) {
                                this.widget.checkPoint.setStatus(CheckPointStatus.UnCompleted());
                                this.widget.checkPoint.fixPriority =
                                    CheckPointFixPriorityList.getByCode(un);
                                setState(() {
                                  _checkPointCard();
                                });
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              "NAN" != this.widget.checkPoint.fixPriority.code,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              initialValue:
                                  this.widget.checkPoint.severityNotes,
                              focusNode: _severityNotesFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Severity Notes",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) =>
                                  this.widget.checkPoint.severityNotes = un,
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                this.widget.checkPoint.setStatus(CheckPointStatus.UnCompleted());
                                fieldFocusChange(
                                    context,
                                    _severityNotesFocusNode,
                                    _constructionMaterialFocusNode);
                              },
                              validator: (value) {
                                if (value.isEmpty && this.widget.checkPoint.fixPriority != CheckPointFixPriority.NoIssue()) {
                                  return "Required Field";
                                }
                              }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 1,
                              initialValue: this.widget.checkPoint.manufacturer,
                              focusNode: _manufacturerFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Manufacturer",
                                suffixIcon: Icon(Icons.short_text),
                              ),
                              onChanged: (un) =>
                                  this.widget.checkPoint.manufacturer = un,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                this.widget.checkPoint.setStatus(CheckPointStatus.UnCompleted());
                                fieldFocusChange(context,
                                    _manufacturerFocusNode, _modelFocusNode);
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              initialValue: this.widget.checkPoint.model,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 1,
                              focusNode: _modelFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Model",
                                suffixIcon: Icon(Icons.short_text),
                              ),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                this.widget.checkPoint.setStatus(CheckPointStatus.UnCompleted());
                                fieldFocusChange(context, _modelFocusNode,
                                    _descriptionFocusNode);
                              },
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
        child: Container(
          decoration: new BoxDecoration(
            color: _surveyBloc.checkPointStatusColor(this.widget.checkPoint),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 15.0),
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
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if(validateSubmit(_formKey, _scaffoldKey,  context)) {
                        _navigateToParent();
                      }
                    }
                  ),
                  new ApplicationTitle(
                    title: this.widget.survey.surveyNumber,
                    subtitle: this.widget.checkPoint.parent != null ? '${this.widget.checkPoint.parent.name} >> ${this.widget.checkPoint.name}' : '${this.widget.checkPoint.name}',
                    titleTextColor: Colors.white,
                  ),
                  new IconButton(
                    icon: new Icon(
                      Icons.help_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showHelpScreen(context, "${this.widget.checkPoint.name} Page Help", "checkpoint.md");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
  );

  Widget _checkPointImagesCard() => Container(
        child: Visibility(
          visible: !this.widget.checkPoint.expressMode,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _checkPointImages(),
          ),
        ),
      );

  Widget _checkPointAttributesCard() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _checkPointAttributes(),
        ),
      );

  Widget childCheckPointsCard() => Container(
        child: Visibility (
            visible: !this.widget.checkPoint.expressMode,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _childCheckPoints(this.rowList, false),
          ),
        ),
      );

  Widget _allCards() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _topBannerCard(),
            this.widget.checkPoint.hasChild ? _expressModeForm() : SizedBox.shrink(),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _checkPointCard(),
                  _checkPointAttributesCard(),
                  Visibility(
                    visible:
                    this.widget.checkPoint.expressMode || _surveyBloc
                        .checkSurveyCompleted(this.widget.checkPoint.children),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                      width: double.infinity,
                      child: RaisedButton(
                        padding: EdgeInsets.all(12.0),
                        shape: StadiumBorder(),
                        child: Text(
                          "Done with ${this.widget.checkPoint.name}",
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.2,
                        ),
                        color: Colors.green,
                        onPressed: () {
                          if (this.widget.checkPoint.status != CheckPointStatus.NotAvailable()) {
                            this.widget.checkPoint.status = CheckPointStatus.Completed();
                          }
                          if(validateSubmit(_formKey, _scaffoldKey,  context)) {
                            _navigateToParent();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _searchCard(true),
            Divider(),
            childCheckPointsCard(),
            _checkPointImagesCard(),
          ],
        ),
      );

  Widget _searchCard(bool visible) => Visibility(
        visible: !this.widget.checkPoint.expressMode,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.search),
                    onPressed: () {
                      List<CheckPoint> chp = this
                          ._surveyBloc
                          .findCheckPointByName(this.widget.survey.checkPoints,
                          List<CheckPoint>.empty(growable: true), wildCard);
                      if (chp.isNotEmpty) {
                        if (chp.length > 1)
                          showPopup(context, _checkPointsPopupBody(chp),
                              'Search Result');
                        else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CheckPointPage.withSurvey(
                                          survey: this.widget.survey,
                                          checkPoint: chp[0],
                                          codes: this.widget.codes)));
                      }
                    },
                  ),
                  Expanded(
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.black)),
                          filled: true,
                          labelText: "Find Check Point"),
                      onChanged: (un) => this._surveyBloc.searchString = un,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
              _allCards(),
            ],
          ),
          floatingActionButton: _takePhotoActionButton(),
          bottomNavigationBar: feedbackBottomBar(context),
        ));
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();
    _surveyBloc = new SurveyBloc();
    _codeBloc = new CodeBloc();
    this.rowList = _surveyBloc.convertListOfCheckPointsTo2dList(
        3, this.widget.checkPoint.children);
  }

  @override
  void dispose() {
    _surveyBloc?.dispose();
    _codeBloc?.dispose();
    _apiStreamSubscription?.cancel();
    super.dispose();
  }

  List<Widget> _checkPointImages() {
    List<Widget> rows = List<Widget>.empty(growable: true);
    if (this.widget.checkPoint.images != null) {
      for (var i = 0; i < this.widget.checkPoint.images.length; i++) {
        rows.add(
          new Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
            child:  Dismissible(
                key: ObjectKey(this.widget.checkPoint.images[i].imageGuid),
                child: Image.memory(this.widget.checkPoint.images[i].content),
                onDismissed: (direction) {
                  setState(() {
                    this.widget.checkPoint.images.removeAt(i);
                  });
                }),
          ),
        );
      }
    }
    return rows;
  }

  List<Widget> _checkPointAttributes() {
    List<Widget> rows = List<Widget>.empty(growable: true);
    for (var i = 0; i < this.widget.checkPoint.attributeValues.length; i++) {
      rows.add(
        new Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            maxLines: null,
            initialValue: this.widget.checkPoint.attributeValues[i].value,
            decoration: InputDecoration(
              labelText: this
                  .widget
                  .checkPoint
                  .attributeValues[i]
                  .inspectAreaAttribute
                  .description,
              suffixIcon: Icon(Icons.short_text),
            ),
            onChanged: (un) => {
              this.widget.checkPoint.attributeValues[i].value = un,
              this.widget.checkPoint.status = CheckPointStatus.UnCompleted(),
            },
            onFieldSubmitted: (_) {
              this.widget.checkPoint.status = CheckPointStatus.UnCompleted();
            },
          ),
        ),
      );
    }
    return rows;
  }

  List<Widget> _childCheckPoints(List<List<CheckPoint>> _rowList, bool _popup) {
    List<Widget> rows = List<Widget>.empty(growable: true);
    for (var i = 0; i < _rowList.length; i++) {
      List<CheckPoint> checkPoints = _rowList[i];
      List<Widget> columns = List<Widget>.empty(growable: true);
      for (var j = 0; j < checkPoints.length; j++) {
        columns.add(
          new SizedBox(
            height: deviceSize.height / 10,
            width: deviceSize.width / 3.4,
            child: new RaisedButton(
              padding: EdgeInsets.all(10.0),
              shape: StadiumBorder(),
              child: Text(
                '${checkPoints[j].name}',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
              ),
              color: _surveyBloc.checkPointStatusColor(checkPoints[j]),
              onPressed: () {
                checkPoints[j].parent = this.widget.checkPoint;
                if (_popup) Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckPointPage.withSurvey(
                            survey: this.widget.survey,
                            checkPoint: checkPoints[j],
                            codes: this.widget.codes)));
              },
            ),
          ),
        );
        columns.add(
          SizedBox(
            width: 5.0,
          ),
        );
      }
      rows.add(new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: columns,
      ));
      rows.add(
        SizedBox(
          height: 20.0,
        ),
      );
    }
    return rows;
  }

  Widget _checkPointsPopupBody(List<CheckPoint> chp) {
    if (chp.length > 12) {
      return SizedBox(
        width: 200.0,
        height: 200.0,
        child: Center(
          child: Text("Search is too broad"),
        ),
      );
    } else
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _childCheckPoints(
              _surveyBloc.convertListOfCheckPointsTo2dList(2, chp), true),
        ),
      );
  }

  Widget _takePhotoActionButton() {
    return Visibility(
        visible: true,
        child: FloatingActionButton(
          child: new Icon(
            Icons.add_a_photo,
            //color: Colors.blueGrey,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImagePickerPage.withSurveyImageContainer(
                    title: "Picture of \"${this.widget.checkPoint.name}\"",
                    survey: this.widget.survey,
                    imageContainer: this.widget.checkPoint,
                    codes: this.widget.codes),
              ),
            );
          },
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ));
  }

  void _navigateToParent() {
    if (this.widget.checkPoint.parent == null) {
      if(kIsWeb) _surveyBloc.saveSurvey(SurveyViewModel.save(this.widget.survey), apiType: ApiType.saveSurvey);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SurveyPage.Survey(
          surveyGuid: this.widget.checkPoint.surveyGuid,
          survey: this.widget.survey,
          codes: this.widget.codes)));
    } else {
      if(kIsWeb) _surveyBloc.saveSurvey(SurveyViewModel.save(this.widget.survey), apiType: ApiType.saveCheckPoint);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CheckPointPage.withSurvey(
                    survey: this.widget.survey,
                    checkPoint: this.widget.checkPoint.parent,
                    codes: this.widget.codes,
                  )));
    }
  }

  Widget _expressModeForm() => Container (
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        const Text("Express Mode"),
        Checkbox(
          value: this.widget.checkPoint.expressMode,
          onChanged: (bool value) {
            setState(() {
              this.widget.checkPoint.expressMode = value;
            });
            _surveyBloc.setCheckPointExpressRecursive(this.widget.checkPoint);
          },
        )
      ],
    ),
  );
}
