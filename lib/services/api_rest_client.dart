import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../di/dependency_injection.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

final restApiBaseUrl = Injector.SETTINGS?.apiBaseUrl;

class ApiRestClient {

  Map<String, String> headers = {
    "Content-Type": 'application/json',
    "Accept": '*/*',
    "Application-Version": "PRO"
  };

  Future<MappedNetworkServiceResponse<T>> getRequest<T>(String baseUrl, String resourcePath) async {
    Uri uri = Uri.parse(baseUrl);
    var response = await (http.get((baseUrl + resourcePath) as Uri, headers: headers));
    return _processResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> postRequest<T>(String baseUrl, String resourcePath, dynamic data) async {
    Uri uri = Uri.parse(baseUrl);
    var content = json.encoder.convert(data);
    var response = await (http.post((baseUrl + resourcePath) as Uri, body: content, headers: headers));
    return _processResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> putRequest<T>(String baseUrl, String resourcePath, dynamic data) async {
    Uri uri = Uri.parse(baseUrl);
    var content = json.encoder.convert(data);
    headers.putIfAbsent("If-Match", () => "1");
    var response = await (http.put((baseUrl + resourcePath) as Uri, body: content, headers: headers));
    return _processResponse<T>(response);
  }

  Future<MappedNetworkServiceResponse<T>> deleteRequest<T>(String baseUrl, String resourcePath) async {
    Uri uri = Uri.parse(baseUrl);
    headers.putIfAbsent("If-Match", () => "1");
    var response = await (http.delete((baseUrl + resourcePath) as Uri, headers: headers));
    return _processResponse<T>(response);
  }
  
  MappedNetworkServiceResponse<T> _processResponse<T>(http.Response response) {
    if (!((response.statusCode < 200) ||
        (response.statusCode >= 300) ||
        (response.body == null))) {
      var jsonResult = response.body;
      try {
        dynamic resultClass = jsonDecode(jsonResult);
        return new MappedNetworkServiceResponse<T>(
            mappedResult: resultClass,
            networkServiceResponse: new NetworkServiceResponse<T>(
                success: true));
      } catch (e) {
        return new MappedNetworkServiceResponse<T>(
            mappedResult: jsonResult,
            networkServiceResponse: new NetworkServiceResponse<T>(
                success: true));
      }
    } else {
      var errorResponse = response.body;
      // if(response.statusCode == 401) {
      //   throw AuthorizationException('${response.statusCode}', "The session is expired. Please reload the page to refresh the session", null);
      // }
      return new MappedNetworkServiceResponse<T>(
          networkServiceResponse: new NetworkServiceResponse<T>(
              success: false,
              message: "(${response.statusCode}) ${errorResponse.toString()}"));
    }
  }
}