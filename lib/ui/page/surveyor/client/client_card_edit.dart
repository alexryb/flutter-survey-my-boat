
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/client_desc_edit.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

class ClientCardEdit extends StatefulWidget {

  Client? client;

  ClientCardEdit({required Key key, this.client}) : super(key: key);

  @override
  _ClientCardEditState createState() => new _ClientCardEditState();

}

class _ClientCardEditState extends State<ClientCardEdit> with SingleTickerProviderStateMixin {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Size? deviceSize;
  AnimationController? controller;
  Animation<double>? animation;

  Widget _clientCard() {
    var cardHeight = deviceSize!.height * 0.75;
    var cardWidth = deviceSize!.width * 0.85;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0.5,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0)),
      color: Colors.white,
      child: Ink(
        height: cardHeight,
        width: cardWidth,
        child: new Stack(
          children: <Widget>[
            Container(
              height: cardHeight - cardHeight / 1.8,
              width: double.infinity,
              child: widget.client!.image(),
              alignment: Alignment.center,
              color: Colors.white,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                width: double.infinity,
                height: cardHeight * 0.7,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(colors: UIData.kitGradients),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0)),
                  color: Colors.white,
                ),
                child: new ClientDescEdit(key: _formKey, client: widget.client!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    widget.client!.inSync = false;
    controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1500));
    animation = new Tween(begin: 0.0, end: 1.0).animate(
        new CurvedAnimation(parent: controller!, curve: Curves.fastOutSlowIn));
    animation?.addListener(() => this.setState(() {}));
    controller?.forward();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return _clientCard();
  }
}
