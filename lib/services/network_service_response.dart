class NetworkServiceResponse<T> {
  T? content;
  bool? success;
  bool? validate;
  String? message;

  NetworkServiceResponse({this.content, this.success, this.validate = true, this.message,});
}

class MappedNetworkServiceResponse<T> {
  dynamic mappedResult;
  NetworkServiceResponse<T> networkServiceResponse;
  MappedNetworkServiceResponse(
      {this.mappedResult, required this.networkServiceResponse});
}
