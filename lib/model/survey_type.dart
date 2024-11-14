import 'resource_type.dart';

import 'code.dart';

class SurveyType extends Code {

  SurveyType() : super (type: ResourceType.SurveyType);

  SurveyType.PreBuyer() : super.Named(ResourceType.SurveyType, "PRE_BUYER", "Pre-Purchase for Buyer", null, null);
  SurveyType.ValueFinance() : super.Named(ResourceType.SurveyType, "VALUE_FIN", "Condition & Value Finance", null, null);
  SurveyType.ValueInsurance() : super.Named(ResourceType.SurveyType, "VALUE_INS", "Condition & Value Insurance", null, null);
  SurveyType.PreOwner() : super.Named(ResourceType.SurveyType, "PRE_OWNER", "Pre-Sale for Owner", null, null);
  SurveyType.OwnerMaint() : super.Named(ResourceType.SurveyType, "OWNER_MNT", "Pre-Maintenance for Owner", null, null);
  SurveyType.TradeIn() : super.Named(ResourceType.SurveyType, "TRADE_IN", "Trade-in", null, null);

  SurveyType.fromJson(super.json) : super.fromJson();



}
