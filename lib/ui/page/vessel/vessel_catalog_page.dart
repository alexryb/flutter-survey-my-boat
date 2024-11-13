import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/vessel_catalog_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/vessel_catalog_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/model/vessel_catalog.dart';
import 'package:surveymyboatpro/model/vessel_catalog_list.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_drawer.dart';
import 'package:surveymyboatpro/utils/uidata.dart';
import 'package:url_launcher/url_launcher.dart';

class VesselCatalogPage extends StatefulWidget {
  String vesselCatalogGuid;
  String searchString;

  Surveyor surveyor;

  VesselCatalogPage();

  VesselCatalogPage.search(String search) {
    this.searchString = search;
  }

  @override
  State<StatefulWidget> createState() {
    return VesselCatalogPageState();
  }
}

class VesselCatalogPageState extends State<VesselCatalogPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  VesselCatalogViewModel _vesselCatalogViewModel;
  VesselCatalogBloc _vesselCatalogBloc;
  StreamSubscription<FetchProcess> _apiStreamSubscription;

  Widget displayWidget = progressWithBackground();

  //column1
  Widget vesselCatalogColumn(
          BuildContext context, VesselCatalog vesselCatalog) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // CircleAvatar(
          //   backgroundImage: NetworkImage(vesselCatalog.logoSrc),
          // ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  vesselCatalog.getVesselDescription(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .apply(fontWeightDelta: 700),
                ),
                SizedBox(height: 10),
                Text(
                  '${vesselCatalog.getHullType()}, ${vesselCatalog.getRiggingType()}',
                  style: Theme.of(context).textTheme.caption.apply(
                      fontFamily: UIData.quickBoldFont, color: Colors.brown),
                )
              ],
            ),
          ))
        ],
      );

  //column last
  Widget loaColumn(VesselCatalog vesselCatalog) => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'LOA: ${vesselCatalog.getLoa()}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                ),
                SizedBox(width: 20),
                Text(
                  'Beam: ${vesselCatalog.getBeam()}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                ),
              ],
            ),
          ],
        ),
      );

  Widget dispColumn(VesselCatalog vesselCatalog) => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Disp: ${vesselCatalog.getDisp()}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                ),
                SizedBox(width: 20),
                Text(
                  'Ballast: ${vesselCatalog.getBallast()}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                ),
              ],
            ),
          ],
        ),
      );

  Widget designerColumn(VesselCatalog vesselCatalog) => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Designer: ${vesselCatalog.vesselDesigner}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                ),
              ],
            ),
          ],
        ),
      );

  Widget builderColumn(VesselCatalog vesselCatalog) => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Builder: ${vesselCatalog.getBuilder()}',
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                )
              ],
            ),
          ],
        ),
      );

  //post cards
  Widget vesselCatalogCard(BuildContext context, VesselCatalog vesselCatalog) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: vesselCatalogColumn(context, vesselCatalog),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new RichText(
              text: new TextSpan(
                children: [
                  new TextSpan(
                    text: 'Full specification of the Vessel',
                    style: new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch(vesselCatalog.vesselUrl);
                      },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          // vesselCatalog.imageSrc != null
          //     ? Image.network(
          //         vesselCatalog.imageSrc,
          //         fit: BoxFit.cover,
          //       )
          //     : Container(),
          // vesselCatalog.imageSrc != null ? Container() : CommonDivider(),
          loaColumn(vesselCatalog),
          dispColumn(vesselCatalog),
          designerColumn(vesselCatalog),
          builderColumn(vesselCatalog),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  //searchForm
  Widget searchCard() => PreferredSize(
        preferredSize: Size(double.infinity, 80.0),
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white, width: 2)),
                        filled: true,
                        hintText: "Find Vessel"),
                    onChanged: (un) =>
                        this._vesselCatalogViewModel.modelName = un,
                    autofocus: true,
                  ),
                ),
                new IconButton(
                  icon: new Icon(Icons.search),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _displaySelection();
                  },
                ),
              ],
            ),
          ),
        ),
      );

  Widget appBar() => SliverAppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 2.0,
        title: Text("Vessels Catalog"),
        forceElevated: true,
        pinned: true,
        floating: true,
        bottom: searchCard(),
      );

  Widget bodyList(List<VesselCatalog> vesselCatalogs) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: vesselCatalogs.length > 0 ? vesselCatalogCard(context, vesselCatalogs[index]) : dataNotFoundWidget("No vessel found"),
          );
        }, childCount: vesselCatalogs.length > 0 ? vesselCatalogs.length : 1),
      );

  Widget bodySliverList() {
    _vesselCatalogBloc.getVesselCatalog(_vesselCatalogViewModel);
    return StreamBuilder<VesselCatalogList>(
        stream: _vesselCatalogBloc.vesselCatalogController.stream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? CustomScrollView(
                  slivers: <Widget>[
                    appBar(),
                    bodyList(snapshot.data.elements),
                  ],
                )
              : SizedBox.shrink();
        });
  }

  void _gotoNextScreen() {
    setState(() => displayWidget = _scaffoldWidget());
  }

  @override
  initState() {
    super.initState();
    _vesselCatalogViewModel = VesselCatalogViewModel.search();
    _vesselCatalogBloc = new VesselCatalogBloc();
    _apiStreamSubscription =
        apiCallSubscription(_vesselCatalogBloc.apiResult, context, widget: widget);
    _gotoNextScreen();
  }

  @override
  dispose() {
    _vesselCatalogBloc.dispose();
    _apiStreamSubscription.cancel();
    super.dispose();
  }

  Widget _scaffoldWidget() {
    return Scaffold(
        key: _scaffoldKey,
        drawer: CommonDrawer(),
        body: new WillPopScope(
        onWillPop: () async => false,
        child: bodySliverList(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return displayWidget;
  }

  _displaySelection() {
    setState(() => displayWidget = _scaffoldWidget());
  }
}
