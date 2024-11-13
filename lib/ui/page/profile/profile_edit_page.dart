import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/code_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/surveyor_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/surveyor_view_model.dart';
import 'package:surveymyboatpro/model/code.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/model/surveyor_certificate.dart';
import 'package:surveymyboatpro/model/surveyor_image.dart';
import 'package:surveymyboatpro/ui/page/generic/image_picker_page.dart';
import 'package:surveymyboatpro/ui/page/login/identity_page.dart';
import 'package:surveymyboatpro/ui/page/profile/profile_view_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_divider.dart';
import 'package:surveymyboatpro/ui/widgets/common_scaffold.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class ProfileEditPage extends StatefulWidget {
  Surveyor surveyor;

  ProfileEditPage();

  ProfileEditPage.withUser(Surveyor userData) {
    this.surveyor = userData;
    this.surveyor.inSync = false;
  }

  @override
  State<StatefulWidget> createState() {
    return ProfileEditPageState();
  }
}

class ProfileEditPageState extends State<ProfileEditPage> {

  var _phoneMaskFormatter = new MaskTextInputFormatter(
      mask: "(###) ###-####", filter: {"#": RegExp(r'[0-9]')});

  static Size deviceSize;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

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

  SurveyorBloc _surveyorBloc;
  StreamSubscription<FetchProcess> _apiSurveyorStreamSubscription;

