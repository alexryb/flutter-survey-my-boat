import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';

class BaseViewModel {

  Flavor _flavor = Flavor.LOCAL;

  Future<Flavor> get flavor async {
    await _init();
    return _flavor;
  }

  Future<void> _init() async {
    if(kIsWeb) {
      _flavor = Flavor.REMOTE;
      return;
    }
    bool? apiCall = Injector.SETTINGS?.onlineMode;
    if(apiCall != null && apiCall) {
      apiCall = await _checkApiConnection();
      if(!apiCall!) {
        Injector.SETTINGS?.onlineMode = false;
      }
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _flavor = Flavor.LOCAL;
      Injector.SETTINGS?.onlineMode = false;
      //print("No connectivity... Use local");
    }
    else if (connectivityResult == ConnectivityResult.mobile) {
      if(!Injector.SETTINGS!.syncOnDataNetwork! && apiCall!) {
        _flavor = Flavor.REMOTE;
        //print("Data usage approved... Use remote");
      } else if (!apiCall!) {
        _flavor = Flavor.LOCAL;
        Injector.SETTINGS?.onlineMode = false;
        //print("Data usage no api available");
      }
    }
    else if (connectivityResult == ConnectivityResult.wifi) {
      if(!apiCall!) {
        _flavor = Flavor.REMOTE;
        //print("Wifi connection... Use remote");
      } else {
        _flavor = Flavor.LOCAL;
        Injector.SETTINGS?.onlineMode = false;
        //print("Wifi connection... Use local no api available");
      }
    }
  }

  Future<bool?> _checkApiConnection() async {
    ApiRestClient httpClient = new ApiRestClient();
    bool? connected = false;
    try {
      var response = await httpClient.getRequest(Injector.SETTINGS?.apiBaseUrl, "/actuator/health");
      connected = response.networkServiceResponse.success;
    } on SocketException catch (_) {
      connected = false;
    }
    return connected;
  }

}