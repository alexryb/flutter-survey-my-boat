import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

List<String> testDeviceIds = !kReleaseMode ?
    <String>["38DCF0C50B0AB38E7E22BB27458B2A0F"] : List.empty(growable: true);

AdRequest adRequestInfo = AdRequest(
  keywords: <String>[
    'boat',
    'travel',
    'sailboat',
    'powerboat',
    'outboard',
    'ocean',
    'sea',
    'fishing',
    'adventure',
    'survey',
    'marine',
    'inspection',
    'surveyor',
    'professional',
    'yachting',
    'yacht world',
    'yacht racing',
    'world cup',
    'sea life',
    'marine diesel engine',
    'marine electronics',
    'boat builder',
    'wooden boat',
    'lake',
    'lake fishing',
    'pocket yacht',
    'boat trailer',
    'sea food',
    'island',
    'sail maker',
    'paradise',
    'marine',
    'yacht sale',
    'boat parts',
    'boat paint'
  ],
  contentUrl: 'http://www.pcmarinesurveys.com/Marine%20Survey%20101.htm',
  //testDevices: testDeviceIds, // Android emulators are considered test devices
);