  // var _phoneMaskFormatter = new MaskTextInputFormatter(
  //     mask: "# ### ###-####", filter: {"#": RegExp(r'[0-9]')});

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
                      _isOrg() ? _orgBnFocusNode : _emailFocusNode);
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
    List<String> _initialValues = List.empty(growable: true);
    for (SurveyorCertificate certificate
        in this.widget.surveyor.certifications) {
      _initialValues.add(certificate.code);
    }
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
            MultiSelectFormField(
              autovalidate: false,
              title: Text("Please select certifications "),
              dataSource: _datasource.map((v) => v.toJson()).toList(),
              initialValue: _initialValues,
              textField: 'description',
              valueField: 'code',
              okButtonLabel: 'OK',
              cancelButtonLabel: 'CANCEL',
              border: InputBorder.none,
              onSaved: (value) {
                fieldFocusChange(context, _currentFocusNode, _submitFocusNode);
                if (value == null) return;
                setState(() {
                  _populateCertificates(value, _datasource);
                });
              },
            ),
          ]),
    );
  }

  Widget _contactInfoColumn() => Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
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
                maxLines: 1,
                focusNode: _emailFocusNode,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email Address",
                  suffixIcon: Icon(Icons.email),
                ),
                initialValue: this.widget.surveyor.emailAddress,
                onChanged: (un) => this.widget.surveyor.emailAddress = un,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
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
                maxLines: 1,
                focusNode: _phoneFocusNode,
                inputFormatters: [_phoneMaskFormatter],
                autofocus: true,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  suffixIcon: Icon(Icons.phone),
                ),
                initialValue: this.widget.surveyor.phoneNumber,
                onChanged: (un) => this.widget.surveyor.phoneNumber = un,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
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
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: "Address",
                  suffixIcon: Icon(Icons.location_city),
                ),
                initialValue: this.widget.surveyor.addressLine,
                onChanged: (un) => this.widget.surveyor.addressLine = un,
                textInputAction: TextInputAction.newline,
                validator: (value) {
                  if (value.isEmpty) {
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
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
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
                maxLines: 1,
                focusNode: _orgBnFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Business Number",
                  suffixIcon: Icon(Icons.business),
                ),
                initialValue: this.widget.surveyor.organization.businessNumber,
                onChanged: (un) =>
                    this.widget.surveyor.organization.businessNumber = un,
                textInputAction: TextInputAction.next,
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
                onChanged: (un) => this.widget.surveyor.organization.name = un,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
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
                  this.widget.surveyor.organization.emailAddress = un;
                  this.widget.surveyor.emailAddress = un;
                },
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
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
                maxLines: 1,
                focusNode: _orgPhoneFocusNode,
                inputFormatters: [_phoneMaskFormatter],
                autofocus: true,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Business Phone",
                  suffixIcon: Icon(Icons.phone),
                ),
                initialValue: this.widget.surveyor.organization.phoneNumber,
                onChanged: (un) {
                  this.widget.surveyor.organization.phoneNumber = un;
                  this.widget.surveyor.phoneNumber = un;
                },
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
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
                  this.widget.surveyor.organization.addressLine = un;
                  this.widget.surveyor.addressLine = un;
                },
                textInputAction: TextInputAction.newline,
                validator: (value) {
                  if (value.isEmpty) {
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

  // Widget _submitColumn() => Container(
  //   padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
  //   width: double.infinity,
  //   child: RaisedButton(
  //     padding: EdgeInsets.all(12.0),
  //     shape: StadiumBorder(),
  //     focusNode: _submitFocusNode,
  //     child: Text(
  //       "Submit",
  //       style: TextStyle(color: Colors.white),
  //     ),
  //     color: Colors.blueGrey,
  //     onPressed: () {
  //       if(validateSubmit(_formKey, _scaffoldKey,  context)) {
  //         _saveSurveyor();
  //       }
  //     },
  //   ),
  // );

  _editProfileFields() => Form (
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _personalInfoColumn(),
            CommonDivider(),
            if (!_isOrg()) _contactInfoColumn(),
            if (_isOrg()) _orgColumn(),
            CommonDivider(),
            _certificationsColumn(),
            CommonDivider(),
            //_submitColumn(),
          ],
        ),
      );

  _surveyorAvatar() => CircleAvatar(
    backgroundImage: this.widget.surveyor.image().image,
    foregroundColor: Colors.black,
    radius: 80.0,
  );

  bool _isOrg() => widget.surveyor.organization != null;

  Widget _bodyData() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          _surveyorImagesCard(),
          _editProfileFields(),
        ],
      ),
    );
  }

  Widget _profileScaffold() => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        CommonScaffold(
          scaffoldKey: _scaffoldKey,
          appTitle: "Edit Profile",
          showDrawer: true,
          showFAB: true,
          showBottomNav: false,
          backGroundColor: Colors.white,
          bodyWidget: _bodyData(),
          floatingIcon1: Icons.add_a_photo,
          floatAction1Callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImagePickerPage.withImageContainer(
                  title: "Picture of \"${this.widget.surveyor.getName()}\"",
                  imageContainer: this.widget.surveyor,
                ),
              ),
            );
          },
          floatingIcon2: Icons.save_outlined,
          floatAction2Callback: () {
            if(validateSubmit(_formKey, _scaffoldKey,  context)) {
              _saveSurveyor();
            }
          },
        )
      ],
    ),
  );

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Unsaved data will be lost. Please save the profile first.'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop(false);
            },
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
              FocusScope.of(context).unfocus();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileViewPage()));
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
    ) ??
        false;
  }

  @override
  initState() {
    super.initState();
    _currentFocusNode = _titleFocusNode;
    _surveyorBloc = new SurveyorBloc();
    _apiSurveyorStreamSubscription =
        apiCallSubscription(_surveyorBloc.apiResult, context, widget: widget);
    _gotoNextScreen();
  }

  @override
  Widget build(BuildContext context) {
     { deviceSize = MediaQuery.of(context).size; }
    return new WillPopScope(onWillPop: _onBackPressed, child: displayWidget);
  }

  @override
  void dispose() {
    _surveyorBloc?.dispose();
    _apiSurveyorStreamSubscription?.cancel();
    _phoneMaskFormatter.clear();
    super.dispose();
  }

  void _gotoNextScreen() {
    if (widget.surveyor == null) {
      StorageBloc _localStorageBloc = new StorageBloc();
      _localStorageBloc.loadSurveyor().then((_surveyor) {
        if (_surveyor != null) {
          widget.surveyor = _surveyor;
          widget.surveyor.inSync = false;
          setState(() => displayWidget = _profileScaffold());
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => IdentityPage()));
        }
      });
    } else {
      setState(() => displayWidget = _profileScaffold());
    }
  }
  
  void _populateCertificates(var selectedCertificates, List<Code> codes) {
    String formattedDate = new DateTime.now().toString().substring(0, 10);
    for (String _value in selectedCertificates) {
      for (Code _code in codes) {
        if (_code.code == _value) {
          SurveyorCertificate cert = _findSurveyorCertificaterByCode(_value);
          if (cert == null) {
            cert = new SurveyorCertificate();
            cert.isSelected = true;
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
    _removeUnselectedCertificates();
  }

  SurveyorCertificate _findSurveyorCertificaterByCode(String code) {
    for (SurveyorCertificate cert in this.widget.surveyor.certifications) {
      if (cert.code == code) {
        cert.isSelected = true;
        return cert;
      }
    }
    return null;
  }

  void _removeUnselectedCertificates() {
    int l = this.widget.surveyor.certifications.length;
    for (int i = 0; i < l; i++) {
      SurveyorCertificate cert = this.widget.surveyor.certifications[i];
      if (!cert.isSelected) {
        this.widget.surveyor.certifications.remove(cert);
      }
    }
  }

  Widget _surveyorImagesCard() => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _surveyorImages(),
    ),
  );

  List<Widget> _surveyorImages() {
    List<Widget> rows = List<Widget>.empty(growable: true);
    if (this.widget.surveyor.images != null) {
      for (var i = 0; i < this.widget.surveyor.images.length; i++) {
        rows.add(
          new Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
            child: _surveyorImage(this.widget.surveyor.images[i]),
          ),
        );
      }
    }
    return rows;
  }

  _surveyorImage(SurveyorImage image) => Dismissible(
      key: ObjectKey(image.imageGuid),
      child: CircleAvatar(
        backgroundImage: this.widget.surveyor.image().image,
        foregroundColor: Colors.black,
        radius: 80.0,
      ),
      onDismissed: (direction) {
        setState(() {
          this.widget.surveyor.images.clear();
        });
      });

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    _currentFocusNode = nextFocus;
    FocusScope.of(context).requestFocus(_currentFocusNode);
  }

  void _saveSurveyor() {
    _surveyorBloc.saveSurveyor(SurveyorViewModel.save(this.widget.surveyor));
  }
}
