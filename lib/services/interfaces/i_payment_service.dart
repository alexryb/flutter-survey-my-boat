import 'dart:async';

import 'package:surveymyboatpro/model/payment.dart';
import 'package:surveymyboatpro/model/payment_list.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

abstract class IPaymentService {
  Future<NetworkServiceResponse<PaymentListResponse>> getPaymentListResponse(String surveyorGuid);
  Future<NetworkServiceResponse<PaymentResponse>> getPaymentResponse(String paymentGuid);
  Future<NetworkServiceResponse<PaymentResponse>> getPaymentFormResponse(String paymentGuid);
  Future<NetworkServiceResponse<PaymentResponse>> createPaymentResponse(Payment payment);
  Future<NetworkServiceResponse<PaymentResponse>> checkoutPaymentResponse(Payment payment);
  Future<NetworkServiceResponse<PaymentResponse>> getPaymentSettingsResponse();
}
