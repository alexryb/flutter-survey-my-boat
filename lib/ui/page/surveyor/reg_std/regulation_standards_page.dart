import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/viewmodel/reg_stds_view_model.dart';
import 'package:surveymyboatpro/model/regulation_standard.dart';
import 'package:surveymyboatpro/ui/page/home_page.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_drawer.dart';
import 'package:surveymyboatpro/utils/uidata.dart';
import 'package:url_launcher/url_launcher.dart';

class RegulationStandardsPage extends StatefulWidget {
  const RegulationStandardsPage({super.key});


  @override
  State<StatefulWidget> createState() {
    return new RegulationStandardsPageState();
  }
}

class RegulationStandardsPageState extends State<RegulationStandardsPage> {
  static Size? deviceSize;
  Widget? displayWidget = progressWithBackground();

  RegulationStandardsViewModel? _model;
  
  Widget _standardsBodyList(List<RegulationStandard> certificates) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _certificatesCard(certificates[index]),
          );
        }, childCount: certificates.length),
      );

  Widget _certificatesCard(RegulationStandard certificate) {
    return Container(
      color: Colors.yellow,
      child: Card(
        elevation: 2.0,
        color: Colors.teal,
        borderOnForeground: true,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _standardColumn(certificate),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new RichText(
                text: new TextSpan(
                  children: [
                    new TextSpan(
                      text: 'Go to the authority web site',
                      style: new TextStyle(
                          color: Colors.white, fontSize: deviceSize!.height / 40),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          launch(certificate.url!);
                        },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            certificate.imageSrc != null
                ? Image.network(
                    certificate.imageSrc!,
                    fit: BoxFit.cover,
                  )
                : Container(),
            countryColumn(certificate),
            authorityColumn(certificate),
          ],
        ),
      ),
    );
  }

  Widget countryColumn(RegulationStandard certificate) => FittedBox(
    fit: BoxFit.contain,
    child: OverflowBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Issued Country: ${certificate.issuedCountryCode}',
              style: TextStyle(fontFamily: UIData.ralewayFont, color: Colors.white),
            ),
          ],
        ),
      ],
    ),
  );

  Widget authorityColumn(RegulationStandard certificate) => FittedBox(
    fit: BoxFit.contain,
    child: OverflowBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Authority: ${certificate.issuedAuthorityName}',
              style: TextStyle(fontFamily: UIData.ralewayFont, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ],
    ),
  );


  Widget _standardColumn(RegulationStandard surveyorCertificate) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      surveyorCertificate.title!,
                      style: TextStyle(
                        color: Colors.black87,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: deviceSize!.height / 40,
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ],
      );

  Widget _appBar() => SliverAppBar(
    backgroundColor: Colors.black,
    elevation: 2.0,
    title: Text("Small Crafts Regulation Standards"),
    forceElevated: true,
    pinned: true,
    floating: true,
    //bottom: bottomBar(),
  );

  Widget _standardsBody(List<RegulationStandard> certificates) => Scaffold(
        backgroundColor: Colors.blueGrey,
        drawer: CommonDrawer(),
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          slivers: [
            _appBar(),
            _standardsBodyList(certificates),
          ],
        ),
        //floatingActionButton: _addCertificationActionButton(),
      );

  Future<bool> _homePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    return new Future.value(true);
  }

  Widget _addCertificationActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      child: new Icon(
        Icons.add,
        //color: Colors.blue,
      ),
    );
  }

  void _gotoNextScreen() {
    setState(() => displayWidget = _standardsBody(_model!.getRegulationStandardItems()));
  }

  @override
  initState() {
    super.initState();
    _model = new RegulationStandardsViewModel();
    _gotoNextScreen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     { deviceSize = MediaQuery.of(context).size; }
    return new WillPopScope(onWillPop: _homePage, child: displayWidget!);
  }
}
