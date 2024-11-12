import 'package:flutter/material.dart';
import 'audit.dart';
import 'client.dart';
import 'resource_type.dart';
import 'survey_status.dart';
import 'survey_type.dart';
import '../utils/string_utils.dart';
import '../utils/uidata.dart';

import 'checkpoint.dart';
import 'regulation_standard.dart';
import 'sea_trail.dart';
import 'surveyor.dart';
import 'vessel.dart';

class SurveyResponse {
  Survey? data;
  SurveyStatus? status;

  SurveyResponse({this.status, this.data});

  SurveyResponse.fromJson(Map<String, dynamic> json)
      : data = Survey.fromJson(json['data']);
}

class Survey extends Audit {
  final String type = ResourceType.Survey;
  String? surveyGuid;
  String? surveyNumber;
  String? title;
  String? description;
  String? dateOfInspection;
  String? weatherCondition;
  String? dateofReport;
  String? conductOfSurvey;
  String? placeOfSurvey;
  String? surveySite;
  String? scopeOfSurvey;
  String? personsInAttend;
  String? definitionOfTerms;
  String? hinVerification;
  String? summary;
  String? valuation;
  String? vesselDisclosureComments;
  String? comments;
  String? recommendations;
  String? issues;
  String? immediateIssues;
  List<RegulationStandard>? standardsUsed;
  SurveyType? surveyType;
  SurveyStatus? surveyStatus;
  Surveyor? surveyor;
  String? surveyCertification;
  Vessel? vessel;
  SeaTrail? seaTrail;
  Client? client;
  List<CheckPoint>? checkPoints;
  Image? surveyImage;

  Survey({
      this.surveyGuid,
      this.surveyNumber,
      this.title,
      this.description,
      this.dateOfInspection,
      this.weatherCondition,
      this.dateofReport,
      this.conductOfSurvey,
      this.placeOfSurvey,
      this.surveySite,
      this.scopeOfSurvey,
      this.personsInAttend,
      this.definitionOfTerms,
      this.hinVerification,
      this.summary,
      this.valuation,
      this.vesselDisclosureComments,
      this.comments,
      this.recommendations,
      this.issues,
      this.immediateIssues,
      this.standardsUsed,
      this.surveyType,
      this.surveyStatus,
      this.surveyor,
      this.surveyCertification,
      this.vessel,
      this.seaTrail,
      this.client,
      this.checkPoints});

  Image? image() {
    return surveyImage ?? Image.asset(UIData.imbLogo, fit: BoxFit.none);
  }

  Survey.fromJson(Map<String, dynamic> json) {
    surveyGuid = json['surveyGuid'];
    surveyor = json['surveyor'] != null
        ? new Surveyor.fromJson(json['surveyor'])
        : null;
    client = json['client'] != null ? new Client.fromJson(json['client']) : null;
    surveyType = json['surveyType'] != null
        ? new SurveyType.fromJson(json['surveyType'])
        : null;
    surveyStatus = json['surveyStatus'] != null
        ? new SurveyStatus.fromJson(json['surveyStatus'])
        : null;
    title = json['title'];
    surveyNumber = json['surveyNumber'];
    dateOfInspection = json['dateOfInspection'];
    weatherCondition = json['weatherCondition'];
    vessel = json['vessel'] != null ? new Vessel.fromJson(json['vessel']) : null;
    surveySite = json['surveySite'];
    placeOfSurvey = json['placeOfSurvey'];
    description = json['description'];
    scopeOfSurvey = json['scopeOfSurvey'];
    personsInAttend = json['personsInAttend'];
    definitionOfTerms = json['definitionOfTerms'];
    hinVerification = json['hinVerification'];
    if (json['standardsUsed'] != null) {
      standardsUsed = List<RegulationStandard>.empty(growable: true);
      json['standardsUsed'].forEach((v) {
        standardsUsed?.add(new RegulationStandard.fromJson(v));
      });
    }
    if (json['checkPoints'] != null) {
      checkPoints = List<CheckPoint>.empty(growable: true);
      json['checkPoints'].forEach((v) {
        checkPoints?.add(new CheckPoint.fromJson(v));
      });
    }
    json['seaTrail'] != null ? seaTrail = new SeaTrail.fromJson(json['seaTrail']) : null;
    summary = json['summary'];
    comments = json['comments'];
    immediateIssues = json['immediateIssues'];
    issues = json['issues'];
    recommendations = json['recommendations'];
    valuation = json['valuation'];
    vesselDisclosureComments = json['vesselDisclosureComments'];
    surveyCertification = json['surveyCertification'];
    conductOfSurvey = json['conductOfSurvey'];
    fromAuditJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = type;
    data['surveyGuid'] = surveyGuid;
    if (surveyor != null) {
      data['surveyor'] = surveyor?.toJson();
    }
    if (client != null) {
      data['client'] = client?.toJson();
    }
    if (surveyType != null) {
      data['surveyType'] = surveyType?.toJson();
    }
    if (surveyStatus != null) {
      data['surveyStatus'] = surveyStatus?.toJson();
    }
    data['title'] = title;
    data['surveyNumber'] = surveyNumber;
    if (vessel != null) {
      data['vessel'] = vessel?.toJson();
    }
    data['surveySite'] = surveySite;
    data['placeOfSurvey'] = placeOfSurvey;
    data['description'] = description;
    data['scopeOfSurvey'] = scopeOfSurvey;
    data['personsInAttend'] = personsInAttend;
    data['definitionOfTerms'] = definitionOfTerms;
    data['hinVerification'] = hinVerification;
    data['dateOfInspection'] = dateOfInspection;
    data['weatherCondition'] = weatherCondition;
    if (standardsUsed != null) {
      data['standardsUsed'] =
          standardsUsed!.map((v) => v.toJson()).toList();
    }
    if (checkPoints != null) {
      data['checkPoints'] = checkPoints?.map((v) => v.toJson()).toList();
    }
    if (seaTrail != null) {
      data['seaTrail'] = seaTrail?.toJson();
    }
    data['summary'] = summary;
    data['comments'] = comments;
    data['immediateIssues'] = immediateIssues;
    data['issues'] = issues;
    data['recommendations'] = recommendations;
    data['valuation'] = valuation;
    data['vesselDisclosureComments'] = vesselDisclosureComments;
    data['surveyCertification'] = surveyCertification;
    data['conductOfSurvey'] = conductOfSurvey;
    super.toAuditJson(data);
    return data;
  }

