import 'package:flutter/material.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ClientDescEdit extends StatelessWidget {

  Client? client;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ClientDescEdit({required Key key, this.client}) : super(key: key);

  static Size? deviceSize;

  var _phoneMaskFormatter = new MaskTextInputFormatter(
      mask: "(###) ###-####", filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    { deviceSize = MediaQuery.of(context).size; }
    return new WillPopScope(
        onWillPop: () async => true,
        child: SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Visibility(
                child: Column(children: <Widget>[
                  SizedBox(
                    width: (deviceSize!.width * 0.65),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                      initialValue: client!.firstName,
                      decoration: InputDecoration(
                        hintText: "First Name",
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: Icon(Icons.person_outline, color: Colors.white,),
                      ),
                      onChanged: (un) => this.client!.firstName = un.trim(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required field";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: (deviceSize!.width * 0.65),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                      initialValue: client!.lastName,
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: Icon(Icons.person_outline, color: Colors.white,),
                      ),
                      onChanged: (un) => this.client!.lastName = un.trim(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required field";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: (deviceSize!.width * 0.65),
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      initialValue: client!.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email Address",
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: Icon(Icons.email, color: Colors.white,),
                      ),
                      onChanged: (un) => this.client!.emailAddress = un.trim(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required field";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: (deviceSize!.width * 0.65),
                    child: TextFormField(
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                      initialValue: client!.phoneNumber,
                      inputFormatters: [_phoneMaskFormatter],
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: Icon(Icons.phone, color: Colors.white,),
                      ),
                      onChanged: (un) => this.client!.phoneNumber = un.trim(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required field";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: (deviceSize!.width * 0.65),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      keyboardType: TextInputType.streetAddress,
                      style: TextStyle(color: Colors.white),
                      initialValue: client!.addressLine,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: "Address",
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: Icon(Icons.location_city, color: Colors.white,),
                      ),
                      onChanged: (un) => this.client!.addressLine = un.trim(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required field";
                        }
                        return null;
                      },
                    ),
                  ),
                ]),
              ),
            ],
          ),
        )
    );
  }
}
