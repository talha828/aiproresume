// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googlesignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() async {
    // final response =  _googlesignIn.signIn().then((result){
    //       result!.authentication.then((googleKey){
    //           print("Access Token: "+ googleKey.accessToken.toString());
    //           print("Id Token: "+googleKey.idToken.toString());
    //           print("User Name:"+_googlesignIn.currentUser!.displayName.toString());
    //       }).catchError((err){
    //         print('inner error');
    //       });
    //   }).catchError((err){
    //       print('error occured'+ err.toString());
    //   });
    //final auth = await response.authentication;
    final response = _googlesignIn.signIn();
    // print("email: " + _googlesignIn.currentUser!.email.toString());
    // print("ID: " + _googlesignIn.currentUser!.id.toString());
    // print("name: " + _googlesignIn.currentUser!.displayName.toString());
    // print("google response: " + response.toString());
    return response;
  }

  static Future logout() => _googlesignIn.disconnect();

  // final AuthCredential authCredential = GoogleAuthProvider.credential(
  //     idToken: googleSignInAuthentication.idToken,
  //     accessToken: googleSignInAuthentication.accessToken);
}
