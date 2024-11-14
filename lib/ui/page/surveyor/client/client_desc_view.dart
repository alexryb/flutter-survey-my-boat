import 'package:flutter/material.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ClientDescView extends StatelessWidget {

  final Client? client;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ClientDescView({required Key key, this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new SizedBox(
            height: 30.0,
          ),
          Visibility(
            visible: true,
            child: new Text(
              client!.fullName(),
              style: new TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ),
          new SizedBox(
            height: 15.0,
          ),
          Visibility(
            visible: true,
            child: new MaterialButton(
                onPressed: () =>
                    UrlLauncher.launch('mailto:+${client!.emailAddress}'),
                child: new Text(client!.emailAddress!,
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white))),
          ),
          new SizedBox(
            height: 15.0,
          ),
          Visibility(
            visible: true,
            child: new MaterialButton(
                onPressed: () =>
                    UrlLauncher.launch('tel:+${client!.phoneNumber}'),
                child: new Text(client!.phoneNumber!,
                    style: new TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow))),
          ),
          new SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(children: <Widget>[
              Visibility(
                visible: true,
                child: SizedBox(
                  width: 200,
                    child: Text(
                      client!.addressLine!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.start,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
