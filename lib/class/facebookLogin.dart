import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future getCurrentUser() async {
    return _auth.currentUser;
  }

  Future signInWithFaceBook() async {
    try {
      final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

      if (result.status == FacebookLoginStatus.loggedIn) {
        FacebookAccessToken facebookAccessToken = result.accessToken;
        print("status:-" + result.toString());

        final FacebookAccessToken accessToken = result.accessToken;

        var user =
            await _auth.signInWithFacebook(accessToken: accessToken.token);
        print("user:-" + user.toString());
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("Auth methods error $e");
      return null;
    }
  }

  Future<bool> signOut() async {
    try {
      await facebookSignIn.logOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
