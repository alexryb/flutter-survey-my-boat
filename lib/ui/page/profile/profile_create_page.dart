import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/bloc/code_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/signup_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/user_signup_view_model.dart';
import 'package:surveymyboatpro/model/code.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/model/settings.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/model/surveyor_certificate.dart';
import 'package:surveymyboatpro/model/surveyor_organization.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class ProfileCreatePage extends StatefulWidget {
  Login login;
  Surveyor surveyor;

  ProfileCreatePage.withLogin(Login login) {
    this.login = login;
    this.surveyor = new Surveyor();
    this.surveyor.title = "Accredited Marine Surveyor";
    this.surveyor.organization = new SurveyorOrganization();
    this.surveyor.certifications = List.empty(growable: true);
  }

  @override
  State<StatefulWidget> createState() {
    return ProfileCreatePageState();
  }
}

class ProfileCreatePageState extends State<ProfileCreatePage> {
  static Size deviceSize;
  bool _isOrg = false;
  bool _isToggle = false;
  String _isOrgLabel;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Settings _settings;

  Widget displayWidget = progressWithBackground();

  FocusNode _titleFocusNode = FocusNode();
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _orgBnFocusNode = FocusNode();
  FocusNode _orgNameFocusNode = FocusNode();
  FocusNode _orgEmailFocusNode = FocusNode();
  FocusNode _orgPhoneFocusNode = FocusNode();
  FocusNode _orgAddressFocusNode = FocusNode();
  FocusNode _submitFocusNode = FocusNode();
  FocusNode _currentFocusNode;

  SignUpBloc _signUpBloc;
  StreamSubscription<FetchProcess> _apiStreamSubscription;

  var _phoneMaskFormatter = new MaskTextInputFormatter(
      mask: "(###) ###-####", filter: {"#": RegExp(r'[0-9]')});

