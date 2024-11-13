import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/code_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/survey_bloc.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/ui/page/generic/image_picker_page.dart';
import 'package:surveymyboatpro/ui/page/survey/survey_page.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_scaffold.dart';

class VesselPage extends StatefulWidget {
  Survey survey;
  Map<String, List<DropdownMenuItem<String>>> codes;

  VesselPage.withSurvey(
      {Survey survey, Map<String, List<DropdownMenuItem<String>>> codes}) {
    this.survey = survey;
    this.codes = codes;
  }

  @override
  State<StatefulWidget> createState() {
    return VesselPageState(survey, codes);
  }
}

class VesselPageState extends State<VesselPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Survey survey;
  Map<String, List<DropdownMenuItem<String>>> codes;

  VesselPageState(this.survey, this.codes);

  static Size deviceSize;

  FocusNode _licenseNumberFocusNode = FocusNode();
  FocusNode _modelFocusNode = FocusNode();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _makeFocusNode = FocusNode();
  FocusNode _dateofManifactureFocusNode = FocusNode();
  FocusNode _vesselTypeFocusNode = FocusNode();
  FocusNode _modelYearFocusNode = FocusNode();
  FocusNode _hinFocusNode = FocusNode();
  FocusNode _hinLocationFocusNode = FocusNode();
  FocusNode _registryNoFocusNode = FocusNode();
  FocusNode _registryExpiresFocusNode = FocusNode();
  FocusNode _loaFocusNode = FocusNode();
  FocusNode _draftFocusNode = FocusNode();
  FocusNode _displacementFocusNode = FocusNode();
  FocusNode _beamFocusNode = FocusNode();
  FocusNode _ballastFocusNode = FocusNode();
  FocusNode _vesselDescriptionFocusNode = FocusNode();
  FocusNode _documentedUseFocusNode = FocusNode();
  FocusNode _homePortFocusNode = FocusNode();
  FocusNode _vesselBuilderFocusNode = FocusNode();
  FocusNode _vesselDesignerFocusNode = FocusNode();
  FocusNode _logoSrcFocusNode = FocusNode();
  FocusNode _imageSrcFocusNode = FocusNode();

  TextEditingController _vesselNameTextController;

  SurveyBloc _surveyBloc = new SurveyBloc();
  CodeBloc _codeBloc = new CodeBloc();
  StreamSubscription<FetchProcess> _apiStreamSubscription;

  Widget _vesselCard() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.0),
          child: Form(
            key: _formKey,
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
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: null,
                            focusNode: _nameFocusNode,
                            controller: _vesselNameTextController,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "Name",
                              suffixIcon: Icon(Icons.description),
                            ),
                            onChanged: (un) {
                              this.survey.vessel.name = un;
                              setState(() => _vesselNameTextController);
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              fieldFocusChange(
                                  context, _nameFocusNode, _makeFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Required field";
                              }
                              return null;
                            }
                          ),
                        ),
                        if (this.survey.vessel.vesselType != null)
                          Visibility(
                            visible: true,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 30.0),
                              child: DropdownButtonFormField<String>(
                                value: this
                                    ._codeBloc
                                    .getSelectedDropdownMenuItem(
                                        this.codes["vesselType"],
                                        this.survey.vessel.vesselType)
                                    .value,
                                items: this.codes["vesselType"],
                                focusNode: _vesselTypeFocusNode,
                                autofocus: true,
                                decoration: InputDecoration(
                                  labelText: "Vessel Type",
                                  //suffixIcon: Icon(Icons.short_text),
                                ),
                                onChanged: (un) {
                                  this.survey.vessel.vesselType.code =
                                      un;
                                },
                                validator: (value) {
                                    if (value.isEmpty) {
                                      return "Required field";
                                    }
                                    return null;
                                  }
                              ),
                            ),
                          ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue: this.survey.vessel.model,
                              focusNode: _modelFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Model",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.model = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context, _modelFocusNode,
                                    _modelYearFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              maxLines: null,
                              initialValue: this.survey.vessel.modelYear,
                              focusNode: _modelYearFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Model Year",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.modelYear = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context, _modelYearFocusNode,
                                    _dateofManifactureFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue:
                                  this.survey.vessel.dateofManifacture,
                              focusNode: _dateofManifactureFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Date of Manufacture",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.dateofManifacture =
                                    un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context,
                                    _dateofManifactureFocusNode,
                                    _licenseNumberFocusNode);
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
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue:
                                  this.survey.vessel.licenseNumber,
                              focusNode: _licenseNumberFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "License Number",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.licenseNumber = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context,
                                    _licenseNumberFocusNode, _hinFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue: this.survey.vessel.hin,
                              focusNode: _hinFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "HIN",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.hin = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context, _hinFocusNode,
                                    _hinLocationFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue:
                                  this.survey.vessel.hinLocation,
                              focusNode: _hinLocationFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "HIN Location",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.hinLocation = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context, _hinLocationFocusNode,
                                    _registryNoFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue:
                                  this.survey.vessel.registryNo,
                              focusNode: _registryNoFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Registry Number",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.registryNo = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context, _registryNoFocusNode,
                                    _registryExpiresFocusNode);
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
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue:
                                  this.survey.vessel.registryExpires,
                              focusNode: _registryExpiresFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Registry Expires",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.registryExpires = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context,
                                    _registryExpiresFocusNode, _loaFocusNode);
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
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue: this.survey.vessel.loa,
                              focusNode: _loaFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "LOA",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.loa = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context, _loaFocusNode, _draftFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue: this.survey.vessel.draft,
                              focusNode: _draftFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Draft",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.draft = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context, _draftFocusNode,
                                    _displacementFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue:
                                  this.survey.vessel.displacement,
                              focusNode: _displacementFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Displacement",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.displacement = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context,
                                    _displacementFocusNode, _beamFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue: this.survey.vessel.beam,
                              focusNode: _beamFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Beam",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.beam = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context, _beamFocusNode, _ballastFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue: this.survey.vessel.ballast,
                              focusNode: _ballastFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Ballast",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.ballast = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context, _ballastFocusNode,
                                    _vesselDescriptionFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue:
                                  this.survey.vessel.vesselDescription,
                              focusNode: _vesselDescriptionFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Description",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.vesselDescription =
                                    un;
                              },
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context,
                                    _vesselDescriptionFocusNode,
                                    _documentedUseFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue:
                                  this.survey.vessel.documentedUse,
                              focusNode: _documentedUseFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Documented Use",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.documentedUse = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context,
                                    _documentedUseFocusNode,
                                    _homePortFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue: this.survey.vessel.homePort,
                              focusNode: _homePortFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Home Port",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.homePort = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(context, _homePortFocusNode,
                                    _vesselBuilderFocusNode);
                              },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required field";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue:
                                  this.survey.vessel.vesselBuilder,
                              focusNode: _vesselBuilderFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Builder",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.vesselBuilder = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context,
                                    _vesselBuilderFocusNode,
                                    _vesselDesignerFocusNode);
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
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              initialValue:
                                  this.survey.vessel.vesselDesigner,
                              focusNode: _vesselDesignerFocusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: "Designer",
                                suffixIcon: Icon(Icons.description),
                              ),
                              onChanged: (un) {
                                this.survey.vessel.vesselDesigner = un;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                fieldFocusChange(
                                    context,
                                    _vesselDesignerFocusNode,
                                    _vesselDesignerFocusNode);
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
     ),
   );

  Widget _takePhotoActionButton() => Container(
    padding: EdgeInsets.symmetric(
        vertical: 5.0, horizontal: 30.0),
    width: double.infinity,
    child: RaisedButton(
      padding: EdgeInsets.all(12.0),
      shape: StadiumBorder(),
      child: Text(
        "Add a Photo",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.black,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImagePickerPage.withSurveyImageContainer(
                  title: "Picture of \"${this.survey.vessel.name}\"",
                  survey: this.survey,
                  imageContainer: this.survey.vessel,
                  codes: this.codes),
            ));
      },
    ),
  );

  // Widget _saveVesselButton() => Container(
  //   padding: EdgeInsets.symmetric(
  //       vertical: 5.0, horizontal: 30.0),
  //   width: double.infinity,
  //   child: RaisedButton(
  //     padding: EdgeInsets.all(12.0),
  //     shape: StadiumBorder(),
  //     child: Text(
  //       "Save Vessel",
  //       style: TextStyle(color: Colors.white),
  //     ),
  //     color: Colors.black,
  //     onPressed: () {
  //       if(_validateSubmit()) {
  //         _submitUpdateVessel();
  //       }
  //     },
  //   ),
  // );
  
  Widget _vesselImagesCard() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _vesselImages(),
        ),
      );

  Widget allCards() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Divider(),
            _vesselCard(),
            Divider(),
            //_saveVesselButton(),
            _takePhotoActionButton(),
            Divider(),
            _vesselImagesCard(),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
     { deviceSize = MediaQuery.of(context).size; }
    return new WillPopScope(
        onWillPop: _submitUpdateVessel,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CommonScaffold(
                scaffoldKey: _scaffoldKey,
                appTitle: 'Vessel "${this.survey.vessel.name == null ? "No Name" : this.survey.vessel.name}"',
                showDrawer: false,
                showFAB: false,
                showBottomNav: true,
                automaticallyImplyLeading: false,
                backGroundColor: Colors.white,
                bodyWidget: allCards(),
                actionThirdIcon: Icons.help_outline,
                thirdActionCallback: () {
                  showHelpScreen(context, "${this.survey.vessel.name == null ? "No Name" : this.survey.vessel.name} Page Help", "vessel.md");
                },
                // floatingIcon1: Icons.save_outlined,
                // floatAction1Callback: () {
                //   //_takePhotoActionButton();
                //   if(_validateSubmit()) {
                //     _submitUpdateVessel();
                //   }
                // },
              )
            ],
          ),
        ));
  }

  // void _takePhotoActionButton() {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ImagePickerPage.withSurveyImageContainer(
  //             title: "Picture of \"${this.survey.vessel.name}\"",
  //             survey: this.survey,
  //             imageContainer: this.survey.vessel,
  //             codes: this.codes),
  //       ));
  // }

  // Future<bool> _onBackPressed() {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => new AlertDialog(
  //       title: new Text('Are you sure?'),
  //       content: new Text('Unsaved data will be lost. Please save the vessel first.'),
  //       actions: <Widget>[
  //         new GestureDetector(
  //           onTap: () => Navigator.of(context).pop(false),
  //           child: Text(
  //               "Oops, my bad",
  //               textScaleFactor: 1.2,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //               )
  //           ),
  //         ),
  //         SizedBox(height: 45),
  //         new GestureDetector(
  //           onTap: () => _submitUpdateVessel(),
  //           child: Text(
  //               "Ignore",
  //               textScaleFactor: 1.2,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //               )
  //           ),
  //         ),
  //         SizedBox(width: 20),
  //       ],
  //     ),
  //   ) ??
  //       false;
  // }

  @override
  void initState() {
    super.initState();
    this._vesselNameTextController =
        TextEditingController(text: this.survey.vessel.name == null ? "No Name" : this.survey.vessel.name);
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    _surveyBloc?.dispose();
    _codeBloc?.dispose();
    _apiStreamSubscription?.cancel();
    super.dispose();
  }

  Future<bool> _submitUpdateVessel() {
    if(validateSubmit(_formKey, _scaffoldKey,  context)) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SurveyPage.Survey(
          surveyGuid: this.survey.surveyGuid,
          survey: this.survey,
          codes: this.codes)), (r) => true);
      return Future.value(true);
    }
    return Future.value(false);
  }

  List<Widget> _vesselImages() {
    List<Widget> rows = List<Widget>.empty(growable: true);
    if (this.survey.vessel.images != null) {
      for (var i = 0; i < this.survey.vessel.images.length; i++) {
        rows.add(
          new Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
            child:  Dismissible(
              key: ObjectKey(this.survey.vessel.images[i].imageGuid),
              child: Image.memory(this.survey.vessel.images[i].content),
                onDismissed: (direction) {
                  setState(() {
                    this.survey.vessel.images.removeAt(i);
                  });
                }),
            ),
        );
      }
    }
    return rows;
  }
}
