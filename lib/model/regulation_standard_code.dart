import 'resource_type.dart';

import 'code.dart';

class RegulationStandardCode extends Code {

  @override
  final String type = ResourceType.RegulationStandard;

  RegulationStandardCode.fromJson(super.json) : super.fromJson();

}
