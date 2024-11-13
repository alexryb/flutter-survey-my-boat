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

  Client client;

  ClientDetailPage({Key key, this.client}) : super(key: key);
  ClientDetailPage.Survey({Key key, this.client}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ClientDetailPageState(client: client,);
  }
}

class ClientDetailPageState extends State<ClientDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Client client;

  ClientBloc _clientBloc;
  StreamSubscription<FetchProcess> _apiStreamSubscription;
  Widget displayWidget = progressWithBackground();

  ClientDetailPageState({Key key, this.client,});

  Widget clientScaffold(Client client) => new WillPopScope(
      onWillPop: !widget.client.editMode ? null : _onBackPressed,
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
                client: this.client,
              ),
            )
          ],
        ),
      ));

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
              widget.client.editMode = false;
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
        apiCallSubscription(_clientBloc.apiResult, context, widget: widget);
  }

  @override
  void dispose() {
    _apiStreamSubscription?.cancel();
    _clientBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return clientScaffold(this.client);
  }
}