  Widget _personalInfoColumn() => Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Personal Info",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                focusNode: _titleFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Title",
                  suffixIcon: Icon(Icons.person),
                ),
                initialValue: this.widget.surveyor.title,
                onChanged: (un) => this.widget.surveyor.title = un,
                textInputAction: TextInputAction.next,
                validator: (value) {
                    if (value.isEmpty) {
                      return "Required field";
                    }
                    return null;
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _titleFocusNode, _firstNameFocusNode);
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
                initialValue: this.widget.surveyor.firstName,
                onChanged: (un) => this.widget.surveyor.firstName = un,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Required field";
                  }
                  return null;
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
                initialValue: this.widget.surveyor.lastName,
                onChanged: (un) => this.widget.surveyor.lastName = un,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Required field";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(context, _lastNameFocusNode,
                      _isOrg ? _orgBnFocusNode : _emailFocusNode);
                },
              ),
            ]),
      );

  Widget _certificationsColumn() {
    CodeBloc _codeBloc = new CodeBloc();
    _codeBloc.loadCheckboxCodes();
    return StreamBuilder<Map<String, List<Code>>>(
        stream: _codeBloc.checkboxCodes,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _certificationsWidget(snapshot.data)
              : SizedBox.shrink();
        });
  }

  Widget _certificationsWidget(Map<String, List<Code>> _codes) {
    List<Code> _datasource = _codes["surveyorCertificate"];
    dynamic _selectedCertificates = this.widget.surveyor.certifications;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Certifications",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            SizedBox(
              height: 10.0,
            ),
            MultiSelectFormField(
              autovalidate: false,
              title: Text("Please select certifications "),
              dataSource: _datasource.map((v) => v.toJson()).toList(),
              textField: 'description',
              valueField: 'code',
              okButtonLabel: 'OK',
              cancelButtonLabel: 'CANCEL',
              border: InputBorder.none,
              onSaved: (value) {
                fieldFocusChange(context, _currentFocusNode, _submitFocusNode);
                if (value == null) return;
                setState(() {
                  _selectedCertificates = value;
                  _populateCertificates(_selectedCertificates, _datasource);
                });
              },
            ),
          ]),
    );
  }

  Widget _contactInfoColumn() => Container(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Contact Info",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                focusNode: _emailFocusNode,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email Address",
                  suffixIcon: Icon(Icons.email),
                ),
                initialValue: this.widget.surveyor.emailAddress,
                onChanged: (un) => this.widget.surveyor.emailAddress = un.trim(),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (!_isOrg && value.isEmpty) {
                    return "Required field";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(context, _emailFocusNode, _phoneFocusNode);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                focusNode: _phoneFocusNode,
                inputFormatters: [_phoneMaskFormatter],
                keyboardType: TextInputType.phone,
                autovalidate: true,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  suffixIcon: Icon(Icons.phone),
                ),
                initialValue: this.widget.surveyor.phoneNumber,
                onChanged: (un) => this.widget.surveyor.phoneNumber = un.trim(),
                textInputAction: TextInputAction.newline,
                validator: (value) {
                  if (!_isOrg && value.isEmpty) {
                    return "Required field";
                  }
                  return null;
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
                decoration: InputDecoration(
                  hintText: "Address",
                  suffixIcon: Icon(Icons.location_city),
                ),
                initialValue: this.widget.surveyor.addressLine,
                onChanged: (un) => this.widget.surveyor.addressLine = un.trim(),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (!_isOrg && value.isEmpty) {
                    return "Required field";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _addressFocusNode, _submitFocusNode);
                },
              ),
            ]),
      );

  Widget _orgColumn() => Container(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Company",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                focusNode: _orgBnFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Business Number (Optional)",
                  suffixIcon: Icon(Icons.business),
                ),
                initialValue: this.widget.surveyor.organization.businessNumber,
                onChanged: (un) =>
                    this.widget.surveyor.organization.businessNumber = un.trim(),
                textInputAction: TextInputAction.next,
                // validator: (value) {
                //   if (_isOrg && value.isEmpty) {
                //     return "Required field";
                //   }
                //   return null;
                // },
                onFieldSubmitted: (_) {
                  fieldFocusChange(context, _orgBnFocusNode, _orgNameFocusNode);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                focusNode: _orgNameFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Company Name",
                  suffixIcon: Icon(Icons.business),
                ),
                initialValue: this.widget.surveyor.organization.name,
                onChanged: (un) => this.widget.surveyor.organization.name = un.trim(),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (_isOrg && value.isEmpty) {
                    return "Required field";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _orgNameFocusNode, _orgEmailFocusNode);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                focusNode: _orgEmailFocusNode,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Business Email",
                  suffixIcon: Icon(Icons.email),
                ),
                initialValue: this.widget.surveyor.organization.emailAddress,
                onChanged: (un) {
                  this.widget.surveyor.organization.emailAddress = un.trim();
                },
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (_isOrg && value.isEmpty) {
                    return "Required field";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _orgEmailFocusNode, _orgPhoneFocusNode);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                inputFormatters: [_phoneMaskFormatter],
                keyboardType: TextInputType.phone,
                focusNode: _orgPhoneFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Business Phone",
                  suffixIcon: Icon(Icons.phone),
                ),
                initialValue: this.widget.surveyor.organization.phoneNumber,
                onChanged: (un) {
                  this.widget.surveyor.organization.phoneNumber = un.trim();
                },
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (_isOrg && value.isEmpty) {
                    return "Required field";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _orgPhoneFocusNode, _orgAddressFocusNode);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                focusNode: _orgAddressFocusNode,
                autofocus: true,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: "Mail Address",
                  suffixIcon: Icon(Icons.location_city),
                ),
                initialValue: this.widget.surveyor.organization.addressLine,
                onChanged: (un) {
                  this.widget.surveyor.organization.addressLine = un.trim();
                },
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (_isOrg && value.isEmpty) {
                    return "Required field";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _orgPhoneFocusNode, _submitFocusNode);
                },
              ),
            ]),
      );

  Widget _submitColumn() => Container(
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
              _submitCreateProfile();
            }
          },
        ),
      );

  Widget _orgSelectButtons() => new Container(
        margin: EdgeInsets.all(10),
        child: new Center(
          child: new Column(
            children: <Widget>[
              Align(
                alignment: !_isToggle ? Alignment.center : Alignment.topCenter,
                child: new Column(children: [
                  Visibility(
                    visible: !_isToggle,
                    child: SizedBox(
                      height: _settings.deviceSize.height * 0.25,
                    ),
                  ),
                  Visibility(
                    visible: !_isOrg || !_isToggle,
                    child: ButtonTheme(
                      minWidth: 300.0,
                      height: 50.0,
                      child: RaisedButton(
                        padding: EdgeInsets.all(12.0),
                        shape: StadiumBorder(),
                        child: Text(
                          "I'm an Individual",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          widget.surveyor.organization = null;
                          bool value = !_isToggle ? false : true;
                          _toggleSwitch(value);
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_isToggle,
                    child: SizedBox(
                      height: _settings.deviceSize.height * 0.1,
                    ),
                  ),
                  Visibility(
                    visible: _isOrg || !_isToggle,
                    child: ButtonTheme(
                      minWidth: 300.0,
                      height: 50.0,
                      child: RaisedButton(
                        padding: EdgeInsets.all(12.0),
                        shape: StadiumBorder(),
                        child: Text(
                          "Company",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          bool value = !_isToggle ? true : false;
                          _toggleSwitch(value);
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      );

  _createProfileFields() => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _orgSelectButtons(),
            Visibility(
                visible: _isToggle,
                child: Column(children: <Widget>[
                  _personalInfoColumn(),
                  if (!_isOrg) _contactInfoColumn(),
                  if (_isOrg) _orgColumn(),
                  _certificationsColumn(),
                  _submitColumn(),
                ])),
          ],
        ),
      );

  Widget bodyData() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _createProfileFields(),
        ],
      ),
    );
  }

  Widget _profileScaffold() => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Create Surveyor Profile'),
        ),
        body: bodyData(),
      );

  @override
  initState() {
    super.initState();
    _settings = Injector.SETTINGS;
    _signUpBloc = new SignUpBloc();
    _apiStreamSubscription =
        apiCallSubscription(_signUpBloc.apiResult, context, widget: widget);
    _currentFocusNode = _titleFocusNode;
  }

  @override
  void dispose() {
    _signUpBloc?.dispose();
    _apiStreamSubscription?.cancel();
    _phoneMaskFormatter.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     { deviceSize = _settings.deviceSize; }
    return new WillPopScope(onWillPop: () async => true, child: _profileScaffold());
  }

  void _toggleSwitch(bool value) {
    _isToggle = true;
    if (value == true) {
      _isOrg = value;
      _isOrgLabel = "Company";
      widget.surveyor.organization = SurveyorOrganization();
    } else {
      _isOrg = value;
      _isOrgLabel = "I'm an Individual";
      widget.surveyor.organization = null;
    }
    setState(() => displayWidget);
  }

  void _populateCertificates(var selectedCertificates, List<Code> codes) {
    String formattedDate = new DateTime.now().toString().substring(0, 10);
    for (String _value in selectedCertificates) {
      for (Code _code in codes) {
        if (_code.code == _value) {
          SurveyorCertificate cert = new SurveyorCertificate();
          cert.surveyorGuid = this.widget.surveyor.surveyorGuid;
          cert.code = _value;
          cert.description = _code.description;
          cert.certificateNumber = cert.code + "#";
          cert.createDate = formattedDate;
          cert.createdBy = "IMB-APP";
          cert.updateDate = formattedDate;
          cert.updatedBy = "IMB-APP";
          this.widget.surveyor.certifications.add(cert);
        }
      }
    }
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    _currentFocusNode = nextFocus;
    FocusScope.of(context).requestFocus(_currentFocusNode);
  }

  void _submitCreateProfile() {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      _signUpBloc.signUpSurveyor(UserSignUpViewModel.signUp(
          username: widget.login.username,
          password: widget.login.password,
          surveyor: widget.surveyor));
    }
  }
}
