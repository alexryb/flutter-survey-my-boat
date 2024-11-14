import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/client_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/client_view_model.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_search_filter.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/ui/page/home_page.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/client_detail_page.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_scaffold.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});


  @override
  State<StatefulWidget> createState() {
    return ClientsPageState();
  }
}

class ClientsPageState extends State<ClientsPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  Widget displayWidget = progressWithBackground();

  Surveyor? _surveyor;
  ClientBloc? _clientBloc;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;

  //stack1
  Widget imageStack(String img) => Image.asset(
        img,
        fit: BoxFit.none,
      );

  Widget buttonStack(String img, Client client) => Positioned(
        top: 5,
        left: 5,
        right: 5,
        bottom: 40,
        child: Container(
          child: MaterialButton(
            onPressed: () {
              client.editMode = true;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClientDetailPage(client: client)));
            },
            color: Color(0xff0c2b20).withOpacity(1),
            child: client.image(),
          ),
        ),
      );

  //stack2
  Widget descStack(Client client) => Positioned(
        bottom: 5.0,
        left: 5.0,
        right: 5.0,
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${client.lastName}, ${client.firstName}',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget clientGrid(List<Client> clients) => GridView.count(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        shrinkWrap: true,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        childAspectRatio: 1.0,
        children: clients
            .map((client) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    splashColor: Color(0xff0c2b20).withOpacity(1),
                    borderRadius: BorderRadius.circular(15),
                    onDoubleTap: () => showClientDetailsQuickBar(client),
                    child: Card (
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      elevation: 2.0,
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: <Widget>[
                          buttonStack(UIData.userIcon, client),
                          descStack(client),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      );

  Widget _commonScaffold(List<Client> clients) {
    return CommonScaffold(
      scaffoldKey: _scaffoldKey,
      appTitle: "Clients",
      showDrawer: true,
      showFAB: false,
      showBottomNav: false,
      actionThirdIcon: Icons.help_outline,
      thirdActionCallback: () {
        showHelpScreen(context, "Clients", "clients.md");
      },
      backGroundColor: Colors.blueGrey,
      bodyWidget: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: clientGrid(clients)
      ),
    );
  }

  void showClientDetailsQuickBar(Client client) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        " $client",
        textAlign: TextAlign.left,
      ),
      action: SnackBarAction(
        label: "Close",
        onPressed: () {},
      ),
    ));
  }

  @override
  initState() {
    super.initState();
    _clientBloc = ClientBloc();
    _apiStreamSubscription =
        apiCallSubscription(_clientBloc!.apiResult, context, widget: widget);
    _gotoNextScreen();
  }

  @override
  void dispose() {
    _apiStreamSubscription?.cancel();
    _clientBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(onWillPop: _homePage, child: displayWidget);
  }

  Future<bool> _homePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    return new Future.value(true);
  }

  Future<Null> _refreshData() async {
    ClientSearchFilter searchFilter = new ClientSearchFilter();
    searchFilter.surveyorGuid = _surveyor!.surveyorGuid!;
    _clientBloc?.getClients(ClientViewModel.search(searchFilter: searchFilter));
    return;
  }
  
  void _gotoNextScreen() {
    if (_surveyor == null) {
      StorageBloc localStorageBloc = new StorageBloc();
      localStorageBloc.loadSurveyor().then((surveyor) {
        _surveyor = surveyor;
        _refreshData();
        _clientBloc?.clients.listen((clients) {
          setState(() => displayWidget = _commonScaffold(clients.elements));
        });
            });
      localStorageBloc.dispose();
    } else {
      _refreshData();
      _clientBloc?.clients.listen((clients) {
        setState(() => displayWidget = _commonScaffold(clients.elements));
      });
    }
  }
}
