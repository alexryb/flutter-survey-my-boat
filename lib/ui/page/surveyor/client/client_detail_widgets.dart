import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/client_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/client_view_model.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/ui/page/generic/image_picker_page.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/client_card_edit.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/client_card_view.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';

class ClientDetailWidgets extends StatefulWidget {
  final Client client;

  const ClientDetailWidgets({Key key, this.client}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClientDetailWidgetsState();
  }
}

class ClientDetailWidgetsState extends State<ClientDetailWidgets> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ClientBloc _clientBloc;
  StreamSubscription<FetchProcess> _apiClientStreamSubscription;

  Widget _clientDetailColumn() => new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: widget.client.editMode
                    ? ClientCardEdit(client: widget.client)
                    : ClientCardView(client: widget.client)),
          ],
        ),
      );

  Widget _editClientActionButton() {
    return FloatingActionButton(
      child: new Icon(
        widget.client.editMode ? Icons.save : Icons.edit,
        //color: Colors.blue,
      ),
      heroTag: "clientButton",
      onPressed: () {
        if (!widget.client.editMode)
          _editMode();
        else
          _viewMode();
      },
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
    );
  }

  Widget _takePhotoActionButton() {
    return Visibility(
        visible: true,
        child: FloatingActionButton(
          child: new Icon(
            Icons.add_a_photo,
            //color: Colors.blue,
          ),
          heroTag: "photoButton",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImagePickerPage.withImageContainer(
                  title: "Picture of \"${this.widget.client.getName()}\"",
                  imageContainer: this.widget.client,
                ),
              ),
            );
          },
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ));
  }

  Widget _clientScaffold() => Form(
      key: _formKey,
      child:
        Scaffold(
          key: _scaffoldKey,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _clientDetailColumn(),
            ],
          ),
         floatingActionButton: widget.client.editMode ?
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _editClientActionButton(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _takePhotoActionButton(),
                ),
              ]
          ) : null,
        )
      );

  @override
  void initState() {
    super.initState();
    _clientBloc = new ClientBloc();
    _apiClientStreamSubscription =
        apiCallSubscription(_clientBloc.apiResult, context, widget: widget);
  }

  @override
  void dispose() {
    _clientBloc?.dispose();
    _apiClientStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _clientScaffold();
  }

  _editMode() {
    setState(() => widget.client.editMode = true);
    setState(() => widget);
  }

  _viewMode() {
    //setState(() => widget.client.editMode = false);
    //setState(() => widget);
    _submitUpdateClient();
  }

  Future<bool> _submitUpdateClient() {
    FocusScope.of(context).unfocus();
    if(validateSubmit(_formKey, _scaffoldKey, context)) {
      _clientBloc.saveClient(ClientViewModel.create(widget.client));
      return new Future.value(true);
    }
    return new Future.value(false);
  }
}
