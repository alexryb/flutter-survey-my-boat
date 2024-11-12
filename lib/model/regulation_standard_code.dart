import 'resource_type.dart';

import 'code.dart';

class RegulationStandardCode extends Code {

  final String type = ResourceType.RegulationStandard;

  RegulationStandardCode.fromJson(Map<String, dynamic> json) : super.fromJson(json);

}
