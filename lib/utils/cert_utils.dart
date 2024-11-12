import 'dart:io';

import 'package:path/path.dart';

/// Util for byte list representation of certificate.
///
/// You should set certificate name in args.
/// Certificate should be in certs folder.
///
/// Call example:
/// dart main.dart cert.pem
///
/// Exit codes:
/// 0 - success
/// 1 - error
void main(List<String> arguments) {
  exitCode = 0;

  var certFile = File("certs/examplecom.pem");

  if (!certFile.existsSync()) {
    exitCode = 1;

    throw Exception('File certificate ${certFile.path} not found.');
  }

  String fileNameWithoutExt = basenameWithoutExtension(certFile.path);

  var cert = certFile.readAsBytesSync();
  var res = "List<int> $fileNameWithoutExt = <int>[${cert.join(', ')}];";
  var resFile = File("lib/res/${fileNameWithoutExt}_cert.dart");

  if (!resFile.existsSync()) {
    resFile.createSync(recursive: true);
  }

  resFile.writeAsString(res);
}