import 'resource_type.dart';

import 'code.dart';

class VesselDocumentType extends Code {

  VesselDocumentType() : super(type: ResourceType.VesselDocument);

  VesselDocumentType.License() : super.Named(ResourceType.VesselDocument, "LICENSE", "License", null, null);

  VesselDocumentType.fromJson(super.json) : super.fromJson();

}
