import 'resource_type.dart';

import 'inspection_area_attribute.dart';
import 'regulation_standard.dart';

class InspectionArea {
  final String type = ResourceType.InspectionArea;
  String inspectionAreaGuid;
  String code;
  String description;
  int dafaultSortOrder;
  List<InspectionAreaAttribute> attributes;
  InspectionArea parentArea;
  List<RegulationStandard> regulationStandards;

  InspectionArea(
      this.inspectionAreaGuid,
      this.code,
      this.description,
      this.dafaultSortOrder,
      this.attributes,
      this.parentArea,
      this.regulationStandards);
}
