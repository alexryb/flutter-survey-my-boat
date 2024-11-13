import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/client_bloc.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/client_detail_widgets.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/clients_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_scaffold.dart';

class ClientDetailPage extends StatefulWidget {

  Client? client;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ClientDetailPage({required Key key, this.client}) : super(key: key);
  ClientDetailPage.Survey({required Key key, this.client}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ClientDetailPageState(key: _formKey, client: client!);
  }
}

class ClientDetailPageState extends State<ClientDetailPage> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Client? client;

  ClientBloc? _clientBloc;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;
  Widget? displayWidget = progressWithBackground();

  ClientDetailPageState({required Key key, this.client,});

  Widget clientScaffold(Client client) => new PopScope(
      onPopInvokedWithResult: !widget.client!.editMode! ? null : _onBackPressed,
      child: Form(
        key: _formKey,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CommonScaffold(
              scaffoldKey: _scaffoldKey,
              appTitle: "Client ${client.lastName}, ${client.firstName}",
              showDrawer: true,
              showFAB: false,
              showBottomNav: false,
              automaticallyImplyLeading: false,
              backGroundColor: Colors.white,
              bodyWidget: ClientDetailWidgets(
                key: _formKey,
                client: this.client!,
              ),
            )
          ],
        ),
      ));

  void _onBackPressed(bool val, dynamic Object) {
    showDialog(
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
              widget.client!.editMode = false;
              FocusScope.of(context).unfocus();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClientsPage()));
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
    _clientBloc = ClientBloc();
    _apiStreamSubscription =
        apiCallSubscription(_clientBloc!.apiResult, context, widget: widget);
  }

  @override
  void dispose() {
    _apiStreamSubscription?.cancel();
    _clientBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return clientScaffold(this.client!);
  }
}
