import 'package:fauna/blocs/auth_bloc.dart';
import 'package:fauna/class/emailDialogData.dart';
import 'package:fauna/class/facebookLogin.dart';
import 'package:fauna/home/base_class.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/onboarding/forgot.dart';
import 'package:fauna/onboarding/register.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:fauna/supportingClass/notificatonManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCLass extends StatefulWidget {
  static const routeName = '/login';

  LoginCLass({Key key}) : super(key: key);

  @override
  _LoginCLassState createState() => _LoginCLassState();
}

class _LoginCLassState extends State<LoginCLass> {
  String _email = "";
  String _password = "";
  String _fcmToken = "";

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  bool rememberMe = false;
  bool isLoading = false;
  bool showerror = false;
  String error = "";
  SocialBloc _socialBloc;
  LoginBloc _loginBloc;
  bool passwordVisible = true;

  /*
  * Facebook login
  * */
  bool _loading = false;
  AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    super.initState();
    _socialBloc = SocialBloc();
    _loginBloc = LoginBloc();

    getEmail();

    _loginBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            Dialogs.showLoadingDialog(context, _keyLoader);

            isLoading = true;
            break;
          case Status.COMPLETED:
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            isLoading = false;
            Navigator.pushNamed(context, BaseClass.routeName);
            break;
          case Status.ERROR:
            isLoading = false;
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            print(event.message);
            _showAlert(context, event.message);
            break;
        }
      });
    });

    _socialBloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            isLoading = true;
            Dialogs.showLoadingDialog(context, _keyLoader);
            break;
          case Status.COMPLETED:
            isLoading = false;
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            Navigator.pushNamed(context, BaseClass.routeName);
            break;
          case Status.ERROR:
            isLoading = false;
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            print(event.message);
            _showAlert(context, event.message);
            break;
        }
      });
    });
  }

  void googlelogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // you can add extras if you require
      ],
    );

    _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
      GoogleSignInAuthentication auth = await acc.authentication;
      print(acc.id);
      print(acc.email);
      print(acc.displayName);
      print(acc.photoUrl);
      acc.authentication.then((GoogleSignInAuthentication auth) async {
        print(auth.idToken);
        print(auth.accessToken);
        Map<String, String> body = <String, String>{
          'name': acc.displayName,
          'email': acc.email,
          'fcm_token': _fcmToken,
          'provider': "GOOGLE",
          "id": auth.idToken,
          "access_token": auth.accessToken
        };
        _socialBloc.loginUser(body);
      });
    });
  }

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fcmToken = prefs.getString(FCMTOKEN);
    setState(() {
      _fcmToken = prefs.getString(FCMTOKEN);
    });
    if (_fcmToken == null || _fcmToken == '') {
      setState(() {
        new PushNotificationsManager().initialise();
        _fcmToken = prefs.getString(FCMTOKEN);
      });
    }
    print("_fcmToken :-" + _fcmToken.toString());
    if (prefs.getString(USEREMAIL) != null) {
      setState(() {
        rememberMe = true;
        _email = prefs.getString(USEREMAIL);
        _emailController.text = _email;
        _password = prefs.getString(USERPASSWORD);
        _passController.text = _password;
      });
    }
  }

  void _showAlert(BuildContext context, str) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Alert",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              content: Text(str),
              actions: [
                FlatButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        color: Colors.pink,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  addErrorView() {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(width: 1.0, color: Colors.red),
          color: Colors.red.withAlpha(60),
        ),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Center(
            child: Text(
          error,
          style: TextStyle(color: Colors.red, fontSize: 11),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          _onBackPressed();
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Image.asset(
                    "assets/bg.webp",
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fitHeight,
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(30, 100, 30, 0),
                      child: _mainWidget()),
                  Positioned(
                    top: 50,
                    right: 0,
                    child: addSkipButton(),
                  ),
                ],
              ),
            )));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit the app?'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                )
              ],
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
            );
          },
        ) ??
        false;
  }

  _mainWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Back!",
            style: kMainHeading,
          ),
          space,
          space,
          space,
          space,
          Text(
            "Hi there! Welcome back to Fauna. Please enter your username and password below to login.",
            style: kSubHeading,
          ),
          space,
          space,
          space,
          space,
          space,
          space,
          Center(
            child: Image.asset(
              "assets/login.webp",
              width: MediaQuery.of(context).size.width * 0.80,
              fit: BoxFit.cover,
            ),
          ),
          space,
          space,
          space,
          showerror ? addErrorView() : Container(),
          space,
          space,
          space,
          addEmail(),
          space,
          space,
          space,
          space,
          addPasswrd(),
          space,
          addRow(),
          space,
          space,
          space,
          space,
          space,
          addLoginButton(),
          space,
          space,
          space,
          space,
          space,
          space,
          space,
          space,
          Center(
            child: Text("---------- OR ----------", style: ksubButtonStyle),
          ),
          space,
          space,
          space,
          addSocialButton(),
          space,
          space,
          space,
          space,
          space,
          space,
          addSignUpButton(),
          space,
          space,
        ],
      ),
    );
  }

  addEmail() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: 50,
          child: TextFormField(
              onSaved: (String val) {
                _email = val;
              },
              controller: _emailController,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Email id / Phone Number'))),
      onPressed: () {},
    );
  }

  addPasswrd() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          height: 50,
          child: TextFormField(
              obscureText: passwordVisible,
              onSaved: (String val) {
                _password = val;
              },
              controller: _passController,
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFFE9E7E2),
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Password'))),
      onPressed: () {},
    );
  }

  addRow() {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 5),
          width: 20,
          height: 20,
          child: addcheckbox(),
        ),
        SizedBox(width: 5),
        Text(
          "Remember Password",
          style: ksubButtonStyle,
        ),
        // Spacer(flex: 1,),
        FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, ForgotClass.routeName);
          },
          color: Colors.transparent,
          child: Text("Forgot Password",
              textAlign: TextAlign.center, style: ksubButtonStyle),
        ),
      ],
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        if (rememberMe) {
        } else {}
      });

  addcheckbox() {
    return Checkbox(value: rememberMe, onChanged: _onRememberMeChanged);
  }

  addLoginButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Color(0xFF9C27B0))),
        onPressed: () {
          isGuestLogin = false;
          login();
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Sign In", style: kButtontyle),
      ),
    );
  }

  login() {
    _formKey.currentState.save();
    bool emailPattern = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(_email);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);

    if (_email.isEmpty) {
      setState(() {
        showerror = true;
        error = "Please enter your email";
      });
    } else if (_password.isEmpty) {
      setState(() {
        showerror = true;
        error = "Please enter your password";
      });
    } else if (!emailPattern) {
      setState(() {
        showerror = true;
        error = "Please enter valid email";
      });
    } else {
      saveUser();
      Map<String, String> body = <String, String>{
        'email': _email,
        'password': _password,
        'fcm_token': _fcmToken,
      };
      print("body: -" + body.toString());
      _loginBloc.loginUser(body);
    }
  }

  saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      prefs.setString(USEREMAIL, _email);
      prefs.setString(USERPASSWORD, _password);
    } else {
      prefs.remove(USEREMAIL);
      prefs.remove(USERPASSWORD);
    }
  }

  addSocialButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // addMailbutton(),
        // SizedBox(
        //   width: 10,
        // ),
        addFbbutton(),
        SizedBox(
          width: 10,
        ),
        addGooglebutton(),
      ],
    );
  }

  addFbbutton() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 40,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
      ),
      child: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(
            "assets/fbLogo.webp",
            width: 20,
            height: 20,
          )),
      onPressed: () {
        print("adad");
        addFacebookLogin();
      },
    );
  }

  addMailbutton() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 40,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
      ),
      child: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(
            "assets/mail.webp",
          )),
      onPressed: () {
        print("adad");
      },
    );
  }

  addGooglebutton() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 40,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
      ),
      child: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(
            "assets/googleLogo.webp",
          )),
      onPressed: () {
        googlelogin();
      },
    );
  }

  addSignUpButton() {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RegisterCLass.routeName),
          child: Text(
            "Don’t have an account?",
            style: kTextFeildStyle,
          ),
        ),
        SizedBox(width: 5),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RegisterCLass.routeName),
          child: GradientText(
            "Sign up",
            TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
            gradient: LinearGradient(
              colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ],
    );
  }

  addSkipButton() {
    return FlatButton(
      onPressed: () {
        isGuestLogin = true;
        Navigator.pushNamed(context, BaseClass.routeName);
      },
      color: Colors.transparent,
      child: Text("SKIP", textAlign: TextAlign.center, style: kTextFeildStyle),
    );
  }

  void addFacebookLogin() {
    _loading = true;
    setState(() {});
    _authMethods.signOut();
    _authMethods.signInWithFaceBook().then((user) {
      print("user :-" + user.toString());
      if (user != null) {
        var email = user.email;
        var displayName = user.displayName;
        if (email == null || displayName == null) {
          checkEmailDialog(user);
        } else {
          proccedFacebooklogin(user, email);
        }
      }
    }).catchError((error) {
      print('$error');
    });

    _loading = false;
    setState(() {});
  }

  void proccedFacebooklogin(user, String email) {
    Map<String, String> body = <String, String>{
      'name': user.displayName,
      'email': email,
      'fcm_token': _fcmToken,
      'provider': "FACEBOOK",
      "id": user.uid,
      "access_token": user.uid
    };
    print("user-body :-" + body.toString());

    _socialBloc.loginUser(body);
  }

  Future<void> checkEmailDialog(user) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    var email = user.email;
    var displayName = user.displayName;
    if (email != null) {
      emailController.text = email;
    }
    if (displayName != null) {
      nameController.text = displayName;
    }
    var data = await showDialogForNameEmail(
        emailController: emailController,
        nameController: nameController,
        contexts: context);

    print("data :-" + data.toString());
    if (data == null) {
    } else {
      Map detailData = data;
      var name = detailData['name'].toString();
      var email = detailData['email'].toString();
      if (name == "" || name == "null" || email == "" || email == "null") {
        showToast("Please enter email and name");
      } else {
        proccedFacebooklogin(user, email);
      }
    }
  }
}
