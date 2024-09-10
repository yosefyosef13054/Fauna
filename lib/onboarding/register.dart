import 'package:fauna/blocs/auth_bloc.dart';
import 'package:fauna/class/emailDialogData.dart';
import 'package:fauna/class/facebookLogin.dart';
import 'package:fauna/home/base_class.dart';
import 'package:fauna/home/home.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/onboarding/otp_verify.dart';
import 'package:fauna/paymentStripe/component/showToast.dart';
import 'package:fauna/supportingClass/add_gradient.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterCLass extends StatefulWidget {
  static const routeName = '/register';
  RegisterCLass({Key key}) : super(key: key);
  @override
  _RegisterCLassState createState() => _RegisterCLassState();
}

class _RegisterCLassState extends State<RegisterCLass> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = "";
  String _firstName = "";
  String _lastName = "";
  String _password = "";
  String _phone = "";
  String __confirmPass = "";
  bool rememberMe = false;
  bool showerror = false;
  String error = "";
  Country _selectedCountry;
  RegisterBloc _bloc;
  bool isLoading = false;
  bool passwordVisible = true;
  bool confirmpasswordVisible = true;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  SocialBloc _socialBloc;
  String _fcmToken = "";
  /*
  * Facebook login
  * */
  bool _loading = false;
  AuthMethods _authMethods = AuthMethods();
  @override
  void initState() {
    super.initState();
    _socialBloc = SocialBloc();
    _bloc = RegisterBloc();
    initCountry();
    callbacks();
    getEmail();
  }

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fcmToken = prefs.getString(FCMTOKEN);
    print(_fcmToken);
  }

  void login() async {
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

  callbacks() {
    _bloc.loginStream.listen((event) {
      setState(() {
        switch (event.status) {
          case Status.LOADING:
            isLoading = true;
            Dialogs.showLoadingDialog(context, _keyLoader);
            break;
          case Status.COMPLETED:
            isLoading = false;
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OTPClass(
                          email: _email,
                          fromEmail: true,
                        )));

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

  void initCountry() {
    _selectedCountry = Country(
        name: "Canada",
        flag: "flags/can.png",
        countryCode: "CA",
        callingCode: "+1");
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
                    //  height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fill,
                  ),
                  _mainWidget(),
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
    return Padding(
        padding: EdgeInsets.fromLTRB(30, 100, 30, 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome",
                style: kMainHeading,
              ),
              space,
              space,
              space,
              space,
              Text(
                "Please login to continue lorem ipsum dummytest generated in 1950s.",
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
              space,
              addFirstName(),
              space,
              space,
              space,
              space,
              addEmail(),
              space,
              space,
              space,
              space,
              addPhoneNo(),
              space,
              space,
              space,
              space,
              addPasswrd(),
              space,
              space,
              space,
              space,
              addConfirmPasswrd(),
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
              Center(
                child: Text("---------- OR ----------", style: ksubButtonStyle),
              ),
              space,
              space,
              space,
              addSocialButton(),
              space,
              space,
              addSignInButton(),
              space,
            ],
          ),
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

  void _showCountryPicker() async {
    final country = await showCountryPickerDialog(context,
        title: Text(
          "Region",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ));
    if (country != null) {
      setState(() {
        print(country.name.toString());
        print(country.callingCode.toString());
        print(country.countryCode.toString());
        print(country.flag.toString());
        _selectedCountry = country;
      });
    }
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
              // validator: (value) {
              //   if (value == "") {
              //     return "Enter email.";
              //   }
              //   return null;
              // },
              onSaved: (String val) {
                _email = val;
              },
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Email id'))),
      onPressed: () {},
    );
  }

  addFirstName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [addfirstName(), addlasttName()],
    );
  }

  addfirstName() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 40,
          height: 50,
          child: TextFormField(
              // validator: (value) {
              //   if (value == "") {
              //     return "Enter First name.";
              //   }
              //   return null;
              // },
              onSaved: (String val) {
                _firstName = val;
              },
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'First Name'))),
      onPressed: () {},
    );
  }

  addlasttName() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 40,
          height: 50,
          child: TextFormField(
              // validator: (value) {
              //   if (value == "") {
              //     return "Enter Last name.";
              //   }
              //   return null;
              // },
              onSaved: (String val) {
                _lastName = val;
              },
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Last Name'))),
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
              // validator: (value) {
              //   if (value == "") {
              //     return "Enter password.";
              //   }
              //   return null;
              // },
              onSaved: (String val) {
                _password = val;
              },
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

  addConfirmPasswrd() {
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
              obscureText: confirmpasswordVisible,
              onSaved: (String val) {
                __confirmPass = val;
              },
              style: kTextFeildStyle,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      confirmpasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xFFE9E7E2),
                    ),
                    onPressed: () {
                      setState(() {
                        confirmpasswordVisible = !confirmpasswordVisible;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                  hintStyle: kSubHeading,
                  hintText: 'Confirm Password'))),
      onPressed: () {},
    );
  }

  addPhoneNo() {
    return UnicornOutlineButton(
      strokeWidth: 1,
      radius: 24,
      gradient: LinearGradient(
        colors: [Color(0xFFFF3D00), Color(0xFF9C27B0)],
        end: const Alignment(0.0, -1),
        begin: const Alignment(0.0, 0.6),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: InkWell(
              child: _selectedCountry != null
                  ? Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(_selectedCountry.flag,
                                package: countryCodePackageName)),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.redAccent,
                      ),
                    )
                  : Container(),
              onTap: () {
                _showCountryPicker();
              },
            ),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            child: Image.asset("assets/downArrow.webp", width: 15, height: 15),
            onTap: () {
              _showCountryPicker();
            },
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width - 125,
              height: 50,
              child: TextFormField(
                  // validator: (value) {
                  //   if (value == "") {
                  //     return "Enter phone.";
                  //   }
                  //   return null;
                  // },
                  onSaved: (String val) {
                    _phone = val;
                  },
                  style: kTextFeildStyle,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(5, 0, 20, 0),
                      hintStyle: kSubHeading,
                      hintText: 'Phone Number')))
        ],
      ),
      onPressed: () {},
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
          register();
          // Navigator.pushNamed(context, OTPClass.routeName);
        },
        color: Color(0xFF9C27B0),
        textColor: Colors.white,
        child: Text("Sign Up", style: kButtontyle),
      ),
    );
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
        login();
      },
    );
  }

  addSignInButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.transparent,
        textColor: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Already have an account?",
              style: kTextFeildStyle,
            ),
            SizedBox(width: 5),
            GradientText(
              "Sign In",
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
          ],
        ),
      ),
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

  register() {
    _formKey.currentState.save();
    bool emailPattern = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(_email);
    bool _phoneValid = RegExp(r"^[0-9]+$").hasMatch(_phone);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    if (_firstName.isEmpty) {
      setState(() {
        showerror = true;
        error = "Please enter your first name";
      });
    } else if (_lastName.isEmpty) {
      setState(() {
        showerror = true;
        error = "Please enter your last name";
      });
    } else if (_email.isEmpty) {
      setState(() {
        showerror = true;
        error = "Please enter your email";
      });
    } else if (!emailPattern) {
      setState(() {
        showerror = true;
        error = "Please enter valid email";
      });
    } else if (_phone.isEmpty) {
      setState(() {
        showerror = true;
        error = "Please enter phone.";
      });
    } else if (!_phoneValid) {
      setState(() {
        showerror = true;
        error = "Invalid phone";
      });
    } else if (_password.isEmpty) {
      setState(() {
        showerror = true;
        error = "Please enter password";
      });
    } else if (__confirmPass.isEmpty) {
      setState(() {
        showerror = true;
        error = "Please enter confirm password";
      });
    } else if (_password != __confirmPass) {
      setState(() {
        showerror = true;
        error = "The Password & Confirm Password must match";
      });
    } else if (_selectedCountry == null) {
      setState(() {
        showerror = true;
        error = "Please select country";
      });
    } else {
      setState(() {
        showerror = false;
        error = "";
      });
      Map<String, String> body = <String, String>{
        'firstName': _firstName,
        'lastName': _lastName,
        'email': _email,
        'phone': _phone,
        'password': _password,
        'country': _selectedCountry.name,
        'countryCode': _selectedCountry.callingCode,
        'latitude': "0.0",
        'longitude': "0.0"
      };
      _bloc.registerUser(body);
    }
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
}
