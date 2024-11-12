import 'resource_type.dart';

import 'code.dart';

class ConstructionMaterial extends Code {

  final String type = ResourceType.ConstructMaterial;

  ConstructionMaterial.fromJson(Map<String, dynamic> json) : super.fromJson(json);

}
