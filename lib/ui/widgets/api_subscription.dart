import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/client_list.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/model/login.dart';
import 'package:surveymyboatpro/model/payment.dart';
import 'package:surveymyboatpro/model/sign_up.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/survey_status.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/ui/page/home_page.dart';
import 'package:surveymyboatpro/ui/page/login/logout_page.dart';
import 'package:surveymyboatpro/ui/page/profile/profile_create_page.dart';
import 'package:surveymyboatpro/ui/page/profile/profile_view_page.dart';
import 'package:surveymyboatpro/ui/page/survey/create_survey_page.dart';
import 'package:surveymyboatpro/ui/page/survey/survey_page.dart';
import 'package:surveymyboatpro/ui/page/survey/surveys_page.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/clients_page.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';

apiCallSubscription(Stream<FetchProcess> apiCallResult, BuildContext context, {required Widget widget}) {
  StorageBloc localStorage = new StorageBloc();
  apiCallResult.listen((FetchProcess p) async {
    if (p.loading!) {
      showProgress(context);
    } else {
      hideProgress(context);
      if (p.response == null || p.response?.success == false) {
        fetchApiResult(context, p.response!).then((value) {
          NetworkServiceResponse<dynamic> res = p.response!;
          switch (p.type) {
            case ApiType.performLogin:
              break;
            case ApiType.signUpUserAccount:
              break;
            case ApiType.changePassword:
              break;
            case ApiType.recoverPassword:
              break;
            default:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => widget));
              break;
          }
                });
      } else {
        switch (p.type) {
          case ApiType.signUpUserAccount:
            NetworkServiceResponse<SignUpResponse>? res = p.response as NetworkServiceResponse<SignUpResponse>?;
            if(res!.success! && res.validate!) {
              LoginData signUpData = res.content!.data!;
              await localStorage.saveCredentials(signUpData);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      ProfileCreatePage.withLogin(signUpData.login!)));
            }
            break;
          case ApiType.signUpSurveyor:
            NetworkServiceResponse<SignUpResponse>? res = p.response as NetworkServiceResponse<SignUpResponse>?;
            if(res!.success!) {
              LoginData signUpData = res.content!.data!;
              await localStorage.saveCredentials(signUpData);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
              showSuccess(context, "You signed up successfully",
                  FontAwesomeIcons.check);
            }
            break;
          case ApiType.performLogin:
            NetworkServiceResponse<LoginResponse>? res = p.response as NetworkServiceResponse<LoginResponse>?;
            LoginData? loginData = res?.content!.data!;
            if(res!.validate!) {
              await localStorage.saveCredentials(loginData!);
              Injector.SETTINGS?.logout = false;
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            } else {
              await localStorage.saveCredentials(loginData!);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      ProfileCreatePage.withLogin(loginData.login!)));
            }
            break;
          case ApiType.changePassword:
            NetworkServiceResponse<LoginResponse>? res = p.response as NetworkServiceResponse<LoginResponse>?;
            LoginData? loginData = res?.content!.data!;
            if(res!.success!) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LogoutPage()));
              showSuccess(context, "Password changed successfully. Please Log In", FontAwesomeIcons.check);
            }
            break;
          case ApiType.recoverPassword:
            NetworkServiceResponse<LoginResponse>? res = p.response as NetworkServiceResponse<LoginResponse>?;
            if(res!.success!) {
              showSuccess(context, "Please check SMS with new temporary password", FontAwesomeIcons.check);
            }
            break;
          case ApiType.saveSurveyor:
            NetworkServiceResponse<SurveyorResponse>? res = p.response as NetworkServiceResponse<SurveyorResponse>?;
            if(res!.success!) {
              Surveyor surveyor = res.content!.data!;
              surveyor.inSync = true;
              await localStorage.saveSurveyor(surveyor);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileViewPage()));
              showSuccess(
                  context, "Profile saved successfuly", FontAwesomeIcons.check);
            }
            break;
          case ApiType.getCodes:
            NetworkServiceResponse<dynamic>? res = p.response;
            await localStorage.saveCodes(res!.content.data);
            break;
          case ApiType.getAppFeeds:
            break;
          case ApiType.getClients:
            NetworkServiceResponse<ClientListResponse>? res = p.response as NetworkServiceResponse<ClientListResponse>?;
            if(res!.success!) {
              ClientList clients = res.content!.data;
              if (clients.elements.isNotEmpty) {
                await localStorage.saveClients(clients);
              }
            }
            break;
          case ApiType.getClient:
            NetworkServiceResponse<ClientResponse>? res = p.response as NetworkServiceResponse<ClientResponse>?;
            Client? client = res?.content!.data!;
            client?.inSync = true;
            await localStorage.saveClient(client!.clientGuid!, client);
            break;
          case ApiType.saveClient:
            NetworkServiceResponse<ClientResponse>? res = p.response as NetworkServiceResponse<ClientResponse>?;
            if((res!.success!)) {
              Client client = res.content!.data!;
              await localStorage.saveClient(client.clientGuid!, client);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClientsPage()));
              showSuccess(
                  context, "Client saved successfuly", FontAwesomeIcons.check);
            }
            break;
          case ApiType.getSurvey:
            NetworkServiceResponse<SurveyResponse>? res = p.response as NetworkServiceResponse<SurveyResponse>?;
            if(res!.success!) {
              Survey survey = res.content!.data!;
              await localStorage.saveSurvey(survey.surveyGuid!, survey);
            }
            break;
          case ApiType.getSurveys:
            break;
          case ApiType.saveCheckPoint:
            NetworkServiceResponse<SurveyResponse>? res = p.response as NetworkServiceResponse<SurveyResponse>?;
            if(res!.success!) {
              Survey survey = res.content!.data!;
              await localStorage.saveSurvey(survey.surveyGuid!, survey);
            }
            break;
          case ApiType.createSurvey:
            NetworkServiceResponse<SurveyResponse>? res = p.response as NetworkServiceResponse<SurveyResponse>?;
            if(res!.validate!) {
              Survey survey = res.content!.data!;
              survey.inSync = res.validate!;
              await localStorage.saveSurvey(survey.surveyGuid!, survey);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SurveysPage()));
              showSuccess(context, "Survey created successfuly",
                  FontAwesomeIcons.check);
            } else {
              Survey survey = res.content!.data!;
              fetchValidationResult(context, p.response!).then((value) {
                if(!value) {
                  survey.client = new Client();
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateSurveyPage(survey: survey)));
              });
            }
            break;
          case ApiType.saveSurvey:
            NetworkServiceResponse<SurveyResponse>? res = p.response as NetworkServiceResponse<SurveyResponse>?;
            if(res!.success!) {
              Survey survey = res.content!.data!;
              survey.inSync = res.validate!;
              await localStorage.saveSurvey(survey.surveyGuid!, survey);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SurveyPage.Survey(
                              surveyGuid: survey.surveyGuid!, survey: survey)));
              showSuccess(
                  context, " Survey saved successfuly ${!survey.inSync? 'on the device' : ''} ", FontAwesomeIcons.check);
            }
            break;
          case ApiType.saveSurveyAndHome:
            NetworkServiceResponse<SurveyResponse>? res = p.response as NetworkServiceResponse<SurveyResponse>?;
            if(res!.success!) {
              Survey survey = res.content!.data!;
              survey.inSync = res.validate!;
              await localStorage.saveSurvey(survey.surveyGuid!, survey);
              Navigator.push(
                  context,
                    MaterialPageRoute(
                      builder: (context) => HomePage()));
              showSuccess(
                  context, " Survey saved successfuly ${!survey.inSync? 'on the device' : ''} ", FontAwesomeIcons.check);
            }
            break;
          case ApiType.archiveSurvey:
            NetworkServiceResponse<SurveyResponse>? res = p.response as NetworkServiceResponse<SurveyResponse>?;
            if(res!.success!) {
              showSuccess(
                  context, "Survey status updated", FontAwesomeIcons.check);
            } else {
              showSuccess(
                  context, "Something went wrong", FontAwesomeIcons.check);
            }
            break;
          case ApiType.getVesselCatalog:
            break;
          case ApiType.saveSettings:
            showSuccess(context, "Settings saved successfuly", FontAwesomeIcons.check);
            break;
          case ApiType.syncDataRemote:
            showSuccess(context, "Data sync with remote server \n completed successfuly", FontAwesomeIcons.check);
            break;
          case ApiType.getPayment:
            break;
          case ApiType.getPayments:
            break;
          case ApiType.createPayment:
            break;
          case ApiType.checkoutPayment:
            NetworkServiceResponse<PaymentResponse>? res = p.response as NetworkServiceResponse<PaymentResponse>?;
            if(res!.success!) {
              Payment payment = res.content!.data!;
              await localStorage.loadSurvey(payment.surveyGuid!).then((survey) async {
                survey.surveyStatus = SurveyStatus.Paid();
                await localStorage.saveSurvey(survey.surveyGuid!, survey);
              });
            }
            break;
          case ApiType.generateReport:
            break;
          case ApiType.downloadReport:
            break;
          case null:
            // TODO: Handle this case.
          case ApiType.getSurveyor:
            // TODO: Handle this case.
          case ApiType.createClient:
            // TODO: Handle this case.
          case ApiType.getPaymentForm:
            // TODO: Handle this case.
          case ApiType.getPaymentSettings:
            // TODO: Handle this case.
        }
      }
    }
  });
}
