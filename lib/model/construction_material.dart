import 'resource_type.dart';

import 'code.dart';

class ConstructionMaterial extends Code {

  @override
  final String type = ResourceType.ConstructMaterial;

  ConstructionMaterial.fromJson(super.json) : super.fromJson();

}
