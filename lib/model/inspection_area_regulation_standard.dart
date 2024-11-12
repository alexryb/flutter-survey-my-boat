import 'package:flutter/material.dart';
import 'resource_type.dart';

import 'regulation_standard.dart';

class InspectionAreaRegulationStandard {
  final String type = ResourceType.RegulationStandard;
  RegulationStandard regulationStandard;
  String regulationStandardGuid;
  String inspectionAreaGuid;
  String sectionNumber;
  String description;
  Image image;
  String note1;
  String note2;
  String note3;
  String note4;
  String note5;

  InspectionAreaRegulationStandard(
      this.regulationStandard,
      this.regulationStandardGuid,
      this.inspectionAreaGuid,
      this.sectionNumber,
      this.description,
      this.image,
      this.note1,
      this.note2,
      this.note3,
      this.note4,
      this.note5);
}
