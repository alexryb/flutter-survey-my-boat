
import 'package:flutter/foundation.dart';
import '../model/settings.dart';
import '../services/interfaces/i_app_feed_service.dart';
import '../services/interfaces/i_client_service.dart';
import '../services/interfaces/i_code_service.dart';
import '../services/interfaces/i_login_service.dart';
import '../services/interfaces/i_payment_service.dart';
import '../services/interfaces/i_report_service.dart';
import '../services/interfaces/i_signup_service.dart';
import '../services/interfaces/i_storage_service.dart';
import '../services/interfaces/i_survey_service.dart';
import '../services/interfaces/i_surveyor_service.dart';
import '../services/interfaces/i_vessel_service.dart';
import '../services/local/local_app_feed_service.dart';
import '../services/local/local_client_service.dart';
import '../services/local/local_code_service.dart';
import '../services/local/local_report_service.dart';
import '../services/local/local_storage_service.dart';
import '../services/local/local_survey_service.dart';
import '../services/local/local_surveyor_service.dart';
import '../services/local/local_vessel_service.dart';
import '../services/local/mock_login_service.dart';
import '../services/local/mock_signup_service.dart';
import '../services/remote/api_app_feed_service.dart';
import '../services/remote/api_client_service.dart';
import '../services/remote/api_code_service.dart';
import '../services/remote/api_login_service.dart';
import '../services/remote/api_payment_service.dart';
import '../services/remote/api_report_service.dart';
import '../services/remote/api_sign_up_service.dart';
import '../services/remote/api_storage_service.dart';
import '../services/remote/api_survey_service.dart';
import '../services/remote/api_surveyor_service.dart';
import '../services/remote/api_vessel_service.dart';

enum Flavor { LOCAL, REMOTE }

Flavor getFlavor(String value) {
  Flavor result = Flavor.values.firstWhere((e) => e.toString() == value, orElse: () => Flavor.LOCAL);
  return result;
}

//Simple DI
class Injector {

  static Settings _SETTINGS = _loadSettings();

  Flavor? _flavor;

  Injector(Flavor flavor) {
    _flavor = flavor;
  }

  static Settings? get SETTINGS {
    return _SETTINGS;
  }

  static Settings _loadSettings() {
    _SETTINGS = Settings.environmentSettings;
    return _SETTINGS;
  }

  Future<ILoginService> get loginService async {
    _loadSettings();
    switch (_flavor) {
      case Flavor.LOCAL:
        return MockLoginService();
      default:
        return LoginService();
    }
  }

  Future<ISignUpService> get signUpService async {
    _loadSettings();
    switch (_flavor) {
      case Flavor.LOCAL:
        return MockSignUpService();
      default:
        return SignUpService();
    }
  }

  Future<ISurveyService> get surveyService async {
    _loadSettings();
    switch (_flavor) {
      case Flavor.LOCAL:
        return LocalSurveyService();
      default:
        return SurveyService();
    }
  }

  Future<ISurveyorService> get surveyorService async {
    _loadSettings();
    switch (_flavor) {
      case Flavor.LOCAL:
        return LocalSurveyorService();
      default:
        return SurveyorService();
    }
  }

  Future<ICodeService> get codeService async {
    _loadSettings();
    switch (_flavor) {
      case Flavor.LOCAL:
        return LocalCodeService();
      default:
        return CodeService();
    }
  }

  Future<IVesselService> get vesselService async {
    _loadSettings();
    switch (_flavor) {
      case Flavor.LOCAL:
        return LocalVesselService();
      default:
        return VesselService();
    }
  }

  Future<IClientService> get clientService async {
    _loadSettings();
    switch (_flavor) {
      case Flavor.LOCAL:
        return LocalClientService();
      default:
        return ClientService();
    }
  }

  Future<IAppFeedService> get appFeedService async {
    _loadSettings();
    switch (_flavor) {
      case Flavor.LOCAL:
        return LocalAppFeedService();
      default:
        return AppFeedService();
    }
  }

  Future<IReportService> get reportService async {
    _loadSettings();
    switch (_flavor) {
      case Flavor.LOCAL:
        return LocalReportService();
      default:
        return ReportService();
    }
  }

  Future<IStorageService> get storageService async {
    _loadSettings();
    switch (kIsWeb) {
      case true:
        return StorageService();
      default:
        return LocalStorageService();
    }
  }

  Future<IPaymentService> get paymentService async {
    _loadSettings();
    return PaymentService();
  }
}
