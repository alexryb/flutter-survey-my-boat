class SurveySearchFilter {
  String? surveyNumber;
  String? surveyStatus;
  String? vesselGuid;
  String? clientGuid;
  String? surveyorGuid;

  @override
  String toString() {
    String params = "?";
    String amp = "";
    if(surveyNumber != null)  {
      params = '$params${amp}surveyNumber=$surveyNumber';
      amp = "&";
    }
    if(surveyStatus != null)  {
      params = '$params${amp}surveyStatus=$surveyStatus';
      amp = "&";
    }
    if(clientGuid != null) {
      params = '$params${amp}client_clientGuid=$clientGuid&clientGuid=$clientGuid';
      amp = "&";
    }
    if(vesselGuid != null) {
      params = '$params${amp}vessel_vesselGuid=$vesselGuid&vesselGuid=$vesselGuid';
      amp = "&";
    }
    if(surveyorGuid != null) {
      params = '$params${amp}surveyor_surveyorGuid=$surveyorGuid&surveyorGuid=$surveyorGuid';
      amp = "&";
    }
    return params;
  }

  void appendStatus(String newStatus) {
    if(surveyStatus == null) {
      surveyStatus = newStatus;
    } else {
      surveyStatus = "$surveyStatus,$newStatus";
    }
  }
}
