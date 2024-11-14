import 'resource_type.dart';

import 'code.dart';

class VesselType extends Code {

  VesselType() : super(type: ResourceType.VesselType);

  VesselType.Sailboat() : super.Named(ResourceType.VesselType, "SAILBOAT", "Sail Boat", null, null);
  VesselType.Powerboat() : super.Named(ResourceType.VesselType, "POWERBOAT", "Power Boat", null, null);

  VesselType.fromJson(super.json) : super.fromJson();

}
