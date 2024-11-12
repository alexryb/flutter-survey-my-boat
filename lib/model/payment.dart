
import 'resource_type.dart';
import 'survey.dart';

class PaymentResponse {
  Payment? data;
  String? form;

  PaymentResponse({this.data, this.form});

  PaymentResponse.fromJson(Map<String, dynamic> json)
      : data = Payment.fromJson(json['data']);
}

enum PaymentMethod {
   DROP_IN
  ,PAYPAL
  ,CREDIT_CARD
  ,GOOGLE_PAY
}

class Payment {
  final String type = ResourceType.Payment;
  String? createdBy;
  String? createDate;
  String? updatedBy;
  String? updateDate;
  String? paymentGuid;
  String? surveyGuid;
  String? surveyorGuid;
  String? surveyNumber;
  String? clientToken;
  String? paymentNonce;
  String? tokenKey;
  String? transactionId;
  String? transactionNumber;
  String? paymentMethod;
  String? status;
  String? amount;
  String? currency;
  String? provider;
  String? merchandAccountId;
  String? gatewayUrl;
  String? deviceData;
  String? description;
  String? paymentType;
  bool? isDefault;

  Payment(
      {
        this.createdBy,
        this.createDate,
        this.updatedBy,
        this.updateDate,
        this.paymentGuid,
        this.surveyGuid,
        this.surveyorGuid,
        this.surveyNumber,
        this.clientToken,
        this.paymentNonce,
        this.tokenKey,
        this.transactionId,
        this.transactionNumber,
        this.paymentMethod,
        this.status,
        this.amount,
        this.currency,
        this.provider,
        this.merchandAccountId,
        this.gatewayUrl,
        this.deviceData,
        this.description,
        this.paymentType,
        this.isDefault
      });

  Payment.fromSurvey(Survey survey, {this.provider, this.paymentMethod, this.paymentType}) {
    surveyGuid = survey.surveyGuid;
    surveyorGuid = survey.surveyor?.surveyorGuid;
    surveyNumber = survey.surveyNumber;
  }

  Payment.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    createDate = json['createDate'];
    updatedBy = json['updatedBy'];
    updateDate = json['updateDate'];
    paymentGuid = json['paymentGuid'];
    surveyGuid = json['surveyGuid'];
    surveyorGuid = json['surveyorGuid'];
    surveyNumber = json['surveyNumber'];
    transactionId = json['transactionId'];
    transactionNumber = json['transactionNumber'];
    paymentMethod = json['paymentMethod'];
    status = json['status'];
    amount = json['amount'];
    currency = json['currency'];
    provider = json['provider'];
    merchandAccountId = json['merchandAccountId'];
    gatewayUrl = json['gatewayUrl'];
    if(json['clientToken'] != null) {
      clientToken = json['clientToken'];
    }
    if(json['paymentNonce'] != null) {
      paymentNonce = json['paymentNonce'];
    }
    if(json['tokenKey'] != null) {
      tokenKey = json['tokenKey'];
    }
    if(json['deviceData'] != null) {
      deviceData = json['deviceData'];
    }
    if(json['description'] != null) {
      description = json['description'];
    }
    if(json['paymentType'] != null) {
      paymentType = json['paymentType'];
    }
    if(json['isDefault'] != null) {
      isDefault = json['isDefault'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['@type'] = type;
    data['createdBy'] = createdBy;
    data['createDate'] = createDate;
    data['updatedBy'] = updatedBy;
    data['updateDate'] = updateDate;
    data['paymentGuid'] = paymentGuid;
    data['surveyGuid'] = surveyGuid;
    data['surveyorGuid'] = surveyorGuid;
    data['surveyNumber'] = surveyNumber;
    data['transactionId'] = transactionId;
    data['transactionNumber'] = transactionNumber;
    data['paymentMethod'] = paymentMethod;
    data['status'] = status;
    data['amount'] = amount;
    data['currency'] = currency;
    data['provider'] = provider;
    data['merchandAccountId'] = merchandAccountId;
    data['gatewayUrl'] = gatewayUrl;
    if(clientToken != null) {
      data['clientToken'] = clientToken;
    }
    if(paymentNonce != null) {
      data['paymentNonce'] = paymentNonce;
    }
    if(tokenKey != null) {
      data['tokenKey'] = tokenKey;
    }
    if(deviceData != null) {
      data['deviceData'] = deviceData;
    }
    if(description != null) {
      data['description'] = description;
    }
    if(paymentType != null) {
      data['paymentType'] = paymentType;
    }
    if(isDefault != null) {
      data['isDefault'] = isDefault;
    }
    return data;
  }

  @override
  String toString() {
    return
      'Payment{'
          'paymentGuid: $paymentGuid, '
          'surveyGuid: $surveyGuid, '
          'surveyorGuid: $surveyorGuid, '
          'surveyNumber: $surveyNumber, '
          'clientToken: $clientToken, '
          'paymentNonce: $paymentNonce, '
          'tokenKey: $tokenKey, '
          'transactionNumber: $transactionNumber, '
          'status: $status, '
          'amount: $amount, '
          'currency: $currency, '
          'merchandAccountId: $merchandAccountId, '
          'deviceData: $deviceData, '
          'description: $description, '
          'isDefault: $isDefault, '
          'provider: $provider'
      '}';
  }
}

