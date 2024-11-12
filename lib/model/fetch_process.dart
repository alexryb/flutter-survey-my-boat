import '../services/network_service_response.dart';

enum ApiType {
  performLogin
  , changePassword
  , recoverPassword
  , signUpUserAccount
  , signUpSurveyor
  , getCodes
  , getSurveyor
  , saveSurveyor
  , getClient
  , getClients
  , createClient
  , saveClient
  , getSurvey
  , getSurveys
  , saveSurvey
  , archiveSurvey
  , saveSurveyAndHome
  , saveCheckPoint
  , createSurvey
  , getVesselCatalog
  , saveSettings
  , syncDataRemote
  , getAppFeeds
  , generateReport
  , downloadReport
  , getPayments
  , getPayment
  , getPaymentForm
  , getPaymentSettings
  , createPayment
  , checkoutPayment
}

class FetchProcess<T> {
  ApiType? type;
  bool? loading;
  NetworkServiceResponse<T>? response;

  FetchProcess({this.loading, this.response, this.type});
}
