import 'resource_type.dart';

import 'code.dart';

class CheckPointCondition extends Code {

  CheckPointCondition() : super(type: ResourceType.CheckPointCondition);

  CheckPointCondition.NotAvailable() : super.Named(ResourceType.CheckPointCondition, "NA", "Not Available", null, null);
  CheckPointCondition.New() : super.Named(ResourceType.CheckPointCondition, "NEW", "Like New", null, null);
  CheckPointCondition.Servicable() : super.Named(ResourceType.CheckPointCondition, "SERVICABLE", "Serviceable", null, null);
  CheckPointCondition.Fair() : super.Named(ResourceType.CheckPointCondition, "FAIR", "Fair", null, null);
  CheckPointCondition.Replace() : super.Named(ResourceType.CheckPointCondition, "REPLACE", "Require Replacement", null, null);

  CheckPointCondition.fromJson(Map<String, dynamic> json) : super.fromJson(json);

}
