import 'resource_type.dart';

import 'code.dart';

class CheckPointStatus extends Code {

  CheckPointStatus() : super(type: ResourceType.CheckPointStatus);

  CheckPointStatus.NotStarted() : super.Named(ResourceType.CheckPointStatus, "NOTSTRT", "Not Started", null, null);
  CheckPointStatus.UnCompleted() : super.Named(ResourceType.CheckPointStatus,"UNCOMP", "Uncompleted", null, null);
  CheckPointStatus.Completed() : super.Named(ResourceType.CheckPointStatus,"COMP", "Completed", null, null);
  CheckPointStatus.NotAvailable() : super.Named(ResourceType.CheckPointStatus,"NA", "Not Available", null, null);

  CheckPointStatus.fromJson(Map<String, dynamic> json) : super.fromJson(json);

}
