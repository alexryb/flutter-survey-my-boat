import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/logic/bloc/menu_bloc.dart';
import 'package:surveymyboatpro/logic/bloc/storage_bloc.dart';
import 'package:surveymyboatpro/model/menu.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/ui/page/generic/admob_banner_page_state.dart';
import 'package:surveymyboatpro/ui/page/home_page.dart';
import 'package:surveymyboatpro/ui/page/login/identity_page.dart';
import 'package:surveymyboatpro/ui/widgets/about_tile.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/survey_tile.dart';
import 'package:surveymyboatpro/utils/rate_app.dart';
import 'package:surveymyboatpro/utils/uidata.dart';
import 'package:wiredash/wiredash.dart';

abstract class HomePageStateBase<T> extends AdMobBannerPageState<HomePage> with SingleTickerProviderStateMixin {
  static Size? deviceSize;
  Widget displayWidget = progressWithBackground();

  Surveyor? _surveyor;

  void _gotoNextScreen() {
    if (this._surveyor == null) {
      StorageBloc _localStorageBloc = new StorageBloc();
      _localStorageBloc.loadSurveyor().then((_surveyor) {
        if (_surveyor != null) {
          this._surveyor = _surveyor;
          MenuBloc menuBloc = MenuBloc(this._surveyor!);
          menuBloc.menuItems.listen((menuList) {
            setState(() => displayWidget = defaultTargetPlatform == TargetPlatform.iOS ? homeIOS(menuList) : homeScaffold(menuList));
          });
          menuBloc.dispose();
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => IdentityPage()));
        }
      });
      _localStorageBloc.dispose();
    } else {
      MenuBloc menuBloc = MenuBloc(this._surveyor!);
      menuBloc.menuItems.listen((menuList) {
        setState(() => displayWidget = defaultTargetPlatform == TargetPlatform.iOS ? homeIOS(menuList) : homeScaffold(menuList));
      });
      menuBloc.dispose();
    }
    RateApp().load(context);
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return new WillPopScope(onWillPop: _closeApp, child: displayWidget);
  }

  @override
  initState() {
    super.initState();
    _gotoNextScreen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> menuWidgets(List<Menu> menu) {
    List<Widget> widgets = List.empty(growable: true);
    for (Menu m in menu) {
      widgets.add(menuStack(m));
    }
    return widgets;
  }

  //menuStack
  Widget menuStack(Menu menu) => InkWell(
    onTap: () => _showModalBottomSheet(menu),
    splashColor: Colors.white,
    borderRadius: BorderRadius.circular(15),
    child: Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.blueGrey, //Color(0xff6b0808),
      elevation: 2.0,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          menuColor(),
          menuData(menu),
        ],
      ),
    ),
  );

  //stack 2/3
  Widget menuColor() => new Container(
    decoration: BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Color(0xff0c2b20).withOpacity(1),
          blurRadius: 0.0,
        ),
      ],
      borderRadius: BorderRadius.all(Radius.circular(25)),
      border: Border.all(width: 5.0, color: Colors.white),
    ),
  );

  //stack 3/3
  Widget menuData(Menu menu) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        menu.icon,
        color: Colors.white,
      ),
      SizedBox(
        height: 20.0,
      ),
      FittedBox(
        fit: BoxFit.fill,
        child: Text(
          menu.title!,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: deviceSize!.width / 18),
        ),
      ),
    ],
  );

  //appbar
  Widget appBar() => SliverAppBar(
    backgroundColor: Colors.indigo,
    leading: IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: 'Exit',
      onPressed: () {
        confirmExitDialog(context);
      },
    ),
    automaticallyImplyLeading: true,
    pinned: true,
    elevation: 10.0,
    forceElevated: false,
    expandedHeight: 60.0,
    flexibleSpace: FlexibleSpaceBar(
      collapseMode: CollapseMode.none,
      centerTitle: false,
      background: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: UIData.kitGradients)),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 5,
          ),
          FittedBox(fit: BoxFit.contain, child: Text(UIData.appName)),
        ],
      ),
    ),
  );

  //bodygrid
  Widget bodyGrid(List<Menu> menu) => SliverPadding(
    padding: const EdgeInsets.all(5.0),
    sliver: SliverGrid.count(
      crossAxisCount:
      MediaQuery.of(context).orientation == Orientation.portrait
          ? this._surveyor != null ? 2 : 1
          : this._surveyor != null ? 3 : 1,
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
      childAspectRatio: 1.0,
      children: menuWidgets(menu),
    ),
  );

  Widget homeScaffold(List<Menu> menu) => Theme(
    data: Theme.of(context).copyWith(
      canvasColor: Colors.transparent,
    ),
    child: Scaffold(
      backgroundColor: Colors.blueGrey, //Color(0xff6b0808),
      body: CustomScrollView(
        slivers: <Widget>[
          appBar(),
          bodyGrid(menu),
        ],
      ),
      bottomNavigationBar: kIsWeb ? feedbackBottomBar(context, callBackAction: () {  }) : bannerAdWidget(),
    ),
  );

  Widget _bottomHeader() => Ink(
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: UIData.kitGradients2)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 40.0,
            backgroundImage: _surveyor?.defaultImage(Image.asset(UIData.userIcon, fit: BoxFit.none))?.image,
          ),
          SizedBox(
              width: 20
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ApplicationTitle(
              title: this._surveyor != null
                  ? '${this._surveyor?.fullname}'
                  : '',
              subtitle: this._surveyor != null
                  ? '${this._surveyor?.emailAddress}'
                  : '',
              titleTextColor: Colors.white,
            ),
          )
        ],
      ),
    ),
  );

  void _showModalBottomSheet(Menu menu) {
    hideBannerAd();
    showModalBottomSheet(
        context: context,
        builder: (context) => Material(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topLeft: new Radius.circular(15.0),
                    topRight: new Radius.circular(15.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _bottomHeader(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: menu.items?.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: ListTile(
                          title: Text(
                            menu.items![i],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: deviceSize!.height / 40),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            if(menu.items![i] == "Support") {
                              Wiredash.of(context).setUserProperties(
                                userEmail: this._surveyor?.emailAddress,
                              );
                              Wiredash.of(context).show();
                            } else {
                              Navigator.pushNamed(context, "/${menu.items![i]}", );
                            }
                          }),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "About ${UIData.appName}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: deviceSize!.height / 40),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyAboutTile()));
                  },
                ),
              ],
            )));
  }

  Future<bool> _closeApp() {
    confirmExitDialog(context);
    return Future.value(true);
  }

  Widget iosCardBottom(Menu menu, BuildContext context) => Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 40.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 3.0, color: Colors.white),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    menu.image!,
                  ))),
        ),
        SizedBox(
          width: 20.0,
        ),
        Text(
          menu.title!,
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          width: 20.0,
        ),
        FittedBox(
          child: CupertinoButton(
            onPressed: () => _showModalBottomSheet(menu),
            borderRadius: BorderRadius.circular(50.0),
            color: Colors.white,
            child: Text(
              "Go",
              textAlign: TextAlign.left,
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ),
        )
      ],
    ),
  );

  Widget menuIOS(Menu menu, BuildContext context) {
    return Container(
      height: deviceSize!.height / 2,
      decoration: ShapeDecoration(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3.0,
        margin: EdgeInsets.all(16.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                menu.title!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              height: 60.0,
              child: Container(
                width: double.infinity,
                color: menu.menuColor,
                child: iosCardBottom(menu, context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bodyDataIOS(List<Menu> data) => SliverList(
    delegate: SliverChildListDelegate(
        data.map((menu) => menuIOS(menu, context)).toList()),
  );

  Widget homeIOS(List<Menu> menu) => Theme(
    data: ThemeData(
      fontFamily: '.SF Pro Text',
    ).copyWith(canvasColor: Colors.transparent),
    child: CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            border: Border(bottom: BorderSide.none),
            backgroundColor: CupertinoColors.white,
            largeTitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(UIData.appName),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    radius: 15.0,
                    backgroundColor: CupertinoColors.black,
                    child: FlutterLogo(
                      size: 15.0,
                    ),
                  ),
                )
              ],
            ),
          ),
          bodyDataIOS(menu)
        ],
      ),
    ),
  );
}
