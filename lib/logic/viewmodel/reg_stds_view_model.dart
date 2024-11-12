import 'package:surveymyboatpro/model/regulation_standard.dart';

class RegulationStandardsViewModel {
  List<RegulationStandard>? regulationStandardsItems;

  RegulationStandardsViewModel({this.regulationStandardsItems});
  
  getRegulationStandardItems() {
    return regulationStandardsItems = <RegulationStandard>[
      RegulationStandard(
          title: "Canada Shipping Act (CSA2001)",
          description: "All regulations under the Act including “Small Vessel Regulations, \"Construction Standards for Small Vessels\" – TP1332E and \"International Regulations for Preventing Collisions at Sea, 1972 with Canadian Modifications\" are mandatory.",
          issuedCountryCode: "CA",
          issuedAuthorityCode: "TC",
          issuedAuthorityName: "Transport Canada",
          url: "https://tc.canada.ca/en/marine-transportation/marine-safety/construction-standards-small-vessels-2010-tp-1332-e"
      ),
      RegulationStandard(
          title: "US Code of Federal Regulations",
          description: "For vessels to be USCG Documented, State Registered or exported to the USA, United States Code of Federal Regulations Title 33 and 46 requirements will be applied",
          issuedCountryCode: "USA",
          issuedAuthorityCode: "FR",
          issuedAuthorityName: "US Code of Federal Regulations",
          url: 'https://www.govinfo.gov/help/cfr'
      ),
      RegulationStandard(
          title: "ABYC® \"Standards and Technical Information Reports for Small Craft\"",
          description: "ABYC® \"Standards and Technical Information Reports for Small Craft\" are generally voluntary with many standards incorporated into TP1332E",
          issuedCountryCode: "USA",
          issuedAuthorityCode: "ABYC",
          issuedAuthorityName: "American Boat and Yacht Council®",
          url: "https://abycinc.org/default.aspx"
      ),
      RegulationStandard(
        title: "Fire Protection Standard for Pleasure and Commercial Motor Craft",
        description: "Fire Protection Standard for Pleasure and Commercial Motor Craft\" are generally a voluntary with some of its standards mandated by TP1332E.",
        issuedCountryCode: "USA",
        issuedAuthorityCode: "NFPA",
        issuedAuthorityName: "National Fire Protection Association - NFPA302",
        url: "https://www.nfpa.org/codes-and-standards/all-codes-and-standards/list-of-codes-and-standards/detail?code=302"
      ),
    ];
  }
}
