import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/code_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/survey_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/survey_view_model.dart';
import 'package:surveymyboatpro/model/checkpoint.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/ui/page/generic/analytics_page_state.dart';
import 'package:surveymyboatpro/ui/page/survey/checkpoint_page.dart';
import 'package:surveymyboatpro/ui/page/survey/preview_report_page.dart';
import 'package:surveymyboatpro/ui/page/survey/sea_trail_page.dart';
import 'package:surveymyboatpro/ui/page/survey/survey_page.dart';
import 'package:surveymyboatpro/ui/page/survey/surveys_page.dart';
import 'package:surveymyboatpro/ui/page/survey/vessel_page.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/client_detail_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_scaffold.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

abstract class SurveyPageStateBase<T> extends AnalyticsState<SurveyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _surveySiteTextFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _surveyDisclosureCommentTextFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _hinVerificationTextFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  Widget displayWidget = progressWithBackground();
  static Size? deviceSize;

  String? _surveyGuid;
  Survey? _survey;
  Map<String, List<DropdownMenuItem<String>>>? _codes;

  List<List<CheckPoint>>? _rowList;
  bool? _showPreview = false;
  bool? _wildCard = true;

  SurveyPageStateBase.withSurvey({
    String? surveyGuid,
    Survey? survey,
    Map<String, List<DropdownMenuItem<String>>>? codes
  }) {
    this._surveyGuid = surveyGuid;
    this._survey = survey;
    this._codes = codes;
  }

  FocusNode _surveyNumberFocusNode = FocusNode();
  FocusNode _surveyTitleFocusNode = FocusNode();
  FocusNode _surveySurveyTypeFocusNode = FocusNode();
  FocusNode _surveyStandardsUsedFocusNode = FocusNode();
  FocusNode _surveyDescriptionFocusNode = FocusNode();
  FocusNode _surveyDateOfInspectionFocusNode = FocusNode();
  FocusNode _surveyWeatherConditionFocusNode = FocusNode();
  FocusNode _surveyConductOfSurveyFocusNode = FocusNode();
  FocusNode _surveyPlaceOfSurveyFocusNode = FocusNode();
  FocusNode _surveySiteFocusNode = FocusNode();
  FocusNode _surveyScopeOfSurveyFocusNode = FocusNode();
  FocusNode _surveyPersonOfAttendFocusNode = FocusNode();
  FocusNode _surveyDefinitionOfTermsFocusNode = FocusNode();
  FocusNode _surveyHinVerificationFocusNode = FocusNode();
  FocusNode _surveyCommentsFocusNode = FocusNode();
  FocusNode _surveyRecommendationsFocusNode = FocusNode();
  FocusNode _surveyDisclosureCommentsFocusNode = FocusNode();
  FocusNode _surveyIssuesFocusNode = FocusNode();
  FocusNode _surveyImmediateIssuesFocusNode = FocusNode();
  FocusNode _surveyValuationFocusNode = FocusNode();
  FocusNode _surveySummaryFocusNode = FocusNode();
  FocusNode _surveyCertificationFocusNode = FocusNode();

  TextEditingController? _surveyNumberTextController;
  TextEditingController? _surveySiteTextController;
  TextEditingController? _disclosureCommentTextController;
  TextEditingController? _surveyHinVerificationTextController;
  TextEditingController? _surveyDateTextController;

  var _dateMaskFormatter = new MaskTextInputFormatter(
      mask: "####-##-##", filter: {"#": RegExp(r'[0-9]')});

  bool? _surveyLoad;
  bool? _codesLoad;

  SurveyBloc? _surveyBloc;
  CodeBloc? _codeBloc;
  StreamSubscription<FetchProcess>? _apiSurveyStreamSubscription;
  StreamSubscription<FetchProcess>? _apiCodesStreamSubscription;

  Widget surveyFormCard() => SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.0),
      child: new Column(
        children: <Widget>[
          new Row (
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Visibility(
                        visible: true,
                        child: _reportPreviewButton(),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        child: TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          focusNode: _surveyNumberFocusNode,
                          controller: _surveyNumberTextController,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "Survey Number",
                            suffixIcon: Icon(Icons.vpn_key),
                          ),
                          onChanged: (un) {
                            this._survey?.surveyNumber = un;
                            setState(() => _surveyNumberTextController);
                          },
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required field";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context,
                                _surveyNumberFocusNode,
                                _surveyTitleFocusNode);
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        child: TextFormField(
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          initialValue: this._survey?.title,
                          focusNode: _surveyTitleFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "Survey Title",
                            suffixIcon: Icon(Icons.title),
                          ),
                          onChanged: (un) => this._survey?.title = un,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required field";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            fieldFocusChange(context, _surveyTitleFocusNode,
                                _surveySurveyTypeFocusNode);
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        child: DropdownButtonFormField<String>(
                          value: this._codeBloc?.getSelectedDropdownMenuItem(
                              _codes!["surveyType"]!,
                              this._survey!.surveyType!
                          ).value,
                          items: _codes!["surveyType"],
                          focusNode: _surveySurveyTypeFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "Survey Type",
                            suffixIcon: Icon(Icons.short_text),
                          ),
                          onChanged: (un) =>
                          this._survey?.surveyType?.code = un,
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            focusNode: _surveyStandardsUsedFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Standards Used",
                              suffixIcon: Icon(Icons.text_fields),
                            ),
                            //onChanged: (un) => this._survey?.standardsUsed = un,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveyStandardsUsedFocusNode,
                                  _surveyDescriptionFocusNode);
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          initialValue: this._survey?.description,
                          focusNode: _surveyDescriptionFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "Description",
                            suffixIcon: Icon(Icons.description),
                          ),
                          onChanged: (un) => this._survey?.description = un,
                          textInputAction: TextInputAction.newline,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required field";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context,
                                _surveyDescriptionFocusNode,
                                _surveyDateOfInspectionFocusNode);
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        child: TextFormField(
                            maxLines: 1,
                            controller: _surveyDateTextController,
                            focusNode: _surveyDateOfInspectionFocusNode,
                            inputFormatters: [_dateMaskFormatter],
                            autofocus: true,
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              labelText: "Date of Inspection",
                              suffixIcon: Icon(Icons.date_range),
                            ),
                            onChanged: (un) {
                              this._survey?.dateOfInspection = un;
                              setState(() => _surveyDateTextController);
                            },
                            textInputAction: TextInputAction.next,
                            onTap: () {
                              selectDate(context, this._surveyDateTextController!);
                            },
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveyDateOfInspectionFocusNode,
                                  _surveyWeatherConditionFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required field";
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
                                    this._survey?.dateOfInspection = this._surveyDateTextController?.text;
                                    return null;
                                  }
                                }
                              }
                              return "Wrong date format (yyyy-mm-dd)";
                            }),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          initialValue: this._survey?.weatherCondition,
                          focusNode: _surveyWeatherConditionFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "Weather Condition",
                            suffixIcon: Icon(Icons.grain),
                          ),
                          onChanged: (un) =>
                          this._survey?.weatherCondition = un,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required field";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context,
                                _surveyWeatherConditionFocusNode,
                                _surveyConductOfSurveyFocusNode);
                          },
                        ),
                      ),
                      Visibility(
                        visible: _showPreview!,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: null,
                            initialValue: this._survey?.conductOfSurvey,
                            focusNode: _surveyConductOfSurveyFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Conduct of Survey",
                              suffixIcon: Icon(Icons.text_fields),
                            ),
                            onChanged: (un) =>
                            this._survey?.conductOfSurvey = un,
                            textInputAction: TextInputAction.newline,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required field";
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveyConductOfSurveyFocusNode,
                                  _surveyPlaceOfSurveyFocusNode);
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          initialValue: this._survey?.placeOfSurvey,
                          focusNode: _surveyPlaceOfSurveyFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "Place of Survey",
                            suffixIcon: Icon(Icons.place),
                          ),
                          onChanged: (un) =>
                          this._survey?.placeOfSurvey = un,
                          textInputAction: TextInputAction.newline,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required field";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context,
                                _surveyPlaceOfSurveyFocusNode,
                                _surveySiteFocusNode);
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          key: _surveySiteTextFieldKey,
                          controller: _surveySiteTextController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          //initialValue: this.survey.surveySite,
                          focusNode: _surveySiteFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "Site of Survey",
                            suffixIcon: Icon(Icons.add_to_queue),
                          ),
                          onTap: () {
                            if (this._survey?.surveySite != null &&
                                this._survey!.surveySite!.startsWith("*")) {
                              showPopup(
                                  context,
                                  _surveySitePopupBody(
                                      _surveySiteTextFieldKey
                                          .currentWidget!),
                                  "Please Select");
                            }
                          },
                          onChanged: (un) => this._survey?.surveySite = un,
                          textInputAction: TextInputAction.newline,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required field";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            fieldFocusChange(context, _surveySiteFocusNode,
                                _surveyScopeOfSurveyFocusNode);
                          },
                        ),
                      ),
                      Visibility(
                        visible: _showPreview!,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: null,
                            initialValue: this._survey?.scopeOfSurvey,
                            focusNode: _surveyScopeOfSurveyFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Scope of Survey",
                              suffixIcon: Icon(Icons.text_fields),
                            ),
                            onChanged: (un) =>
                            this._survey?.scopeOfSurvey = un,
                            textInputAction: TextInputAction.newline,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required field";
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveyScopeOfSurveyFocusNode,
                                  _surveyPersonOfAttendFocusNode);
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          initialValue: this._survey?.personsInAttend,
                          focusNode: _surveyPersonOfAttendFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "Person of attend",
                            suffixIcon: Icon(Icons.people),
                          ),
                          onChanged: (un) =>
                          this._survey?.personsInAttend = un,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required field";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context,
                                _surveyPersonOfAttendFocusNode,
                                _surveyDefinitionOfTermsFocusNode);
                          },
                        ),
                      ),
                      Visibility(
                        visible: _showPreview!,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            initialValue: this._survey?.definitionOfTerms,
                            focusNode: _surveyDefinitionOfTermsFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Definition of Terms",
                              suffixIcon: Icon(Icons.text_fields),
                            ),
                            onChanged: (un) =>
                            this._survey?.definitionOfTerms = un,
                            textInputAction: TextInputAction.newline,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required field";
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveyDefinitionOfTermsFocusNode,
                                  _surveyHinVerificationFocusNode);
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          key: _hinVerificationTextFieldKey,
                          controller:
                          this._surveyHinVerificationTextController,
                          maxLines: null,
                          //initialValue: this._survey?.hinVerification,
                          focusNode: _surveyHinVerificationFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: "HIN Verification",
                            suffixIcon: Icon(Icons.verified_user),
                          ),
                          onTap: () {
                            if (this._survey?.hinVerification != null &&
                                this
                                    ._survey
                                    !.hinVerification
                                    !.startsWith("*")) {
                              showPopup(
                                  context,
                                  _hinVerificationSitePopupBody(
                                      _hinVerificationTextFieldKey.currentWidget!),
                                  "Please Select");
                            }
                          },
                          onChanged: (un) =>
                          this._survey?.hinVerification = un,
                          textInputAction: TextInputAction.newline,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required field";
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context,
                                _surveyHinVerificationFocusNode,
                                _surveyCommentsFocusNode);
                          },
                        ),
                      ),
                      Visibility(
                        visible: _showPreview!,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            initialValue: this._survey?.comments,
                            focusNode: _surveyCommentsFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Comments",
                              suffixIcon: Icon(Icons.text_fields),
                            ),
                            onChanged: (un) => this._survey?.comments = un,
                            textInputAction: TextInputAction.newline,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required field";
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveyCommentsFocusNode,
                                  _surveyDisclosureCommentsFocusNode);
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _showPreview!,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: _disclosureCommentTextController,
                            focusNode: _surveyDisclosureCommentsFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Disclosure Comments",
                              suffixIcon: Icon(Icons.text_fields),
                            ),
                            onChanged: (un) => this._survey?.vesselDisclosureComments = un,
                            textInputAction: TextInputAction.newline,
                            onTap: () {
                              if (this._survey!.vesselDisclosureComments != null &&
                                  this._survey!.vesselDisclosureComments!.startsWith("*")) {
                                showPopup(
                                    context,
                                    _disclosureCommentPopupBody(
                                        _surveyDisclosureCommentTextFieldKey
                                            .currentWidget!),
                                    "Please Select");
                              }
                            },
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveyDisclosureCommentsFocusNode,
                                  _surveyRecommendationsFocusNode);
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _showPreview!,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            initialValue: this._survey?.recommendations,
                            focusNode: _surveyRecommendationsFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Recommendations",
                              suffixIcon: Icon(Icons.text_fields),
                            ),
                            onChanged: (un) => this._survey?.recommendations = un,
                            textInputAction: TextInputAction.newline,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required field";
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveyRecommendationsFocusNode,
                                  _surveyIssuesFocusNode);
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _showPreview!,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            initialValue: this._survey?.issues,
                            focusNode: _surveyIssuesFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Issues",
                              suffixIcon: Icon(Icons.error_outline),
                            ),
                            onChanged: (un) => this._survey?.issues = un,
                            textInputAction: TextInputAction.newline,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveyIssuesFocusNode,
                                  _surveyImmediateIssuesFocusNode);
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _showPreview!,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            initialValue: this._survey?.immediateIssues,
                            focusNode: _surveyImmediateIssuesFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Immediate Issues",
                              suffixIcon: Icon(Icons.error),
                            ),
                            onChanged: (un) =>
                            this._survey?.immediateIssues = un,
                            textInputAction: TextInputAction.newline,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveyImmediateIssuesFocusNode,
                                  _surveyValuationFocusNode);
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _showPreview!,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            initialValue: this._survey?.valuation,
                            focusNode: _surveyValuationFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Valuation",
                              suffixIcon: Icon(Icons.text_fields),
                            ),
                            onChanged: (un) => this._survey?.valuation = un,
                            textInputAction: TextInputAction.newline,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required field";
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveyValuationFocusNode,
                                  _surveySummaryFocusNode);
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _showPreview!,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            initialValue: this._survey?.summary,
                            focusNode: _surveySummaryFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Summary",
                              suffixIcon: Icon(Icons.text_fields),
                            ),
                            onChanged: (un) => this._survey?.summary = un,
                            textInputAction: TextInputAction.newline,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required field";
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context,
                                  _surveySummaryFocusNode,
                                  _surveyCertificationFocusNode);
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _showPreview!,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            initialValue: this._survey?.surveyCertification,
                            focusNode: _surveyCertificationFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Certification",
                              suffixIcon: Icon(Icons.text_fields),
                            ),
                            onChanged: (un) =>
                            this._survey?.surveyCertification = un,
                            textInputAction: TextInputAction.newline,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Required field";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _reportPreviewButton() => Container(
    padding: EdgeInsets.symmetric(
        vertical: 5.0, horizontal: 30.0),
    width: double.infinity,
    child: MaterialButton(
      padding: EdgeInsets.all(12.0),
      shape: StadiumBorder(),
      child: Text(
        "Report Preview",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.blueGrey,
      onLongPress: () {
        if(true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PreviewReportPage.Survey(_survey!, _codes!)));
        }
      },
      onPressed: () {
        if(true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PreviewReportPage.Survey(
                        _survey!, _codes!, generate: false,)));
        }
      },
    ),
  );

  Widget seaTrailCard() => new Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      new MaterialButton(
        padding: EdgeInsets.symmetric(
            vertical: 0.0, horizontal: deviceSize!.width / 2.5),
        shape: StadiumBorder(),
        child: Text(
          "Sea Trial",
          style: TextStyle(color: Colors.white),
          textScaleFactor: 1.2,
        ),
        color: _surveyBloc?.seaTrailStatusColor(this._survey!),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SeaTraillPage.withSurvey(survey: this._survey!, codes: this._codes!)));
        },
      ),
    ],
  );

  Widget searchCard() => Padding(
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
                List<CheckPoint>? chp = this
                    ._surveyBloc
                    ?.findCheckPointByName(this._survey!.checkPoints!,
                    List<CheckPoint>.empty(growable: true), _wildCard!);
                if (chp!.isNotEmpty) {
                  if (chp.length > 1)
                    showPopup(context, _checkPointsPopupBody(chp),
                        'Search Result');
                  else
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckPointPage.withSurvey(
                              survey: this._survey,
                              checkPoint: chp[0],
                              codes: _codes,
                            )));
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
                  onChanged: (un) {
                    this._surveyBloc?.searchString = un;
                  }),
            ),
          ],
        ),
      ),
    ),
  );

  Widget checkPointsCard() => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: checkPointsWidget(this._rowList!, false),
    ),
  );

  Widget allCards() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // Divider(),
          // saveSurveyButton(),
          Divider(),
          surveyFormCard(),
          Divider(),
          searchCard(),
          Divider(),
          checkPointsCard(),
          Divider(),
          seaTrailCard(),
          Divider(
            height: 60,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    { deviceSize = MediaQuery.of(context).size; }
    return displayWidget;
  }

  Widget _surveyScaffold() {
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CommonScaffold(
                scaffoldKey: _scaffoldKey,
                appTitle: "Survey ${this._survey?.surveyNumber}",
                showDrawer: this._survey?.inSync,
                showFAB: true,
                showBottomNav: true,
                automaticallyImplyLeading: false,
                actionFirstIcon: Icons.directions_boat_outlined,
                firstActionCallback: () {
                  _displayVesselPage();
                },
                actionSecondIcon: Icons.person_outline,
                secondActionCallback: () {
                  _displayClientPage();
                },
                actionThirdIcon: Icons.help_outline,
                thirdActionCallback: () {
                  showHelpScreen(context, "Survey Help", "survey.md");
                },
                backGroundColor: Colors.white,
                bodyWidget: allCards(),
                floatingIcon1: Icons.save_outlined,
                floatAction1Callback: () {
                  _navigateToParent();
                },
              )
            ],
          ),
        ));
  }

  Future<bool> _onBackPressed() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Unsaved data will be lost. Please save the survey first.'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text(
                "Oops, my bad",
                textScaleFactor: 1.2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )
            ),
          ),
          SizedBox(height: 45),
          new GestureDetector(
             onTap: () {
               _displaySurveysPage();
             },
            child: Text(
                "Ignore",
                textScaleFactor: 1.2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
    return Future.value(false);
  }

  void _displaySurveysPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SurveysPage()));
  }

  void _displayClientPage() {
    this._survey?.client!.editMode = false;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClientDetailPage.Survey(client: this._survey!.client!)));
  }

  void _displayVesselPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VesselPage.withSurvey(
                  survey: this._survey!,
                  codes: this._codes!,
                )));
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();

    _surveyLoad = _survey != null;
    _codesLoad = _codes != null;

    _surveyBloc = new SurveyBloc();
    _codeBloc = new CodeBloc();

    _apiSurveyStreamSubscription =
        apiCallSubscription(_surveyBloc!.apiResult, context, widget: widget);
    _apiCodesStreamSubscription =
        apiCallSubscription(_codeBloc!.apiResult, context, widget: widget);

    _loadSurvey();
    _loadCodes();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _gotoNextScreen() {
    if(_surveyLoad! & _codesLoad!) {
      setState(() => displayWidget = _surveyScaffold());
    }
  }

  void _loadSurvey() {
    if (this._survey == null) {
      SurveyViewModel _surveyViewModel =
      new SurveyViewModel.fetch(this._surveyGuid!);
      _surveyBloc?.getSurvey(_surveyViewModel);
      StreamSubscription surveySubscription = _surveyBloc!.survey.listen((data) {
        _initSurvey(data);
        setState(() => _surveyLoad = true);
        _gotoNextScreen();
      });
    } else {
      _initSurvey(this._survey!);
      setState(() => _surveyLoad = true);
      _gotoNextScreen();
    }
  }

  void _loadCodes() {
    if (this._codes == null) {
      _codeBloc?.loadDropdownCodes();
      _codeBloc?.dropdownCodes.listen((data) {
        _initCodes(data);
        setState(() => _codesLoad = true);
        _gotoNextScreen();
      });
    } else {
      _initCodes(this._codes!);
      setState(() => _codesLoad = true);
      _gotoNextScreen();
    }
  }

  void _initCodes(Map<String, List<DropdownMenuItem<String>>> _codes) {
    this._codes = _codes;
  }

  void _initSurvey(Survey data) {
    this._survey = data;
    this._rowList = _surveyBloc?.convertListOfCheckPointsTo2dList(
        3, this._survey!.checkPoints!);
    this._surveyNumberTextController =
        TextEditingController(text: this._survey?.surveyNumber);
    this._surveySiteTextController =
        TextEditingController(text: this._survey?.surveySite);
    this._surveyHinVerificationTextController =
        TextEditingController(text: this._survey?.hinVerification);
    this._surveyDateTextController =
        TextEditingController(text: this._survey?.dateOfInspection);
    this._disclosureCommentTextController =
        TextEditingController(text: this._survey?.vesselDisclosureComments);
    this._showPreview =
        _surveyBloc?.checkSurveyCompleted(this._survey!.checkPoints!);
  }

  @override
  void dispose() {
    _dateMaskFormatter.clear();
    _apiSurveyStreamSubscription?.cancel();
    _apiCodesStreamSubscription?.cancel();
    _surveyNumberTextController?.clear();
    _surveyDateTextController?.clear();
    _surveySiteTextController?.clear();
    _disclosureCommentTextController?.clear();
    _surveyHinVerificationTextController?.clear();
    _surveyBloc?.dispose();
    _codeBloc?.dispose();
    super.dispose();
  }

  List<Widget> checkPointsWidget(List<List<CheckPoint>> _rowList, bool _popup) {
    List<Widget> rows = List<Widget>.empty(growable: true);
    for (var i = 0; i < _rowList.length; i++) {
      List<CheckPoint> checkPoints = _rowList[i];
      List<Widget> columns = List<Widget>.empty(growable: true);
      for (var j = 0; j < checkPoints.length; j++) {
        columns.add(
          new SizedBox(
            height: deviceSize!.height / 10,
            width: deviceSize!.width / 3.4,
            child: new MaterialButton(
              padding: EdgeInsets.all(10.0),
              shape: StadiumBorder(),
              child: Text(
                checkPoints[j].name!,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
              ),
              color: _surveyBloc?.checkPointStatusColor(checkPoints[j]),
              onPressed: () {
                if (_popup) Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckPointPage.withSurvey(
                          survey: this._survey,
                          checkPoint: checkPoints[j],
                          codes: _codes,
                        )));
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
          height: 30.0,
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
          children: checkPointsWidget(
              _surveyBloc!.convertListOfCheckPointsTo2dList(2, chp), true),
        ),
      );
    }
  }

  Widget _surveySitePopupBody(Widget _widget) {
    List<String> choices = this._survey!.surveySite!.split("*");
    List<Widget> choiceItems = List.empty(growable: true);
    for (String str in choices) {
      if ("" != str)
        choiceItems.add(
          RadioListTile(
            groupValue: this._survey?.surveySite,
            title: Text(str),
            value: str,
            onChanged: (val) {
              setState(() {
                this._survey?.surveySite = val;
                this._surveySiteTextController?.text = val!;
              });
              Navigator.pop(context);
            },
          ),
        );
    }
    return SingleChildScrollView(
        child: Column(
          children: choiceItems.getRange(0, choiceItems.length).toList(),
        ));
  }

  Widget _hinVerificationSitePopupBody(Widget _widget) {
    List<String> choices = this._survey!.hinVerification!.split("*");
    List<Widget> choiceItems = List<Widget>.empty(growable: true);
    for (String str in choices) {
      if ("" != str)
        choiceItems.add(
          RadioListTile(
            groupValue: this._survey?.hinVerification,
            title: Text(str),
            value: str,
            onChanged: (val) {
              setState(() {
                this._survey?.hinVerification = val;
                this._surveyHinVerificationTextController!.text = val!;
              });
              Navigator.pop(context);
            },
          ),
        );
    }
    return SingleChildScrollView(
        child: Column(
          children: choiceItems.getRange(0, choiceItems.length).toList(),
        ));
  }

  Widget _disclosureCommentPopupBody(Widget _widget) {
    List<String> choices = this._survey!.vesselDisclosureComments!.split("*");
    List<Widget> choiceItems = List<Widget>.empty(growable: true);
    choiceItems.add(
      RadioListTile(
        groupValue: this._survey?.vesselDisclosureComments,
        title: Text("None Applicable"),
        value: "",
        onChanged: (val) {
          setState(() {
            this._survey?.vesselDisclosureComments = val;
            this._disclosureCommentTextController?.text = val!;
          });
          Navigator.pop(context);
        },
      ),
    );
    for (String str in choices) {
      if ("" != str)
        choiceItems.add(
          RadioListTile(
            groupValue: this._survey?.vesselDisclosureComments,
            title: Text(str),
            value: str,
            onChanged: (val) {
              setState(() {
                this._survey?.vesselDisclosureComments = val;
                this._disclosureCommentTextController?.text = val!;
              });
              Navigator.pop(context);
            },
          ),
        );
    }
    return SingleChildScrollView(
        child: Column(
          children: choiceItems.getRange(0, choiceItems.length).toList(),
        ));
  }

  void _navigateToParent() {
    if(validateSubmit(_formKey, _scaffoldKey,  context)) {
      _surveyBloc?.saveSurvey(SurveyViewModel.save(this._survey!), apiType: ApiType.saveSurveyAndHome);
    }
  }
}
