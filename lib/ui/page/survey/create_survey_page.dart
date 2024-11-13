import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/bloc/client_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/code_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/survey_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/vessel_catalog_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/survey_view_model.dart';
import 'package:surveymyboatpro/logic/viewmodel/vessel_catalog_view_model.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_type.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/model/vessel.dart';
import 'package:surveymyboatpro/model/vessel_catalog.dart';
import 'package:surveymyboatpro/model/vessel_catalog_list.dart';
import 'package:surveymyboatpro/model/vessel_type.dart';
import 'package:surveymyboatpro/ui/page/home_page.dart';
import 'package:surveymyboatpro/ui/page/login/identity_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_divider.dart';
import 'package:surveymyboatpro/ui/widgets/common_drawer.dart';
import 'package:surveymyboatpro/utils/uidata.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreateSurveyPage extends StatefulWidget {
  String title = "Start New Survey";
  Survey survey;
  bool clone = false;

  CreateSurveyPage({this.survey});

  CreateSurveyPage.Clone(this.survey, {this.title, this.clone = true});

  @override
  State<StatefulWidget> createState() {
    return CreateSurveyState(this.survey, this.title, this.clone);
  }
}

class CreateSurveyState extends State<CreateSurveyPage> {
  static Size deviceSize;
  String _title;
  Survey _survey;
  bool _clone = false;
  bool _showVesselSearch = true;

  static String _displayStringForOption(VesselCatalog option) => '${option.vesselDescription}';

  CreateSurveyState(Survey survey, String title, bool clone) {
    this._survey = survey;
    this._title = title;
    _clone = clone;
  }

  Widget displayWidget = progressWithBackground();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Surveyor _surveyor;
  SurveyViewModel _model;
  VesselCatalog _selectedVesselCatalog;
  Map<String, List<DropdownMenuItem<String>>> _codes;

  FocusNode _titleFocusNode = FocusNode();
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _identityVerifiedFocusNode = FocusNode();
  FocusNode _surveyTypeFocusNode = FocusNode();
  FocusNode _vesselTypeFocusNode = FocusNode();
  FocusNode _vesselFocusNode = FocusNode();
  FocusNode _submitFocusNode = FocusNode();
  FocusNode _currentFocusNode;

  CodeBloc _codeBloc;
  ClientBloc _clientBloc;
  SurveyBloc _surveyBloc;
  VesselCatalogBloc _vesselCatalogBloc;
  StreamSubscription<FetchProcess> _surveyStreamSubscription;

  TextEditingController _emailAddressTextController;
  TextEditingController _firstNameTextController;
  TextEditingController _lastNameTextController;
  TextEditingController _phoneNumberTextController;
  TextEditingController _addressTextController;
  TextEditingController _identityVerifiedTextController;

  var _phoneMaskFormatter = new MaskTextInputFormatter(
      mask: "(###) ###-####", filter: {"#": RegExp(r'[0-9]')});

  VesselCatalogViewModel _vesselCatalogViewModel;

  bool _catalogLoaded = false;

