import 'dart:async';

import 'package:surveymyboatpro/logic/viewmodel/payment_view_model.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/payment.dart';
import 'package:surveymyboatpro/model/payment_list.dart';
import 'package:rxdart/rxdart.dart';

class PaymentBloc {
  final apiController = BehaviorSubject<FetchProcess>();
  Stream<FetchProcess> get apiResult => apiController.stream;
  
  final paymentsResultController = StreamController<PaymentList>();
  final paymentResultController = StreamController<Payment>();
  final checkoutResultController = StreamController<Payment>();
  final formResultController = StreamController<String>();
  
  Stream<PaymentList> get payments => paymentsResultController.stream;
  Stream<Payment> get payment => paymentResultController.stream;
  Stream<Payment> get checkout => checkoutResultController.stream;
  Stream<String> get form => formResultController.stream;

  Future<void> getPaymentSettings(PaymentViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.getPaymentSettings;

    await model.getPaymentSettings();

    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    paymentResultController.add(model.paymentResult!);

  }

  Future<void> getPaymentForm(PaymentViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.getPaymentForm;

    await model.getPaymentForm();

    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    formResultController.add(model.paymentForm!);

  }

  Future<void> getPayment(PaymentViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.getPayment;

    await model.getPayment();

    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    paymentResultController.add(model.paymentResult!);

  }

  Future<void> getPayments(PaymentViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.getPayments;

    await model.getPayments();

    process.loading = false;
    process.response = model.apiCallResult;

    //for error dialog
    apiController.add(process);
    paymentsResultController.add(model.paymentListResult!);

  }

  Future<void> checkoutPayment(PaymentViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.checkoutPayment;

    await model.checkoutPayment();

    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    checkoutResultController.add(model.paymentResult!);

  }

  Future<void> createPayment(PaymentViewModel model) async {
    FetchProcess process = new FetchProcess(loading: true);
    //for progress loading
    apiController.add(process);
    process.type = ApiType.createPayment;

    await model.createPayment();

    process.loading = false;
    process.response = model.apiCallResult;
    //for error dialog
    apiController.add(process);
    paymentResultController.add(model.paymentResult!);

  }

  void dispose() {
    apiController.close();
    formResultController.close();
    paymentsResultController.close();
    paymentResultController.close();
    checkoutResultController.close();
  }

}
