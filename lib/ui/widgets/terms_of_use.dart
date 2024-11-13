import 'package:animations/animations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:surveymyboatpro/ui/widgets/file_source_dialog.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RichText(
        textAlign: TextAlign.center,
        textScaleFactor: 1.5,
        text: TextSpan(
          text: "By using the I.M.B., you are agreeing to our\n",
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: "Terms & Conditions",
              style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.black12),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showModal(
                    context: context,
                    configuration: FadeScaleTransitionConfiguration(),
                    builder: (context) {
                      return AnimatedFileSourceDialog(
                        mdFileName: 'help/tac.md',
                      );
                    },
                  );
                },
            ),
            TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy",
              style: TextStyle(fontWeight: FontWeight.bold, backgroundColor: Colors.black12),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AnimatedFileSourceDialog(
                        mdFileName: 'help/privacy.md',
                      );
                    },
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}