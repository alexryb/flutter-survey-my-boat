import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/services/network_service_response.dart';
import 'package:surveymyboatpro/ui/page/exit_page.dart';
import 'package:surveymyboatpro/ui/page/settings/settings_page.dart';
import 'package:surveymyboatpro/ui/widgets/file_source_dialog.dart';
import 'package:surveymyboatpro/utils/uidata.dart';
import 'package:wiredash/wiredash.dart';

class PopupContent extends StatefulWidget {
  final Widget? content;

  const PopupContent({
    super.key,
    this.content,
  });

  @override
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.content,
    );
  }
}

class PopupLayout extends ModalRoute {
  double? top;
  double? bottom;
  double? left;
  double? right;
  Color? bgColor;
  final Widget? child;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor =>
      bgColor ?? Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => false;

  PopupLayout(
      {Key? key,
      this.bgColor,
      @required this.child,
      this.top,
      this.bottom,
      this.left,
      this.right});

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    top ??= 10;
    bottom ??= 20;
    left ??= 20;
    right ??= 20;

    return GestureDetector(
      onTap: () {
        // call this method here to hide soft keyboard
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        // This makes sure that text and other content follows the material style
        type: MaterialType.transparency,
        //type: MaterialType.canvas,
        // make sure that the overlay content is not cut off
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: bottom!,
          left: left!,
          right: right!,
          top: top!),
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

Widget dataNotFoundWidget(String text) {
  return Container(
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 25,
          color: Colors.black54,
        ),
      ),
    ),
  );
}

Future<void> fetchApiResult(BuildContext context, NetworkServiceResponse snapshot) async {
  String message =
      snapshot == null ? "Fatal error. Nature unknown" : snapshot.message!;
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(UIData.error),
      content: Text(message),
      actions: <Widget>[
        MaterialButton (
          textColor: Colors.black,
          onPressed: () {
            Navigator.pop(context);
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: Text(UIData.ok)
        )
      ],
    ),
  );
}

Future<bool> fetchValidationResult(BuildContext context, NetworkServiceResponse snapshot) async {
  String message =
  snapshot == null ? "Fatal error. Nature unknown" : snapshot.message!;
  bool result = false;
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(UIData.error),
      content: Text(message),
      actions: <Widget>[
        MaterialButton(
          textColor: Colors.black,
          onPressed: () {
            Navigator.pop(context);
            result = true;
          },
          child: Text(UIData.accept)
        ),
        MaterialButton(
          textColor: Colors.black,
          onPressed: () {
            Navigator.pop(context);
            result = false;
          },
          child: Text(UIData.cancel)
        )
      ],
    ),
  );
  return result;
}

confirmExitDialog(BuildContext context) {
  String message = "You are about to close the application. Are you sure?";
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(UIData.confirm),
      content: Text(message),
      actions: <Widget>[
        MaterialButton(
          textColor: Colors.black,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ExitPage()));
          },
          child: Text(UIData.yes),
        ),
        MaterialButton(
          textColor: Colors.black,
          onPressed: () => Navigator.pop(context),
          child: Text(UIData.no),
        )
      ],
    ),
  );
}

notConnectedDialog(BuildContext context) {
  String message = "Not connected to internet";
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Warning"),
      content: Text(message),
      actions: <Widget>[
        MaterialButton(
          textColor: Colors.black,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage()));
          },
          child: Text("Please check Settings"),
        ),
      ],
    ),
  );
}

showSuccess(BuildContext context, String message, IconData icon) {
  showBottomBarDialog(context, message);
  Future.delayed(Duration(seconds: 2)).then((value) {
    Navigator.pop(context);
  });
}

showProgress(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.amber),
              backgroundColor: Colors.blue,
              strokeWidth: 10,
            ),
          ));
}

hideProgress(BuildContext context) {
  Navigator.pop(context);
}

progressNoBackground() {
  return Center(child: CircularProgressIndicator());
}

progressWithBackground() {
  return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Image.asset(
              (UIData.imbLogo),
              fit: BoxFit.scaleDown,
            ),
          ],
        ),
      ),
  );
}

void selectDate(
    BuildContext context, TextEditingController controller) async {
  String? pickMonth;
  String? pickDay;
  DateTime initialDate = new DateTime.now();
  DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: new DateTime(initialDate.year - 1),
      lastDate: new DateTime(initialDate.year + 1));
  if (picked != null) {
    pickMonth = picked.month < 10 ? '0${picked.month}' : '${picked.month}';
    pickDay = picked.day < 10 ? '0${picked.day}' : '${picked.day}';
    controller.text = '${picked.year}-$pickMonth-$pickDay';
  }
}

showPopup(BuildContext context, Widget widget, String title, {
      BuildContext? popupContext,
      final double? topOffset = 50,
      final double? leftOffset = 30,
      final double? rightOffset = 30,
      final double? bottomOffset = 120,
      final VoidCallback? callBack
    }) {
  Navigator.push(
    context,
    PopupLayout(
      top: topOffset,
      left: leftOffset,
      right: rightOffset,
      bottom: bottomOffset,
      child: Container(
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context); //close the popup
                    callBack!();
                  },
                );
              }), systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: widget,
          ),
        ),
      ),
    ),
  );
}

showHelpScreen(BuildContext context, String title, String file) {
  showModal(
    context: context,
    configuration: FadeScaleTransitionConfiguration(),
    builder: (context) {
      return AnimatedFileSourceDialog(
        mdFileName: 'help/$file',
      );
    },
  );
}

Widget showBottomBarDialog(BuildContext context, String message, {bool wait = false}) {
  Widget container = Container(
    height: 50,
    color: Colors.black,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            message,
            style: new TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.amber
            ),
          ),
          if(wait) CircularProgressIndicator(),
        ],
      ),
    ),
  );
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return container;
    },
  );
  return container;
}

Widget feedbackBottomBar(BuildContext context, {String label = "Send Feedback", required VoidCallback callBackAction}) => BottomAppBar(
  clipBehavior: Clip.antiAlias,
  shape: CircularNotchedRectangle(),
  child: Ink(
    height: 50.0,
    decoration: new BoxDecoration(
        gradient: new LinearGradient(colors: UIData.kitGradients)),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: double.infinity,
          child: new InkWell(
            radius: 10.0,
            splashColor: Colors.black,
            onTap: () => callBackAction ?? _openWiredash(context),
            child: Center(
              child: new Text(
                label,
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);

void _openWiredash(BuildContext context) {
  Wiredash.of(context).setBuildProperties(
    buildNumber: "1.0.0",
    buildVersion: Injector.SETTINGS?.version,
  );
  Wiredash.of(context).show();
}

extension on WiredashController {
  void setBuildProperties({required String buildNumber, String? buildVersion}) {

  }
}

bool validateSubmit(GlobalKey<FormState> formKey, GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) {
  FocusScope.of(context).unfocus();
  if (formKey.currentState != null) {
    bool isValid = formKey.currentState!.validate();
    if (isValid) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 10),
        content: Text(
          "Requred fieds are empty. Please correct",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            backgroundColor: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        ),
        // action: SnackBarAction(
        //   textColor: Colors.black,
        //   label: "Close",
        //   onPressed: () {},
        // ),
      ));
      return false;
    }
    return false;
  }
  return false;
}
