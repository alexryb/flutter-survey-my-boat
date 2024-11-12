import 'dart:io';

import '../di/dependency_injection.dart';

class AppHttpOverrides extends HttpOverrides {

  final List<String> allowedHosts = List<String>.of({
    Injector.SETTINGS!.hostname,
    "api.wiredash.io"
  });

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    context ??= SecurityContext(
        withTrustedRoots: false
    );
    HttpClient httpClient = super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // throw SSLException("Certificate rejected by the server !!!");
        //print("HTTP Callback ${host}:${port}");
        return allowedHosts.contains(host);
      }
      ;
    return httpClient;
  }
}