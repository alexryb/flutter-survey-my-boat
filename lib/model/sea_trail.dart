import 'audit.dart';
import 'checkpoint_status.dart';
import 'resource_type.dart';

class SeaTrail extends Audit {
  final String type = ResourceType.SeaTrail;
  String? seaTrailGuid;
  String? surveyGuid;
  String? dateConducted;
  String? weatherCondition;
  String? comments;
  String? engineStartup;
  String? attendedPersons;
  String? vibrations;
  String? engineControlOperation;
  String? steeringTest;
  String? enginePerformance;
  String? vesselLoad;
  CheckPointStatus? status;

  SeaTrail({
      this.seaTrailGuid,
      this.surveyGuid,
      this.dateConducted,
      this.weatherCondition,
      this.comments,
      this.engineStartup,
      this.attendedPersons,
      this.vibrations,
      this.engineControlOperation,
      this.steeringTest,
      this.enginePerformance,
      this.vesselLoad});

  SeaTrail.fromJson(Map<String, dynamic> json) {
    seaTrailGuid = json['seaTrailGuid'];
    surveyGuid = json['surveyGuid'];
    dateConducted = json['dateConducted'];
    weatherCondition = json['weatherCondition'];
    comments = json['comments'];
    engineStartup = json['engineStartup'];
    attendedPersons = json['attendedPersons'];
    vibrations = json['vibrations'];
    engineControlOperation = json['engineControlOperation'];
    steeringTest = json['steeringTest'];
    enginePerformance = json['enginePerformance'];
    vesselLoad = json['vesselLoad'];
    status = json['status'] != null ? new CheckPointStatus.fromJson(json['status']) : CheckPointStatus.NotStarted();
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = type;
    data['seaTrailGuid'] = seaTrailGuid;
    data['surveyGuid'] = surveyGuid;
    data['dateConducted'] = dateConducted;
    data['weatherCondition'] = weatherCondition;
    data['comments'] = comments;
    data['engineStartup'] = engineStartup;
    data['attendedPersons'] = attendedPersons;
    data['vibrations'] = vibrations;
    data['engineControlOperation'] = engineControlOperation;
    data['steeringTest'] = steeringTest;
    data['enginePerformance'] = enginePerformance;
    data['vesselLoad'] = vesselLoad;
    if (status != null) {
      data['status'] = status?.toJson();
    }
    super.toAuditJson(data);
    return data;
  }

}
