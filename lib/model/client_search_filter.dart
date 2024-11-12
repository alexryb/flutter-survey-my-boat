class ClientSearchFilter {
  String? clientGuid;
  String? surveyorGuid;
  String? emailAddress;

  @override
  String toString() {
    String _params = "?";
    String _amp = "";
    if(surveyorGuid != null)  {
      _params = _params + '${_amp}surveyNumber=$surveyorGuid';
      _amp = "&";
    }
    if(clientGuid != null) {
      _params = _params + '${_amp}client_clientGuid=$clientGuid';
      _amp = "&";
    }
    if(emailAddress != null) {
      _params = _params + '${_amp}emailAddress=$emailAddress';
      _amp = "&";
    }
    return _params;
  }
}