  Widget _clientWidget() => Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                maxLines: 1,
                focusNode: _emailFocusNode,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                  hintText: "Email Address",
                  suffixIcon: Icon(Icons.email),
                ),
                controller: _emailAddressTextController,
                onChanged: (un) {
                  this._survey.client.emailAddress = un.trim();
                },
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Email Address';
                  }
                },
                onFieldSubmitted: (value) {
                  _clientBloc.validateEmailAddress(value).then((client) {
                    _updateSurveyClient(client);
                  });
                  fieldFocusChange(context, _emailFocusNode, _firstNameFocusNode);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                focusNode: _firstNameFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "First Name",
                  suffixIcon: Icon(Icons.person),
                ),
                controller: _firstNameTextController,
                onChanged: (un) => this._survey.client.firstName = un.trim(),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter First Name';
                  }
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _firstNameFocusNode, _lastNameFocusNode);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                focusNode: _lastNameFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Last Name",
                  suffixIcon: Icon(Icons.person),
                ),
                controller: _lastNameTextController,
                onChanged: (un) => this._survey.client.lastName = un.trim(),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Last Name';
                  }
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _lastNameFocusNode, _phoneFocusNode);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                maxLines: 1,
                focusNode: _phoneFocusNode,
                inputFormatters: [_phoneMaskFormatter],
                autofocus: true,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  suffixIcon: Icon(Icons.phone),
                ),
                controller: _phoneNumberTextController,
                onChanged: (un) => this._survey.client.phoneNumber = un.trim(),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Phone Number';
                  }
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(context, _phoneFocusNode, _addressFocusNode);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                focusNode: _addressFocusNode,
                autofocus: true,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: "Address",
                  suffixIcon: Icon(Icons.location_city),
                ),
                controller: _addressTextController,
                onChanged: (un) => this._survey.client.addressLine = un.trim(),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Address';
                  }
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _addressFocusNode, _identityVerifiedFocusNode);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                focusNode: _identityVerifiedFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Identity Verified By",
                  suffixIcon: Icon(Icons.location_city),
                ),
                controller: _identityVerifiedTextController,
                onChanged: (un) => this._survey.client.identityVerifiedBy = un.trim(),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter identity verification';
                  }
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _identityVerifiedFocusNode, _vesselFocusNode);
                },
              ),
            ]),
      );

  Widget _surveyTypeWidget() => Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        child: DropdownButtonFormField<String>(
            value: this
                ._codeBloc
                .getSelectedDropdownMenuItem(
                    _codes["surveyType"], this._survey.surveyType)
                .value,
            items: _codes["surveyType"],
            focusNode: _surveyTypeFocusNode,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Survey Type",
              suffixIcon: Icon(Icons.short_text),
            ),
            onChanged: (un) {
              this._survey.surveyType.code = un;
              fieldFocusChange(
                  context, _surveyTypeFocusNode, _vesselTypeFocusNode);
            }),
      );

  Widget _vesselTypeWidget() => Container(
    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
    child: DropdownButtonFormField<String>(
        value: this
            ._codeBloc
            .getSelectedDropdownMenuItem(
            _codes["vesselType"], this._survey.vessel.vesselType)
            .value,
        items: _codes["vesselType"],
        focusNode: _vesselTypeFocusNode,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Vessel Type",
          suffixIcon: Icon(Icons.short_text),
        ),
        onChanged: (un) {
          this._survey.vessel.vesselType.code = un;
          _hideVesselSearchWidget(un);
          fieldFocusChange(
              context, _vesselTypeFocusNode, _submitFocusNode);
        }),
  );

  void _hideVesselSearchWidget(String un) {
    setState(() {
      this._showVesselSearch = (un == "SAILBOAT");
      displayWidget = _newSurveyScaffold();
    });
    if(un == "POWERBOAT") {
      this._selectedVesselCatalog = null;
      this._survey.vessel.vesselGuid = null;
    }
  }

  Widget _submitButtonWidget() => Visibility(
        visible: true,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(12.0),
            shape: StadiumBorder(),
            focusNode: _submitFocusNode,
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blueGrey,
            onPressed: () {
              if (validateSubmit(_formKey, _scaffoldKey,  context)) {
                _submitCreateSurvey();
              }
            },
          ),
        ),
      );

  Widget _vesselWidget() {
    List<VesselCatalog> vesselCatalogList = List.empty(growable: true);
    VesselCatalog vesselCatalog = VesselCatalog.fromVessel(this._survey.vessel);
    vesselCatalogList.add(vesselCatalog);
    Widget _vesselCatalogWidget = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _vesselCatalogBody(vesselCatalogList),
      ],
    );
    return _vesselCatalogWidget;
  }

  Widget _vesselCatalogWidget() {
    // if (this._selectedVesselCatalog != null) {
    //   _vesselCatalogViewModel.modelName =
    //       this._selectedVesselCatalog.vesselDescription;
    // }
    _vesselCatalogBloc.getVesselCatalog(_vesselCatalogViewModel);
    Widget _vesselCatalogWidget = StreamBuilder<VesselCatalogList>(
        stream: _vesselCatalogBloc.vesselCatalogController.stream,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            _catalogLoaded = true;
            return Column(
              key: ValueKey<Object>(this._showVesselSearch),
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //_vesselCatalogSearchCard(),
                //_vesselCatalogBody(snapshot.data.elements),
                _vesselCatalogCard(this._selectedVesselCatalog),
                _vesselCataloghAutoCompleteCard(snapshot.data.elements),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        });
    return _vesselCatalogWidget;
  }

  Widget _sectionHeaderColumn(String text) => Text(
        text,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      );

  Widget _createSurveyFields(
      Map<String, List<DropdownMenuItem<String>>> _codes) {
    this._codes = _codes;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CommonDivider(),
                _sectionHeaderColumn("Survey Type"),
                _surveyTypeWidget(),
                CommonDivider(),
                _sectionHeaderColumn("Vessel Type"),
                _vesselTypeWidget(),
                CommonDivider(),
                _vesselSelectWidget(),
                CommonDivider(),
                _sectionHeaderColumn("Client"),
                _clientWidget(),
                CommonDivider(),
                _submitButtonWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vesselSelectWidget() {
    return Visibility(
      maintainState: true,
      visible: this._showVesselSearch && this._catalogLoaded,
      child: Column (
          children: <Widget>[
            _sectionHeaderColumn(_survey.vessel.vesselType.code == 'SAILBOAT' ? "Sailboat Model" : "Powerboat Model"),
            CommonDivider(),
            _survey.vessel.vesselGuid == null ? _vesselCatalogWidget() : _vesselWidget(),
          ]
      ),
    );
  }

  Widget bodyData() {
    _codeBloc = new CodeBloc();
    _codeBloc.loadDropdownCodes();
    return StreamBuilder<Map<String, List<DropdownMenuItem<String>>>>(
        stream: _codeBloc.dropdownCodes,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _createSurveyFields(snapshot.data)
              : SizedBox.shrink();
        });
  }

  Widget _newSurveyScaffold() => Scaffold(
        key: _scaffoldKey,
        drawer: CommonDrawer(),
        appBar: AppBar(
          title: Text(_title),
          // leading: new Builder(builder: (context) {
          //   return IconButton(
          //     icon: Icon(Icons.arrow_back),
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
          //     },
          //   );
          // }),
        ),
        body: bodyData(),
        bottomNavigationBar: feedbackBottomBar(context),
      );

  //Vessel Catalog Widgets
  // Widget _vesselCatalogSearchCard() => Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Expanded(
  //             child: TextFormField(
  //                 textCapitalization: TextCapitalization.sentences,
  //                 decoration: InputDecoration(
  //                     border: InputBorder.none,
  //                     focusedBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //                         borderSide: BorderSide(color: Colors.white)),
  //                     filled: true,
  //                     hintText: "Find Vessel"),
  //                 onChanged: (un) {
  //                   _vesselCatalogViewModel.modelName = un;
  //                 },
  //                 autofocus: true,
  //                 focusNode: _vesselFocusNode,
  //                 validator: (name) {
  //                   if(name != null && name.length < 3) {
  //                     return "Please add more info";
  //                   }
  //                   return null;
  //                 }),
  //           ),
  //           new IconButton(
  //             icon: new Icon(Icons.search),
  //             onPressed: () {
  //               if(_vesselCatalogViewModel.modelName != null
  //                   && _vesselCatalogViewModel.modelName.length > 3) {
  //                 FocusScope.of(context).unfocus();
  //                 this._selectedVesselCatalog = null;
  //                 this._survey.vessel.vesselGuid = null;
  //               }
  //             },
  //           ),
  //         ],
  //       ),
  //     );

  Widget _vesselCataloghAutoCompleteCard(List<VesselCatalog> vesselCatalogs) => Visibility(
      visible: this._selectedVesselCatalog == null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        child: Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Autocomplete<VesselCatalog>(
                displayStringForOption: _displayStringForOption,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<VesselCatalog>.empty();
                  }
                  return vesselCatalogs.where((VesselCatalog option) {
                    return option.vesselDescription.toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (VesselCatalog selection) {
                  print('You just selected ${_displayStringForOption(selection)}');
                  setState(() => this._selectedVesselCatalog = selection );
                  FocusScope.of(context).unfocus();
                  if(!this._clone) {
                    this._survey.vessel =
                        Vessel.fromVesselCatalog(_selectedVesselCatalog);
                  }
                  _displayVesselSelection();
                },
              ),
            ),
          ],
        ),
      ),
  );

  Widget _vesselCatalogBody(List<VesselCatalog> vesselCatalogs) {
    if (vesselCatalogs.length == 1) {
      this._selectedVesselCatalog = vesselCatalogs[0];
      if(!this._clone) {
        this._survey.vessel =
            Vessel.fromVesselCatalog(this._selectedVesselCatalog);
      }
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
      child: vesselCatalogs.length > 0 ? ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: vesselCatalogs.length,
        itemBuilder: (context, i) => _vesselCatalogCard(vesselCatalogs[i]),
      ) : dataNotFoundWidget("Vessel spec not found"),
    );
  }

  Widget _vesselCatalogCard(VesselCatalog vesselCatalog) {
    if(vesselCatalog == null) {
      return SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.only(left: 20.0,right: 20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(width: 1.0, color: Colors.black12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 0.0,
              offset: Offset(1.0, 1.0),
            ),
          ]),
      child: Stack(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: new RichText(
          //     text: new TextSpan(
          //       children: [
          //         new TextSpan(
          //           text: 'Select the Vessel',
          //           style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
          //           recognizer: new TapGestureRecognizer()
          //             ..onTap = () {
          //               this._selectedVesselCatalog = vesselCatalog;
          //               if(!this._clone) {
          //                 this._survey.vessel =
          //                     Vessel.fromVesselCatalog(vesselCatalog);
          //               }
          //               _displayVesselSelection();
          //             },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // vesselCatalog.imageSrc != null
          //     ? Image.network(
          //         vesselCatalog.imageSrc,
          //         fit: BoxFit.cover,
          //       )
          //     : vesselCatalog.image != null
          //     ? Image.memory(vesselCatalog.image.content)
          //     : Container(),
          // vesselCatalog.imageSrc != null ? Container() : CommonDivider(),
          _vesselCatalogColumn(vesselCatalog),
          //_vesselCatalogLoaColumn(vesselCatalog),
          // _vesselCatalogDispColumn(vesselCatalog),
          // _vesselCatalogDesignerColumn(vesselCatalog),
          // _vesselCatalogBuilderColumn(vesselCatalog),
          Align(
            alignment: Alignment(1.05, -1.05),
            child: InkWell(
              onTap: () {
                this._selectedVesselCatalog = null;
                _displayVesselSelection();
              },
              child: Container(
                width: 40.0,
                height: 40.0,
                child: Icon(Icons.close, color: Colors.blueGrey, size: 40,),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black,offset: Offset(0, 1), blurRadius: 2),
                    ],
                    shape: BoxShape.circle,
                    color: Colors.white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vesselCatalogDispColumn(VesselCatalog vesselCatalog) => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Disp: ${vesselCatalog.getDisp()}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                ),
                SizedBox(width: 20),
                Text(
                  'Ballast: ${vesselCatalog.getBallast()}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _vesselCatalogDesignerColumn(VesselCatalog vesselCatalog) => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Designer: ${vesselCatalog.vesselDesigner}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _vesselCatalogBuilderColumn(VesselCatalog vesselCatalog) => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Builder: ${vesselCatalog.getBuilder()}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                )
              ],
            ),
          ],
        ),
      );

