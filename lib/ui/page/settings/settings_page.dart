import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/bloc/login_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/sync_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/sync_view_model.dart';
import 'package:surveymyboatpro/logic/viewmodel/user_login_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/ui/page/home_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_scaffold.dart';
import 'package:surveymyboatpro/ui/widgets/common_switch.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  Icon? _expandIcon = Icon(Icons.arrow_drop_down);
  Icon? _collapseIcon = Icon(Icons.arrow_drop_up);

  Icon? _accountIcon;
  Icon? _servicesIcon;
  bool? _showServices = false;

  StorageBloc? _storageBloc;
  SyncBloc? _syncBloc;
  LoginBloc? _loginBloc;

  Login? _login;
  String? _newPassword;
  
  FocusNode? _passwordFocusNode = FocusNode();
  FocusNode? _newPasswordFocusNode = FocusNode();
  FocusNode? _confirmNewPasswordFocusNode = FocusNode();
  FocusNode? _submitNewPasswordFocusNode = FocusNode();
  
  Pattern _passwordPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';

  StreamSubscription<FetchProcess>? _apiStreamSyncSubscription;
  StreamSubscription<FetchProcess>? _apiStreamLoginSubscription;

  Widget bodyData() => SingleChildScrollView(
        child: Theme(
          data: ThemeData(fontFamily: UIData.ralewayFont),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "General Setting",
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 2.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        title: Text("Account"),
                        trailing: _accountIcon,
                        onExpansionChanged: (bool val) {
                          setState(() {
                            if(val) _accountIcon = _collapseIcon;
                            else _accountIcon = _expandIcon;
                          });
                        },
                        children: [
                          _changePasswordWidget(),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.sync,
                        color: Colors.blueGrey,
                      ),
                      title: Text("Sync on Data Plan"),
                      trailing: CommonSwitch(
                        defValue: Injector.SETTINGS?.syncOnDataNetwork,
                        onChanged: (bool val) {
                          if(val == true) confirmDataUsage(context);
                          else {
                            setState(() {
                              Injector.SETTINGS?.syncOnDataNetwork = val;
                              _storageBloc?.saveSettings(Injector.SETTINGS!);
                            });
                          }
                        },
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.router,
                        color: Colors.blueGrey,
                      ),
                      title: Text("Online Mode"),
                      trailing: CommonSwitch(
                        defValue: Injector.SETTINGS?.onlineMode,
                        onChanged: (bool val) {
                          setState(() {
                            Injector.SETTINGS?.onlineMode = val;
                            _storageBloc?.saveSettings(Injector.SETTINGS!);
                            if(val) {
                              _syncData();
                            };
                          });
                        },
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.camera_alt,
                        color: Colors.blueGrey,
                      ),
                      title: Text("Camera size"),
                      trailing: SizedBox(
                        width: 120,
                        child: DropdownButtonFormField<String>(
                            value: "${Injector.SETTINGS?.cameraHeigth}x${Injector.SETTINGS?.cameraWidth}",
                            items: ["320x240","640x480","800x600"].map((label) =>
                                DropdownMenuItem<String>(
                                  child: Text(label),
                                  value: label,
                                )).toList(),
                            autofocus: true,
                            onChanged: (value) {
                              setState(() {
                                int heigth = int.parse(value!.substring(0, 3));
                                int width = int.parse(value!.substring(4, 7));
                                Injector.SETTINGS?.cameraHeigth = heigth;
                                Injector.SETTINGS?.cameraWidth = width;
                              });
                              _storageBloc?.saveSettings(Injector.SETTINGS!);
                            },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              //2
              /***
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Network",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 2.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        title: Text("Services"),
                        trailing: _servicesIcon,
                        onExpansionChanged: (bool val) {
                          setState(() {
                            if(val) _servicesIcon = _collapseIcon;
                            else _servicesIcon = _expandIcon;
                          });
                        },
                        children: [
                          _unlockServicesWidget(),
                          Visibility(
                            visible: _showServices,
                            child: _servicesWidget(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),***/
            ],
          ),
        ),
      );

  Widget _unlockServicesWidget() => Visibility(
          visible: !this._showServices!,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    maxLines: 1,
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: Icon(Icons.lock_outline),
                    ),
                    onChanged: (un) => {
                      // if (un == Injector.SETTINGS.unlockPassword) {
                      //     setState(() => this._showServices = true),
                      //   }
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {},
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ]),
       )
  );

  Widget _changePasswordWidget() => Form (
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Change Password",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox (
                height: 10.0,
              ),
              TextFormField(
                maxLines: 1,
                focusNode: _passwordFocusNode,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "Current Passsword",
                  suffixIcon: Icon(Icons.lock_outline),
                ),
                onChanged: (un) => { _login?.password = un },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _passwordFocusNode!, _newPasswordFocusNode!);
                },
                validator: (password) {
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                maxLines: 1,
                focusNode: _newPasswordFocusNode,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  suffixIcon: Icon(Icons.lock),
                ),
                onChanged: (un) => { _newPassword = un },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _passwordFocusNode!, _confirmNewPasswordFocusNode!);
                },
                validator: (password) {
                  RegExp regex = new RegExp(_passwordPattern.toString());
                  if (!regex.hasMatch(password!)) {
                    return 'Invalid password (>=8 with UPPER, lower and special char)';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                maxLines: 1,
                focusNode: _confirmNewPasswordFocusNode,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  suffixIcon: Icon(Icons.lock),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  fieldFocusChange(
                      context, _confirmNewPasswordFocusNode!, _submitNewPasswordFocusNode!);
                },
                validator: (confirmPassword) {
                  if (confirmPassword!.compareTo(_newPassword!) != 0) {
                    return 'Password doesn\'t match';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              MaterialButton(
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                focusNode: _submitNewPasswordFocusNode,
                autofocus: true,
                child: Text(
                  "Save new password",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blueGrey,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _loginBloc?.changePassword(UserLoginViewModel.withLogin(username: _login?.username, password: _login?.password, newPassword: _newPassword));
                  }
                },
              ),
              SizedBox(
                height: 10.0,
              ),
            ]),
      )
  );

  Widget _servicesWidget() => Container(
    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            maxLines: null,
            autofocus: true,
            initialValue: Injector.SETTINGS?.apiBaseUrl,
            decoration: InputDecoration(
              hintText: "Rest Api URL",
              suffixIcon: Icon(Icons.router),
            ),
            onChanged: (un) => {
              Injector.SETTINGS?.apiBaseUrl = un
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {},
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            maxLines: null,
            autofocus: true,
            initialValue: Injector.SETTINGS?.oauthBaseUrl,
            decoration: InputDecoration(
              hintText: "Authorization URL",
              suffixIcon: Icon(Icons.security),
            ),
            onChanged: (un) => {
              Injector.SETTINGS?.oauthBaseUrl = un
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {},
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            maxLines: null,
            autofocus: true,
            initialValue: Injector.SETTINGS?.paymentProvider,
            decoration: InputDecoration(
              hintText: "Payment Provider",
              suffixIcon: Icon(Icons.payment_rounded),
            ),
            onChanged: (un) => {
              Injector.SETTINGS?.paymentProvider = un
            },
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {},
          ),
          SizedBox(
            height: 15.0,
          ),
          MaterialButton(
            padding: EdgeInsets.all(12.0),
            shape: StadiumBorder(),
            child: Text(
              "Save Settings",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blueGrey,
            onPressed: () {
              _storageBloc?.saveSettings(Injector.SETTINGS!);
            },
          ),
          SizedBox(
            height: 10.0,
          ),
        ]),
  );
  
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _homePage,
      child: CommonScaffold(
        appTitle: "Settings",
        showDrawer: true,
        showFAB: false,
        actionFirstIcon: Icons.book,
        backGroundColor: Colors.grey.shade300,
        bodyWidget: bodyData(),
      ),
    );
  }

  Future<bool> _homePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    return new Future.value(true);
  }

  @override
  void dispose() {
    _storageBloc?.dispose();
    _syncBloc?.dispose();
    _loginBloc?.dispose();
    _apiStreamSyncSubscription?.cancel();
    _apiStreamLoginSubscription?.cancel();
    super.dispose();
  }

  void initState() {
    super.initState();
    _accountIcon = _expandIcon;
    _servicesIcon = _expandIcon;
    _storageBloc = new StorageBloc();
    _storageBloc?.loadCredentials().then((value) => {
      this._login = value!.login
    });
    _syncBloc = new SyncBloc();
    _loginBloc = new LoginBloc();
    _apiStreamSyncSubscription = apiCallSubscription(_syncBloc!.apiResult, context, widget: widget);
    _apiStreamLoginSubscription = apiCallSubscription(_loginBloc!.apiResult, context, widget: widget);
  }

  void _syncData() {
    _syncBloc?.syncQuiet(new SyncViewModel());
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  
  confirmDataUsage(BuildContext context) {
    String message = "Your data provider may charge you for the data usage. Are you sure?";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(UIData.confirm),
        content: Text(message),
        actions: <Widget>[
          MaterialButton(
            child: Text(UIData.ok),
            textColor: Colors.black,
            onPressed: () {
              setState(() {
                Injector.SETTINGS?.syncOnDataNetwork = true;
                _storageBloc?.saveSettings(Injector.SETTINGS!);
              });
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: Text(UIData.cancel),
            textColor: Colors.black,
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
