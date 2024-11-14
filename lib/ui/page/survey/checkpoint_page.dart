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
      {super.key, 
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

  final FocusNode _manufacturerFocusNode = FocusNode();
  final FocusNode _modelFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _changesNotedFocusNode = FocusNode();
  final FocusNode _severityNotesFocusNode = FocusNode();
  final FocusNode _constructionMaterialFocusNode = FocusNode();
  final FocusNode _conditionFocusNode = FocusNode();
  final FocusNode _fixPriorityFocusNode = FocusNode();

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
                                widget.checkPoint!.generalDescription,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            focusNode: _descriptionFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Description",
                              suffixIcon: Icon(Icons.description),
                            ),
                            onChanged: (un) {
                              widget.checkPoint!.setStatus(CheckPointStatus.UnCompleted());
                              widget.checkPoint!.generalDescription = un;
                            },
                            textInputAction: TextInputAction.newline,
                            onFieldSubmitted: (_) {
                              widget.checkPoint!.setStatus(CheckPointStatus.UnCompleted());
                              fieldFocusChange(context, _descriptionFocusNode,
                                  _changesNotedFocusNode);
                            },
                          ),
                        ),
                        if (widget.checkPoint!.constructionMaterial != null)
                          Visibility(
                            visible: true,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 30.0),
                              child: DropdownButtonFormField<String>(
                                value: _codeBloc
                                    ?.getSelectedDropdownMenuItem(
                                        widget 
                                            .codes!["constructionMaterial"]!,
                                        widget
                                            .checkPoint!
                                            .constructionMaterial!)
                                    .value,
                                items:
                                    widget.codes!["constructionMaterial"],
                                focusNode: _constructionMaterialFocusNode,
                                autofocus: true,
                                decoration: InputDecoration(
                                  labelText: "Construction Material",
                                  //suffixIcon: Icon(Icons.short_text),
                                ),
                                onChanged: (un) {
                                  widget.checkPoint!.setStatus(CheckPointStatus.UnCompleted());
                                  widget
                                      .checkPoint
                                      !.constructionMaterial
                                      !.code = un;
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
                              initialValue: widget.checkPoint!.changesNoted,
                              focusNode: _changesNotedFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Changes Noted",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                widget.checkPoint!.setStatus(CheckPointStatus.UnCompleted());
                                widget.checkPoint!.changesNoted = un;
                              },
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                widget.checkPoint!.setStatus(CheckPointStatus.UnCompleted());
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
                              value: _codeBloc
                                  ?.getSelectedDropdownMenuItem(
                                      widget.codes!["checkPointCondition"]!,
                                      widget.checkPoint!.condition!)
                                  .value,
                              items: widget.codes!["checkPointCondition"],
                              focusNode: _conditionFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Condition",
                                suffixIcon: Icon(Icons.short_text),
                              ),
                              onChanged: (un) {
                                widget.checkPoint!.condition = CheckPointConditionList.getByCode(un!);
                                _surveyBloc?.setCheckPointStatusRecursive(
                                    widget.checkPoint!, un);
                                setState(() {
                                  childCheckPointsCard();
                                });
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.checkPoint!.fixPriority != null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: DropdownButtonFormField<String>(
                              value: _codeBloc
                                  ?.getSelectedDropdownMenuItem(
                                      widget
                                          .codes!["checkPointFixPriority"]!,
                                      widget.checkPoint!.fixPriority!)
                                  .value,
                              items: widget.codes!["checkPointFixPriority"],
                              focusNode: _fixPriorityFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Fix Priority",
                                //suffixIcon: Icon(Icons.short_text),
                              ),
                              onChanged: (un) {
                                widget.checkPoint!.setStatus(CheckPointStatus.UnCompleted());
                                widget.checkPoint!.fixPriority =
                                    CheckPointFixPriorityList.getByCode(un!);
                                setState(() {
                                  _checkPointCard();
                                });
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              "NAN" != widget.checkPoint!.fixPriority!.code,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              initialValue:
                                  widget.checkPoint!.severityNotes,
                              focusNode: _severityNotesFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Severity Notes",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) =>
                                  widget.checkPoint!.severityNotes = un,
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                widget.checkPoint!.setStatus(CheckPointStatus.UnCompleted());
                                fieldFocusChange(
                                    context,
                                    _severityNotesFocusNode,
                                    _constructionMaterialFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty && widget.checkPoint!.fixPriority != CheckPointFixPriority.NoIssue()) {
                                  return "Required Field";
                                }
                                return null;
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
                              initialValue: widget.checkPoint!.manufacturer,
                              focusNode: _manufacturerFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Manufacturer",
                                suffixIcon: Icon(Icons.short_text),
                              ),
                              onChanged: (un) =>
                                  widget.checkPoint!.manufacturer = un,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                widget.checkPoint!.setStatus(CheckPointStatus.UnCompleted());
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
                              initialValue: widget.checkPoint!.model,
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
                                widget.checkPoint!.setStatus(CheckPointStatus.UnCompleted());
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
            color: _surveyBloc?.checkPointStatusColor(widget.checkPoint!),
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
                    title: widget.survey!.surveyNumber,
                    subtitle: widget.checkPoint!.parent != null ? '${widget.checkPoint!.parent!.name} >> ${widget.checkPoint!.name}' : '${widget.checkPoint!.name}',
                    titleTextColor: Colors.white,
                  ),
                  new IconButton(
                    icon: new Icon(
                      Icons.help_outline,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showHelpScreen(context, "${widget.checkPoint!.name} Page Help", "checkpoint.md");
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
          visible: !widget.checkPoint!.expressMode!,
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
            visible: !widget.checkPoint!.expressMode!,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _childCheckPoints(rowList!, false),
          ),
        ),
      );

  Widget _allCards() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _topBannerCard(),
            widget.checkPoint!.hasChild ? _expressModeForm() : SizedBox.shrink(),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _checkPointCard(),
                  _checkPointAttributesCard(),
                  Visibility(
                    visible:
                    widget.checkPoint!.expressMode! || _surveyBloc!.checkSurveyCompleted(widget.checkPoint!.children!),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                      width: double.infinity,
                      child: MaterialButton(
                        padding: EdgeInsets.all(12.0),
                        shape: StadiumBorder(),
                        color: Colors.green,
                        onPressed: () {
                          if (widget.checkPoint!.status != CheckPointStatus.NotAvailable()) {
                            widget.checkPoint!.status = CheckPointStatus.Completed();
                          }
                          if(validateSubmit(_formKey, _scaffoldKey,  context)) {
                            _navigateToParent();
                          }
                        },
                        child: Text(
                          "Done with ${widget.checkPoint!.name}",
                          style: TextStyle(color: Colors.white),
                          textScaleFactor: 1.2,
                        ),
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
        visible: !widget.checkPoint!.expressMode!,
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
                      List<CheckPoint> chp = _surveyBloc!.findCheckPointByName(widget.survey!.checkPoints!,
                          List<CheckPoint>.empty(growable: true), wildCard!);
                      if (chp.isNotEmpty) {
                        if (chp.length > 1) {
                          showPopup(context, _checkPointsPopupBody(chp),
                              'Search Result');
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CheckPointPage.withSurvey(
                                          survey: widget.survey,
                                          checkPoint: chp[0],
                                          codes: widget.codes)));
                        }
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
                      onChanged: (un) => _surveyBloc?.searchString = un,
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
          bottomNavigationBar: feedbackBottomBar(context, callBackAction: () {  }),
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
    rowList = _surveyBloc?.convertListOfCheckPointsTo2dList(
        3, widget.checkPoint!.children!);
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
    if (widget.checkPoint!.images != null) {
      for (var i = 0; i < widget.checkPoint!.images!.length; i++) {
        rows.add(
          new Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
            child:  Dismissible(
                key: ObjectKey(widget.checkPoint!.images![i].imageGuid),
                child: Image.memory(widget.checkPoint!.images![i].content!),
                onDismissed: (direction) {
                  setState(() {
                    widget.checkPoint!.images!.removeAt(i);
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
    for (var i = 0; i < widget.checkPoint!.attributeValues!.length; i++) {
      rows.add(
        new Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            maxLines: null,
            initialValue: widget.checkPoint!.attributeValues![i].value,
            decoration: InputDecoration(
              labelText: widget
                  .checkPoint
                  !.attributeValues![i]
                  .inspectAreaAttribute
                  !.description,
              suffixIcon: Icon(Icons.short_text),
            ),
            onChanged: (un) => {
              widget.checkPoint!.attributeValues![i].value = un,
              widget.checkPoint!.status = CheckPointStatus.UnCompleted(),
            },
            onFieldSubmitted: (_) {
              widget.checkPoint!.status = CheckPointStatus.UnCompleted();
            },
          ),
        ),
      );
    }
    return rows;
  }

  List<Widget> _childCheckPoints(List<List<CheckPoint>> rowList, bool popup) {
    List<Widget> rows = List<Widget>.empty(growable: true);
    for (var i = 0; i < rowList.length; i++) {
      List<CheckPoint> checkPoints = rowList[i];
      List<Widget> columns = List<Widget>.empty(growable: true);
      for (var j = 0; j < checkPoints.length; j++) {
        columns.add(
          new SizedBox(
            height: deviceSize!.height / 10,
            width: deviceSize!.width / 3.4,
            child: new MaterialButton(
              padding: EdgeInsets.all(10.0),
              shape: StadiumBorder(),
              color: _surveyBloc?.checkPointStatusColor(checkPoints[j]),
              onPressed: () {
                checkPoints[j].parent = widget.checkPoint;
                if (popup) Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckPointPage.withSurvey(
                            survey: widget.survey,
                            checkPoint: checkPoints[j],
                            codes: widget.codes)));
              },
              child: Text(
                '${checkPoints[j].name}',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
              ),
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
    } else {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _childCheckPoints(
              _surveyBloc!.convertListOfCheckPointsTo2dList(2, chp), true),
        ),
      );
    }
  }

  Widget _takePhotoActionButton() {
    return Visibility(
        visible: true,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImagePickerPage.withSurveyImageContainer(
                    title: "Picture of \"${widget.checkPoint!.name}\"",
                    survey: widget.survey,
                    imageContainer: widget.checkPoint,
                    codes: widget.codes),
              ),
            );
          },
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          child: new Icon(
            Icons.add_a_photo,
            //color: Colors.blueGrey,
          ),
        ));
  }

  void _navigateToParent() {
    if (widget.checkPoint!.parent == null) {
      if(kIsWeb) _surveyBloc?.saveSurvey(SurveyViewModel.save(widget.survey!), apiType: ApiType.saveSurvey);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SurveyPage.Survey(
          surveyGuid: widget.checkPoint!.surveyGuid!,
          survey: widget.survey!,
          codes: widget.codes!)));
    } else {
      if(kIsWeb) _surveyBloc?.saveSurvey(SurveyViewModel.save(widget.survey!), apiType: ApiType.saveCheckPoint);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CheckPointPage.withSurvey(
                    survey: widget.survey,
                    checkPoint: widget.checkPoint!.parent,
                    codes: widget.codes,
                  )));
    }
  }

  Widget _expressModeForm() => Container (
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        const Text("Express Mode"),
        Checkbox(
          value: widget.checkPoint!.expressMode,
          onChanged: (value) {
             setState(() {
               widget.checkPoint!.expressMode = value;
             });
            _surveyBloc!.setCheckPointExpressRecursive(widget.checkPoint!);
          },
        )
      ],
    ),
  );
}
