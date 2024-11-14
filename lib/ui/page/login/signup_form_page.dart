import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/bloc/signup_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/user_signup_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/settings.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_divider.dart';
import 'package:surveymyboatpro/ui/widgets/terms_of_use.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

enum SignUpValidationType { username, password, confirmPassword }

class SignUpFormPage extends StatefulWidget {
  const SignUpFormPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignUpFormPageState();
  }
}

class SignUpFormPageState extends State<SignUpFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Settings? _settings;
  final bool _checkUserName = false;
  String? _userNameValid;

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final Pattern _usernamePattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
  final Pattern _passwordPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';

  SignUpBloc? _signUpBloc;
  String? _username, _password;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;

  signUpBody() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[signUpHeader(), signUpFields()],
        ),
      );

  signUpHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: new AssetImage(UIData.imbLogoIcon),
            radius: 80.0,
          ),
          CommonDivider(
            height: 45,
          ),
          Text(
            "Sign Up to continue",
            style: TextStyle(color: Colors.black54),
            textScaleFactor: 2,
          ),
        ],
      );

  signUpFields() => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextFormField(
                maxLines: 1,
                focusNode: _usernameFocusNode,
                autofocus: true,
                validator: (name) {
                  RegExp regex = new RegExp(_usernamePattern.toString());
                  if (!regex.hasMatch(name!)) {
                    return 'Invalid username (alphanumeric only)';
                  } else {
                    return null;
                  }
                },
                onChanged: (un) => _username = un,
                decoration: InputDecoration(
                  hintText: "Enter your username",
                  suffixIcon: Icon(Icons.person),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _usernameFocusNode, _passwordFocusNode);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextFormField(
                maxLines: 1,
                focusNode: _passwordFocusNode,
                autofocus: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (password) {
                  RegExp regex = new RegExp(_passwordPattern.toString());
                  if (!regex.hasMatch(password!)) {
                    return 'Invalid password (>=8 with UPPER, lower and special char)';
                  } else {
                    return null;
                  }
                },
                onChanged: (p) => _password = p,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  suffixIcon: Icon(Icons.lock),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _passwordFocusNode, _confirmPasswordFocusNode);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextFormField(
                maxLines: 1,
                focusNode: _confirmPasswordFocusNode,
                autofocus: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (confirmPassword) {
                  if(confirmPassword!.isEmpty) {
                    return 'Required field';
                  }
                  if (confirmPassword.compareTo(_password!) != 0) {
                    return 'Password doesn\'t match';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  suffixIcon: Icon(Icons.lock),
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
              width: double.infinity,
              child: MaterialButton (
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                color: Colors.blueGrey,
                onPressed: () {
                  if (validateSubmit(_formKey, _scaffoldKey,  context)) {
                    _formKey.currentState?.save();
                    _signUpBloc?.signUpUserAccount(UserSignUpViewModel.validate(username: _username, password: _password));
                  }
                },
                child: Text(
                  "SIGN UP FOR AN ACCOUNT",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TermsOfUse(),
          ],
        ),
      );

  Widget signUpScaffold() => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Center(
          child: signUpBody(),
        ),
      );
  
  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  initState() {
    super.initState();
    _settings = Injector.SETTINGS!;
    _signUpBloc = new SignUpBloc();
    _apiStreamSubscription = apiCallSubscription(_signUpBloc!.apiResult, context, widget: widget);
  }

  @override
  void dispose() {
    _signUpBloc?.dispose();
    _apiStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _settings?.deviceSize = MediaQuery.of(context).size;
    return signUpScaffold();
  }
}