//column last
  Widget _vesselCatalogLoaColumn(VesselCatalog vesselCatalog) => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'LOA: ${vesselCatalog.getLoa()}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                ),
                SizedBox(width: 20),
                Text(
                  'Beam: ${vesselCatalog.getBeam()}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _vesselCatalogColumn(VesselCatalog vesselCatalog) => Row (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // CircleAvatar(
          //   backgroundImage: vesselCatalog.logoSrc != null ?
          //     NetworkImage(vesselCatalog.logoSrc) :
          //     vesselCatalog.image != null ?
          //     Image.memory(vesselCatalog.image.content).image
          //     : null,
          // ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      vesselCatalog.getVesselDescription(),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .apply(fontWeightDelta: 700, color: Colors.blueGrey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${vesselCatalog.getHullType()}, ${vesselCatalog.getRiggingType()}',
                      style: Theme.of(context).textTheme.caption.apply(
                          fontFamily: UIData.quickBoldFont, color: Colors.brown),
                    ),
                    SizedBox(height: 10),
                    _vesselCatalogLoaColumn(vesselCatalog),
                    _vesselCatalogDispColumn(vesselCatalog),
                    _vesselCatalogDesignerColumn(vesselCatalog),
                    _vesselCatalogBuilderColumn(vesselCatalog),
                  ],
                ),
              ),
          )
        ],
      );

  @override
  initState() {
    super.initState();
    _codeBloc = new CodeBloc();
    _clientBloc = new ClientBloc();
    _surveyBloc = new SurveyBloc();
    _vesselCatalogBloc = new VesselCatalogBloc();
    _currentFocusNode = _titleFocusNode;
    if(_survey == null) {
      _survey = new Survey(surveyType: SurveyType.OwnerMaint(),
          client: new Client(),
          vessel: new Vessel(vesselType: VesselType.Powerboat())
      );
    }
    _vesselCatalogViewModel = VesselCatalogViewModel.search();
    _surveyStreamSubscription =
        apiCallSubscription(_surveyBloc.apiResult, context, widget: widget);
    _model = new SurveyViewModel.create(this._survey);
    _model.clone = this._clone;
    this._emailAddressTextController =
        TextEditingController(text: this._survey.client.emailAddress);
    this._firstNameTextController =
        TextEditingController(text: this._survey.client.firstName);
    this._lastNameTextController =
        TextEditingController(text: this._survey.client.lastName);
    this._phoneNumberTextController =
        TextEditingController(text: this._survey.client.phoneNumber);
    this._addressTextController =
        TextEditingController(text: this._survey.client.addressLine);
    this._identityVerifiedTextController =
        TextEditingController(text: this._survey.client.identityVerifiedBy);

    _gotoNextScreen();
  }

  @override
  dispose() {
    _codeBloc?.dispose();
    _clientBloc.dispose();
    _surveyBloc?.dispose();
    _vesselCatalogBloc?.dispose();
    _surveyStreamSubscription?.cancel();
    _phoneMaskFormatter?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     { deviceSize = MediaQuery.of(context).size; }
    _model.flavor.then((flavor) {
      switch(flavor) {
        case Flavor.LOCAL:
          notConnectedDialog(context);
          break;
        default:
          null;
      }
    });
    return new WillPopScope(onWillPop: _homePage, child: displayWidget);
  }

  Future<bool> _homePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    return new Future.value(true);
  }

  void _gotoNextScreen() {
    if (this._surveyor == null) {
      StorageBloc _localStorageBloc = new StorageBloc();
      _localStorageBloc.loadSurveyor().then((_surveyor) {
        if (_surveyor != null) {
          this._surveyor = _surveyor;
          this._survey.surveyor = this._surveyor;
          setState(() => displayWidget = _newSurveyScaffold());
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IdentityPage()));
        }
      });
      _localStorageBloc.dispose();
    } else {
      this._survey.surveyor = this._surveyor;
      setState(() => displayWidget = _newSurveyScaffold());
    }

  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    _currentFocusNode = nextFocus;
    FocusScope.of(context).requestFocus(_currentFocusNode);
  }

  _updateSurveyClient(Client client) {
    if(client != null) {
      this._survey.client = client;
      this._emailAddressTextController.text = this._survey.client.emailAddress;
      this._firstNameTextController.text = this._survey.client.firstName;
      this._lastNameTextController.text = this._survey.client.lastName;
      this._phoneNumberTextController.text = this._survey.client.phoneNumber;
      this._addressTextController.text = this._survey.client.addressLine;
      this._identityVerifiedTextController.text = this._survey.client.identityVerifiedBy;
      setState(() => _clientWidget());
    }
  }

  _displayVesselSelection() {
    setState(() => _vesselCatalogWidget());
  }

  _submitCreateSurvey() {
    FocusScope.of(context).unfocus();
    _surveyBloc.createSurvey(_model);
  }
}
