class ClientSearchFilter {
  String? clientGuid;
  String? surveyorGuid;
  String? emailAddress;

  @override
  String toString() {
    String params = "?";
    String amp = "";
    if(surveyorGuid != null)  {
      params = '$params${amp}surveyNumber=$surveyorGuid';
      amp = "&";
    }
    if(clientGuid != null) {
      params = '$params${amp}client_clientGuid=$clientGuid';
      amp = "&";
    }
    if(emailAddress != null) {
      params = '$params${amp}emailAddress=$emailAddress';
      amp = "&";
    }
    return params;
  }
}
