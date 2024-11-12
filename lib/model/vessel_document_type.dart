import 'resource_type.dart';

import 'code.dart';

class VesselDocumentType extends Code {

  VesselDocumentType() : super(type: ResourceType.VesselDocument);

  VesselDocumentType.License() : super.Named(ResourceType.VesselDocument, "LICENSE", "License", null, null);

  VesselDocumentType.fromJson(Map<String, dynamic> json) : super.fromJson(json);

}
