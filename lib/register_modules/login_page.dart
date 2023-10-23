// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unrelated_type_equality_checks, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apis/google_signin_api.dart';
import '../apis/webapi.dart';
import '../common/custom_dialogue.dart';
import '../common/header_widget.dart';
import '../common/theme_helper.dart';
import '../home_page.dart';
import 'forgot_password_page.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  // const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = false;
  String? email;
  String? password;
  final _email = TextEditingController();
  final _password = TextEditingController();

  String redirectUrl = 'https://cognitiveitsolutions.ca/';
  String clientId = '778v2uycvu7iz5';
  String clientSecret = 'D2HFibr1oxqVXnIs';
  var response;
  Future googlesignIn() async {
    CustomProgressDialogue.progressDialogue(context);
    //progressDialogue(context);
    response = await GoogleSignInApi.login();
    print("${response!.displayName}");
    print("loginnres" + response.toString());
    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signin Failed'),
        ),
      );
      Navigator.of(context, rootNavigator: true).pop('dialog');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signin Success'),
        ),
      );
      _socialResponseData(
          response!.displayName, response.email, "Google", response.id);
      Navigator.of(context, rootNavigator: true).pop('dialog');
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => MyApp(resp)));
    }
  }

  _loginApp() async {
    CustomProgressDialogue.progressDialogue(context);
    var logCreds = {
      'email': _email.text,
      'password': _password.text,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var resLogin = await CallApi().postData(logCreds, 'login');
    var bodyOTP = jsonDecode(resLogin.body);
    var token, name, id;
    print("Login body: " + bodyOTP.toString());
    if (resLogin.statusCode == 200) {
      debugPrint("bodyData: " + bodyOTP['data'].toString());
      if (bodyOTP['data'] == null) {
        debugPrint('data is null printed');
        Navigator.of(context, rootNavigator: true).pop('dialog');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            bodyOTP['message'].toString(),
            style: TextStyle(fontSize: 16),
          ),
        ));
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Welcome to AI Pro Resume',
            style: TextStyle(fontSize: 16),
          ),
        ));
        token = bodyOTP['data']['token'].toString();
        name = bodyOTP['data']['name'].toString();
        id = bodyOTP['data']['id'].toString();
        prefs.setString("session_token", token);
        prefs.setString("user_name", name);
        prefs.setBool("session", true);
        prefs.setString("user_id", id);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Something went wrong",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }

  var token, userName, u_id;
  _socialResponseData(name, email, provider, provider_id) async {
    print("Inside social response");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CallApi _api = CallApi();
    var data = {
      'name': name,
      'email': email,
      'provider': provider,
      'provider_id': provider_id,
    };
    var result = await _api.postData(data, 'login/social-response');
    var body = jsonDecode(result.body);
    token = body['data']['token'].toString();
    userName = body['data']['user_name'].toString();
    u_id = body['data']['id'].toString();
    print("Token in google: " + token);
    print("User Name in google: " + userName);
    print("Id in google: " + u_id);
    prefs.setString("session_token", token);
    prefs.setString("user_name", userName);
    prefs.setString("user_id", u_id);
    prefs.setInt("googleSign", 1);
    print("userID: " + prefs.getString("user_id").toString());
    print("google Response: " + body.toString());
    var sToken = prefs.getString("session_token");
    var sName = prefs.getString("user_name");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  UserObject? user;
  bool logoutUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: EdgeInsets.fromLTRB(
                    20, 10, 20, 10), // This will be the login form
                child: Column(
                  children: [
                    Text(
                      'Welcome',
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Signin into your account',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                              controller: _email,
                              decoration: ThemeHelper().textInputDecoration(
                                'Email Address',
                                'Enter your email',
                                Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                email = val;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            child: TextFormField(
                              controller: _password,
                              obscureText: !_obscureText,
                              decoration: ThemeHelper().textInputDecoration(
                                'Password',
                                'Enter your password',
                                Icon(Icons.lock_outline),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(_obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter some text';
                                } else if (value.length < 6) {
                                  return 'Password be atleast 6 characters long';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                password = val;
                              },
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()),
                                );
                              },
                              child: Text(
                                "Forgot your password?",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'Sign In'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  _loginApp();
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            //child: Text('Don\'t have an account? Create'),
                            child: Text.rich(TextSpan(children: [
                              TextSpan(text: "Don\'t have an account? "),
                              TextSpan(
                                text: 'Create',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationPage()));
                                  },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ])),
                          ),
                          SizedBox(height: 30.0),
                          Text(
                            "Or create account using social media",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: googlesignIn,
                                icon: FaIcon(
                                  FontAwesomeIcons.googlePlus,
                                  size: 35,
                                  color: HexColor("#EC2D2F"),
                                ),
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: FaIcon(
                                  FontAwesomeIcons.facebook,
                                  size: 35,
                                  color: HexColor("#3E529C"),
                                ),
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              // IconButton(
                              //   onPressed: () {},
                              //   icon: FaIcon(
                              //     FontAwesomeIcons.twitter,
                              //     size: 23,
                              //     color: HexColor("#00acee"),
                              //   ),
                              // ),
                              // SizedBox(
                              //   width: 30.0,
                              // ),
                              // LinkedInButtonStandardWidget(onTap: onTap)
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (final BuildContext context) =>
                                          LinkedInUserWidget(
                                        appBar: AppBar(
                                          title: const Text(
                                              'Sign in With Linkedin'),
                                        ),
                                        destroySession: logoutUser,
                                        redirectUrl: redirectUrl,
                                        clientId: clientId,
                                        clientSecret: clientSecret,
                                        projection: const [
                                          ProjectionParameters.id,
                                          ProjectionParameters
                                              .localizedFirstName,
                                          ProjectionParameters
                                              .localizedLastName,
                                          ProjectionParameters.firstName,
                                          ProjectionParameters.lastName,
                                          ProjectionParameters.profilePicture,
                                        ],
                                        onError: (final UserFailedAction e) {
                                          print('Error: ${e.toString()}');
                                          print(
                                              'Error: ${e.stackTrace.toString()}');
                                        },
                                        onGetUserProfile:
                                            (final UserSucceededAction
                                                linkedInUser) {
                                          print(
                                            'Access token ${linkedInUser.user.token.accessToken}',
                                          );

                                          print(
                                              'User id: ${linkedInUser.user.userId}');

                                          user = UserObject(
                                            firstName: linkedInUser.user
                                                .firstName!.localized!.label,
                                            lastName: linkedInUser.user
                                                .lastName!.localized!.label,
                                            email: linkedInUser
                                                .user
                                                .email!
                                                .elements![0]
                                                .handleDeep!
                                                .emailAddress,
                                            profileImageUrl: linkedInUser
                                                .user
                                                .profilePicture!
                                                .displayImageContent!
                                                .elements![0]
                                                .identifiers![0]
                                                .identifier,
                                          );

                                          setState(() {
                                            logoutUser = false;
                                          });
                                          _socialResponseData(
                                              user!.firstName.toString(),
                                              user!.email,
                                              "LinkedIn",
                                              linkedInUser.user.userId);
                                          // Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyHomePage()));
                                        },
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                  print('First: ${user?.firstName} ');
                                  print('Last: ${user?.lastName} ');
                                  print('Email: ${user?.email}');
                                  print(
                                      'Profile image: ${user?.profileImageUrl}');
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.linkedin,
                                  size: 28,
                                  color: HexColor("#0072b1"),
                                ),
                              ),
                              // LinkedInButtonStandardWidget(
                              //   onTap: () {
                              //     setState(() {
                              //       user = null;
                              //       logoutUser = true;
                              //     });
                              //   },
                              //   buttonText: 'Logout',
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserObject {
  UserObject({
    this.firstName,
    this.lastName,
    this.email,
    this.profileImageUrl,
  });

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImageUrl;
}
