import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/services/remote/api_storage_service.dart';
import 'package:surveymyboatpro/ui/page/login/identity_page.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LogoutPageState();
  }
}

class LogoutPageState extends State<LogoutPage> {

  Widget displayWidget = progressWithBackground();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(onWillPop: () async => false, child: displayWidget);
  }

  void logoutScreen() {
    if(!kIsWeb) {
      StorageBloc localStorageBloc = new StorageBloc();
      localStorageBloc.deleteCodes();
      localStorageBloc.deleteSurveys();
      localStorageBloc.deleteSurveyor();
      localStorageBloc.deleteClients();
      localStorageBloc.deleteCredentials();
      localStorageBloc.deleteSettings();
      if (Injector.SETTINGS != null) {
        Injector.SETTINGS?.logout = true;
        localStorageBloc.saveSettings(Injector.SETTINGS!);
      }
      localStorageBloc.dispose();
    } else {
      StorageService.storages.clear();
    }
    setState(() => displayWidget = IdentityPage());
  }

  @override
  initState() {
    super.initState();
    logoutScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
