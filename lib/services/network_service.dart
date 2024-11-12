import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/secure_rest_client.dart';

abstract class NetworkService {

  StorageBloc _localStorageBloc = new StorageBloc();
  static SecureRestClient? _oauthRestClient;

  MappedNetworkServiceResponse<T> errorResponse<T>(var result) {
    return MappedNetworkServiceResponse<T> (
        networkServiceResponse: new NetworkServiceResponse<T>(
            content: null,
            success: false,
            message: result.networkServiceResponse.message)
    );
  }

  MappedNetworkServiceResponse<T> exceptionResponse<T>(var error, String message) {
    return new MappedNetworkServiceResponse<T>(
        networkServiceResponse: new NetworkServiceResponse<T>(
            content: null,
            success: false,
            message: "${error.description}. ${message}" )
    );
  }

  StorageBloc get localStorageBloc => _localStorageBloc;

  Future<SecureRestClient?> get oauthRestClient async {
    if(_oauthRestClient == null) {
      LoginData? userData = await _localStorageBloc.loadCredentials();
      _oauthRestClient = new SecureRestClient(userData!.login!);
    }
    return _oauthRestClient;
  }
}
