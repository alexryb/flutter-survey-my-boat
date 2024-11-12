import 'resource_type.dart';

import 'code.dart';

class VesselDocument {
  final String type = ResourceType.VesselDocument;
  String documentGuid;
  Code documentType;
  String name;
  String comments;

  VesselDocument(
      this.documentGuid, this.documentType, this.name, this.comments);
}