  Survey.fromDataJson(Map<String, dynamic> json) {
    surveyGuid = StringUtils.generateGuid();
    surveyType = json['surveyType'] != null
        ? new SurveyType.fromJson(json['surveyType'])
        : null;
    surveyStatus = json['surveyStatus'] != null
        ? new SurveyStatus.fromJson(json['surveyStatus'])
        : null;
    seaTrail = json['seaTrail'] != null
        ? new SeaTrail.fromJson(json['seaTrail'])
        : null;
    title = json['title'];
    surveyNumber = json['surveyNumber'];
    dateOfInspection = json['dateOfInspection'];
    weatherCondition = json['weatherCondition'];
    surveySite = json['surveySite'];
    placeOfSurvey = json['placeOfSurvey'];
    description = json['description'];
    scopeOfSurvey = json['scopeOfSurvey'];
    personsInAttend = json['personsInAttend'];
    definitionOfTerms = json['definitionOfTerms'];
    hinVerification = json['hinVerification'];
    if (json['standardsUsed'] != null) {
      standardsUsed = List<RegulationStandard>.empty(growable: true);
      json['standardsUsed'].forEach((v) {
        v['surveyGuid'] = surveyGuid;
        standardsUsed?.add(new RegulationStandard.fromJson(v));
      });
    }
    if (json['checkPoints'] != null) {
      checkPoints = List<CheckPoint>.empty(growable: true);
      json['checkPoints'].forEach((v) {
        v['surveyGuid'] = surveyGuid;
        checkPoints?.add(new CheckPoint.fromJson(v));
      });
    }
    summary = json['summary'];
    comments = json['comments'];
    immediateIssues = json['immediateIssues'];
    issues = json['issues'];
    recommendations = json['recommendations'];
    valuation = json['valuation'];
    vesselDisclosureComments = json['vesselDisclosureComments'];
    surveyCertification = json['surveyCertification'];
    conductOfSurvey = json['conductOfSurvey'];
    fromAuditJson(json);
  }

  String getScopeOfSurvey() {
    String result = "";
    if(scopeOfSurvey != null) {
      result = scopeOfSurvey!.replaceAll(
          "[:Vessel Year:]", vessel!.modelYear!);
      result = result.replaceAll("[:Vessel Year:]", vessel!.modelYear!);
      result =
          result.replaceAll("[:Vessel Make:]", vessel!.vesselBuilder!);
      result = result.replaceAll(
          "[:Vessel Model/Type:]", vessel!.vesselType!.description!);
      result = result.replaceAll("[:Vessel Name:]", '"${vessel!.name}"');
      result = result.replaceAll("[:Client Name:]",
          "${client!.lastName}, ${client!.firstName}");
      if(dateOfInspection != null) {
        result =
            result.replaceAll("[:Inspection Date:]", dateOfInspection!);
      }
    }
    return result;
  }

  String getSummary() {
    String result = "";
    if(summary != null) {
      result = summary!.replaceAll(
          "[:Vessel Name:]", vessel!.name!);
      if(dateOfInspection != null) {
        result =
            result.replaceAll("[:Inspection Date:]", dateOfInspection!);
      }
    }
    return result;
  }

  String getValuation() {
    String result = "";
    if(valuation != null) {
      result = valuation!.replaceAll(
          "[:Est. Market Value :: Currency:]", "[COMING SOON]");
      result =
          result.replaceAll("[:Est. Market Value :: Text:]", "[COMING SOON]");
      result = result.replaceAll(
          "[:Replacement Cost :: Currency:]", "[COMING SOON]");
      result =
          result.replaceAll("[:Replacement Cost :: Text:]", "[COMING SOON]");
    }
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Survey &&
          runtimeType == other.runtimeType &&
          surveyGuid == other.surveyGuid;

  @override
  int get hashCode => surveyGuid.hashCode;

  @override
  String toString() {
    return 'Type: ${surveyType!.description}\n Title: $title\n Date: $dateOfInspection\n Vessel: ${vessel!.name}';
  }
}