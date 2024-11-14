import 'resource_type.dart';

import 'code.dart';

class CheckPointFixPriority extends Code {

  CheckPointFixPriority() : super(type: ResourceType.CheckPointFixPriority);

  CheckPointFixPriority.Critical() : super.Named(ResourceType.CheckPointFixPriority,"CRITICAL", "Critical Issue", null, null);
  CheckPointFixPriority.Major() : super.Named(ResourceType.CheckPointFixPriority, "MAJOR", "Major Issue", null, null);
  CheckPointFixPriority.Minor() : super.Named(ResourceType.CheckPointFixPriority, "MINOR", "Minor Issue", null, null);
  CheckPointFixPriority.NoIssue() : super.Named(ResourceType.CheckPointFixPriority, "NAN", "No Issue", null, null);

  CheckPointFixPriority.fromJson(super.json) : super.fromJson();

}
