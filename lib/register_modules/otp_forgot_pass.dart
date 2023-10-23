// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../apis/webapi.dart';
import '../common/custom_dialogue.dart';
import '../common/header_widget.dart';
import '../common/theme_helper.dart';
import 'login_page.dart';

class ForgotPassVerificationPage extends StatefulWidget {
  final String otpMail;
  const ForgotPassVerificationPage({Key? key, required this.otpMail})
      : super(key: key);

  @override
  _ForgotPassVerificationPageState createState() =>
      _ForgotPassVerificationPageState();
}

class _ForgotPassVerificationPageState
    extends State<ForgotPassVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _pinSuccess = false;
  String? _otpController;

  _verifyOTP() async {
    print("OTP in verify: " + _otpController.toString());
    var otp = {
      'verify_code': _otpController.toString(),
      'password': _password.text,
      'c_password': _confirm_password.text,
    };
    CustomProgressDialogue.progressDialogue(context);
    var resOTP = await CallApi().postData(otp, 'forgot-password');
    var bodyOTP = jsonDecode(resOTP.body);
    print("otp: " + bodyOTP.toString());
    if (bodyOTP['success'] == true) {
      print("congratulations");
      print(bodyOTP['message'].toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          bodyOTP['message'].toString(),
          style: TextStyle(fontSize: 16),
        ),
      ));
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else if (bodyOTP['success'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          bodyOTP['message'].toString(),
          style: TextStyle(fontSize: 16),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          bodyOTP['message'].toString(),
          style: TextStyle(fontSize: 16),
        ),
      ));
      Navigator.of(context, rootNavigator: true).pop('dialog');
      print("Code msg: " + bodyOTP['message'].toString());
    }
  }

  String? password;
  String? confirm_password;
  bool _obscureText = false;
  bool _obscureConfirmPass = false;
  final _password = TextEditingController();
  final _confirm_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(
                    _headerHeight, true, Icons.privacy_tip_outlined),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verification',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Enter the verification code we just sent you on your email address.',
                              style: TextStyle(
                                  // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            OTPTextField(
                              length: 5,
                              width: 300,
                              fieldWidth: 50,
                              style: TextStyle(fontSize: 30),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onCompleted: (pin) {
                                setState(() {
                                  _pinSuccess = true;
                                });
                              },
                              onChanged: (String code) {
                                _otpController = code;
                                print("Code: " + code.toString());
                                print("OTP: " + _otpController.toString());
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: TextFormField(
                                controller: _password,
                                obscureText: !_obscureText,
                                decoration: ThemeHelper().textInputDecoration(
                                  // "Password*",
                                  "Password",
                                  "Enter your password",
                                  Icon(Icons.lock_outline),
                                  GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    }),
                                    child: Icon(_obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                ),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Please enter your password";
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  password = val;
                                },
                                onChanged: (val) {
                                  password = _password.text;
                                  print("Password: " + password.toString());
                                },
                              ),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                controller: _confirm_password,
                                obscureText: !_obscureConfirmPass,
                                decoration: ThemeHelper().textInputDecoration(
                                  // "Confirm Password*",
                                  "Confirm Password",
                                  "Enter Password again",
                                  Icon(Icons.lock_outline),
                                  GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        _obscureConfirmPass =
                                            !_obscureConfirmPass;
                                      });
                                    }),
                                    child: Icon(_obscureConfirmPass
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                ),
                                validator: (val) {
                                  print("Value: " + val.toString());
                                  print("Password: " + password.toString());
                                  if (val!.isEmpty) {
                                    return "Please confirm your password";
                                  } else if (val != password) {
                                    return "Your password doesn't match";
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  confirm_password = val;
                                },
                                onChanged: (val) {
                                  confirm_password =
                                      _confirm_password.toString();
                                  print("Confirmed Password: " +
                                      confirm_password.toString());
                                  // if (confirm_password != password) {
                                  //   return "Password does not match";
                                  // }
                                  // return null;
                                },
                              ),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 50.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "If you didn't receive a code! ",
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Resend',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemeHelper().alartDialog(
                                                "Successful",
                                                "Verification code resend successful.",
                                                context);
                                          },
                                        );
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration: _pinSuccess
                                  ? ThemeHelper().buttonBoxDecoration(context)
                                  : ThemeHelper().buttonBoxDecoration(
                                      context, "#AAAAAA", "#757575"),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Verify".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: _pinSuccess
                                    ? () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();

                                          _verifyOTP();
                                        }
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
