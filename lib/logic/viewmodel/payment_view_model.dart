import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/viewmodel/base_view_model.dart';
import 'package:surveymyboatpro/model/payment.dart';
import 'package:surveymyboatpro/model/payment_list.dart';
import 'package:surveymyboatpro/services/interfaces/i_payment_service.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';

class PaymentViewModel extends BaseViewModel {

  String? paymentGuid;
  String? surveyorGuid;
  String? paymentForm;
  Payment? paymentResult;
  PaymentList? paymentListResult;
  NetworkServiceResponse? apiCallResult;

  PaymentViewModel();
  PaymentViewModel.Payment({this.paymentGuid, this.paymentResult, this.surveyorGuid});

  Future<Null> getPaymentSettings() async {
    IPaymentService service = await new Injector(Flavor.REMOTE).paymentService;
    NetworkServiceResponse<PaymentResponse> result = await service.getPaymentSettingsResponse();
    apiCallResult = result;
    if(result.content != null) paymentResult = result.content?.data;
  }

  Future<Null> getPaymentForm() async {
    IPaymentService service = await new Injector(Flavor.REMOTE).paymentService;
    NetworkServiceResponse<PaymentResponse> result = await service.getPaymentFormResponse(paymentGuid!);
    apiCallResult = result;
    if(result.content != null) paymentForm = result.content?.form;
  }

  Future<Null> getPayment() async {
    IPaymentService service = await new Injector(Flavor.REMOTE).paymentService;
    NetworkServiceResponse<PaymentResponse> result = await service.getPaymentResponse(paymentGuid!);
    apiCallResult = result;
    if(result.content != null) paymentResult = result.content?.data;
  }

  Future<Null> getPayments() async {
    IPaymentService service = await new Injector(Flavor.REMOTE).paymentService;
    NetworkServiceResponse<PaymentListResponse> result = await service.getPaymentListResponse(surveyorGuid!);
    apiCallResult = result;
    if(result.content != null) paymentListResult = result.content?.data;
  }

  Future<Null> createPayment() async {
    IPaymentService service = await new Injector(Flavor.REMOTE).paymentService;
    NetworkServiceResponse<PaymentResponse> result = await service.createPaymentResponse(paymentResult!);
    apiCallResult = result;
    if(result.content != null) paymentResult = result.content?.data;
  }

  Future<Null> checkoutPayment() async {
    IPaymentService service = await new Injector(Flavor.REMOTE).paymentService;
    NetworkServiceResponse<PaymentResponse> result = await service.checkoutPaymentResponse(paymentResult!);
    apiCallResult = result;
    if(result.content != null) paymentResult = result.content?.data;
  }
}
