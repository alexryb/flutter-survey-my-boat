import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/bloc/login_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/user_login_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/settings.dart';
import 'package:surveymyboatpro/ui/page/generic/analytics_page_state.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_divider.dart';
import 'package:surveymyboatpro/ui/widgets/terms_of_use.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

class LoginFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginFormPageState();
  }
}

class LoginFormPageState extends AnalyticsState<LoginFormPage> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Settings? _settings;

  FocusNode? _usernameFocusNode = FocusNode();
  FocusNode? _passwordFocusNode = FocusNode();
  FocusNode? _loginFocusNode = FocusNode();
  FocusNode? _recoverPasswordFocusNode = FocusNode();
  
  LoginBloc? _loginBloc;
  String? _username, _password;
  bool? _recoverPassword = false;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;

  Widget loginScaffold() => Scaffold(
    key: _scaffoldKey,
    backgroundColor: Colors.white,
    body: Center(
      child: loginBody(),
    ),
  );

  loginBody() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[loginHeader(), loginFields()],
        ),
      );

  loginHeader() => Column(
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
            "Sign in to continue",
            style: TextStyle(color: Colors.black54),
            textScaleFactor: 2,
          ),
        ],
      );

  loginFields() => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextFormField(
                key: Key("usernameResourceId"),
                maxLines: 1,
                focusNode: _usernameFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Enter your username",
                  suffixIcon: Icon(Icons.person),
                ),
                onChanged: (un) => _username = un,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Required field";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _usernameFocusNode!, _passwordFocusNode!);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextFormField(
                key: Key("passwordResourceId"),
                maxLines: 1,
                focusNode: _passwordFocusNode,
                autofocus: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  suffixIcon: Icon(Icons.lock),
                ),
                onChanged: (p) => _password = p,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _passwordFocusNode!, _loginFocusNode!);
                },
                validator: (value) {
                  if (value!.isEmpty && !_recoverPassword!) {
                    return "Required field";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
              width: double.infinity,
              child: MaterialButton  (
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                focusNode: _loginFocusNode,
                child: Text(
                  "SIGN IN",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blueGrey,
                onPressed: () {
                  if(validateSubmit(_formKey, _scaffoldKey, context)) {
                    this.sendAnalyticsEvent("login", <String, Object> {
                      "login": _username!,
                    });
                    _loginBloc!.login(UserLoginViewModel.withLogin(
                        username: _username, password: _password));
                  }
                },
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
              width: double.infinity,
              child: MaterialButton(
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                focusNode: _recoverPasswordFocusNode,
                color: Colors.grey,
                onPressed: () {
                  _recoverPassword = true;
                  if(validateSubmit(_formKey, _scaffoldKey, context)) {
                    _loginBloc!.recoverPassword(UserLoginViewModel.withLogin(
                        username: _username, password: '',));
                  }
                },
                child: Text(
                  "RECOVER PASSWORD",
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

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  initState() {
    super.initState();
    _settings = Injector.SETTINGS;
    _loginBloc = new LoginBloc();
    _apiStreamSubscription = apiCallSubscription(_loginBloc!.apiResult, context, widget: widget);
    _recoverPassword = false;
  }

  @override
  void dispose() {
    _loginBloc?.dispose();
    _apiStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _settings?.deviceSize = MediaQuery.of(context).size;
    return loginScaffold();
  }
}
