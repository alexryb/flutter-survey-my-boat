import 'resource_type.dart';

import 'code.dart';

class SurveyStatus extends Code {

  SurveyStatus() : super(type: ResourceType.SurveyStatus);

  SurveyStatus.NotStarted() : super.Named(ResourceType.SurveyStatus, "NOTSTRT", "Not Started", null, null);
  SurveyStatus.UnCompleted() : super.Named(ResourceType.SurveyStatus,"UNCOMP", "Uncompleted", null, null);
  //Paid and archived
  SurveyStatus.Completed() : super.Named(ResourceType.SurveyStatus,"COMP", "Completed", null, null);
  SurveyStatus.Paid() : super.Named(ResourceType.SurveyStatus,"PAID", "Paid", null, null);
  //Means completed buut not paid
  SurveyStatus.Archived() : super.Named(ResourceType.SurveyStatus,"ARCHIVED", "Archived", null, null);
  SurveyStatus.NotAvailable() : super.Named(ResourceType.SurveyStatus,"NA", "Not Available", null, null);

  SurveyStatus.fromJson(Map<String, dynamic> json) : super.fromJson(json);

}
