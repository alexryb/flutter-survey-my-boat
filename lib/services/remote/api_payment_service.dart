import 'dart:async';

import 'package:surveymyboatpro/model/payment.dart';
import 'package:surveymyboatpro/model/payment_list.dart';
import 'package:surveymyboatpro/services/api_rest_client.dart';
import 'package:surveymyboatpro/services/interfaces/i_payment_service.dart';
import 'package:surveymyboatpro/services/network_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/services/secure_rest_client.dart';

class PaymentService extends NetworkService implements IPaymentService {
  static const _paymentsUrl = "/payments";

  @override
  Future<NetworkServiceResponse<PaymentListResponse>> getPaymentListResponse(String surveyorGuid) async {
    SecureRestClient? restClient = await oauthRestClient;
    String endPointUrl = "$_paymentsUrl?surveyorGuid=$surveyorGuid";
    var result = await restClient?.getRequest<PaymentList>(restApiBaseUrl.toString(), endPointUrl);
    if (result?.mappedResult != null) {
      return new NetworkServiceResponse(
        content: PaymentListResponse(
            data: PaymentList.fromJson(result?.mappedResult)
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<PaymentResponse>> getPaymentFormResponse(String paymentGuid) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.getRequest<String>(restApiBaseUrl.toString(), "$_paymentsUrl/form/$paymentGuid");
    if (result?.mappedResult != null) {
      return new NetworkServiceResponse(
        content: PaymentResponse(
            form: result?.mappedResult
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<PaymentResponse>> getPaymentResponse(String paymentGuid) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.getRequest<Payment>(restApiBaseUrl.toString(), "$_paymentsUrl/$paymentGuid");
    if (result?.mappedResult != null) {
      Payment payment = Payment.fromJson(result?.mappedResult);
      return new NetworkServiceResponse(
        content: PaymentResponse(
            data: payment
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<PaymentResponse>> createPaymentResponse(Payment payment) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.postRequest<Payment>(restApiBaseUrl.toString(), _paymentsUrl, payment);
    if (result?.mappedResult != null) {
      Payment payment0 = Payment.fromJson(result?.mappedResult);
      return new NetworkServiceResponse(
        content: PaymentResponse(
            data: payment0
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<PaymentResponse>> checkoutPaymentResponse(Payment payment) async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.putRequest<Payment>(restApiBaseUrl.toString(), "$_paymentsUrl/${payment.paymentGuid!}", payment);
    if (result?.mappedResult != null) {
      Payment payment0 = Payment.fromJson(result?.mappedResult);
      return new NetworkServiceResponse(
        content: PaymentResponse(
            data: payment0
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }

  @override
  Future<NetworkServiceResponse<PaymentResponse>> getPaymentSettingsResponse() async {
    SecureRestClient? restClient = await oauthRestClient;
    var result = await restClient?.getRequest<Payment>(restApiBaseUrl.toString(), "$_paymentsUrl/settings");
    if (result?.mappedResult != null) {
      Payment payment = Payment.fromJson(result?.mappedResult);
      return new NetworkServiceResponse(
        content: PaymentResponse(
            data: payment
        ),
        success: result?.networkServiceResponse.success,
      );
    }
    return new NetworkServiceResponse(
        success: result?.networkServiceResponse.success,
        message: result?.networkServiceResponse.message);
  }
  
}
