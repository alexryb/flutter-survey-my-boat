import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surveymyboatpro/logic/bloc/sync_bloc.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';

class ExitPage extends StatefulWidget {
  const ExitPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ExitPageState();
  }
}

class ExitPageState extends State<ExitPage> {
  Widget displayWidget = SizedBox.shrink();

  SyncBloc? _syncBloc;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(onWillPop: () async => false, child: displayWidget);
  }

  void exitScreen() {
    //_syncBloc.sync().then((value) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    //});
  }

  @override
  initState() {
    super.initState();
    _syncBloc = new SyncBloc();
    _apiStreamSubscription = apiCallSubscription(_syncBloc!.apiResult, context, widget: widget);
    exitScreen();
  }

  @override
  void dispose() {
    _syncBloc?.dispose();
    _apiStreamSubscription?.cancel();
    super.dispose();
  }
}
