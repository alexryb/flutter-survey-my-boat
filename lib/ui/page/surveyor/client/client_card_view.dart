import 'package:flutter/material.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/client_desc_view.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

class ClientCardView extends StatefulWidget {
  final Client? client;

  const ClientCardView({required Key key, this.client}) : super(key: key);

  @override
  _ClientCardViewState createState() => new _ClientCardViewState();
}

class _ClientCardViewState extends State<ClientCardView> with SingleTickerProviderStateMixin {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Size deviceSize;
  AnimationController? controller;
  Animation<double>? animation;

  Widget _clientCard() {
    var cardHeight = deviceSize.height * 0.75;
    var cardWidth = deviceSize.width * 0.85;
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
              height: cardHeight - cardHeight / 2,
              width: double.infinity,
              alignment: Alignment.center,
              color: Colors.white,
              child: widget.client!.image(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                width: double.infinity,
                height: cardHeight / 1.7,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(colors: UIData.kitGradients),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0)),
                  color: Colors.white,
                ),
                child: new ClientDescView(key: _formKey, client: widget.client!),
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
    controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1500));
    animation = new Tween(begin: 0.0, end: 1.0).animate(
        new CurvedAnimation(parent: controller!, curve: Curves.fastOutSlowIn));
    animation?.addListener(() => setState(() {}));
    controller?.forward();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     { deviceSize = MediaQuery.of(context).size; }
    return _clientCard();
  }
}
