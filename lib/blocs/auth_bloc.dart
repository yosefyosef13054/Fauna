import 'dart:async';

import 'package:fauna/models/profile_model.dart';
import 'package:fauna/models/register_model.dart';
import 'package:fauna/models/user_model.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/repository/repositories.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterBloc {
  RegisterRepository _repository;
  StreamController _blocController;
  StreamSink<Response<RegisterModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<RegisterModelClass>> get loginStream =>
      _blocController.stream;

  RegisterBloc() {
    _blocController = StreamController<Response<RegisterModelClass>>();
    _repository = RegisterRepository();
  }

  registerUser(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      RegisterModelClass loginData = await _repository.getRegisterData(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));

      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class LoginBloc {
  LoginRepository _repository;
  StreamController _blocController;
  StreamSink<Response<UserModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<UserModelClass>> get loginStream => _blocController.stream;

  LoginBloc() {
    _blocController = StreamController<Response<UserModelClass>>();
    _repository = LoginRepository();
  }

  loginUser(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      UserModelClass loginData = await _repository.getLoginData(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(AUTHTOKEN, loginData.token);
      prefs.setString(USERPHONE, loginData.phone.toString());
      prefs.setString(USERPROFILE, loginData.profileImg);
      prefs.setString(USERID, loginData.id.toString());
      prefs.setString(USERNAME, loginData.firstName + " " + loginData.lastName);
      prefs.setInt(ISBREEDER, loginData.isBreeder);
      prefs.setString(STRIPECUSTOMERID, loginData.stripeCustomerId.toString());
      prefs.setString(ADDRESS, loginData.address.toString());
      prefs.setString(LATITUDE, loginData.latitude.toString());
      prefs.setString(LONGITUDE, loginData.longitude.toString());

      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class OTPBloc {
  OTPRepository _repository;
  StreamController _blocController;
  StreamSink<Response<UserModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<UserModelClass>> get loginStream => _blocController.stream;

  OTPBloc() {
    _blocController = StreamController<Response<UserModelClass>>();
    _repository = OTPRepository();
  }

  loginUser(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      UserModelClass loginData = await _repository.getData(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(AUTHTOKEN, loginData.token);
      prefs.setString(USERPHONE, loginData.phone.toString());
      prefs.setString(USERID, loginData.id.toString());
      prefs.setString(USERPROFILE, loginData.profileImg);
      prefs.setString(STRIPECUSTOMERID, loginData.stripeCustomerId.toString());
      prefs.setString(USERNAME, loginData.firstName + " " + loginData.lastName);
      prefs.setInt(ISBREEDER, loginData.isBreeder);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class ResendOTPBloc {
  ResendOTPRepository _repository;
  StreamController _blocController;
  StreamSink<Response<ResendModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<ResendModelClass>> get loginStream => _blocController.stream;

  ResendOTPBloc() {
    _blocController = StreamController<Response<ResendModelClass>>();
    _repository = ResendOTPRepository();
  }

  resendOtp(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      ResendModelClass loginData = await _repository.resendOTP(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class ForgotBloc {
  ForgetRepository _repository;
  StreamController _blocController;
  StreamSink<Response<ResendModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<ResendModelClass>> get loginStream => _blocController.stream;

  ForgotBloc() {
    _blocController = StreamController<Response<ResendModelClass>>();
    _repository = ForgetRepository();
  }

  forgot(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      ResendModelClass loginData = await _repository.forgotPassword(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class ForgotOTPBloc {
  OTPRepository _repository;
  StreamController _blocController;
  StreamSink<Response<UserModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<UserModelClass>> get loginStream => _blocController.stream;

  ForgotOTPBloc() {
    _blocController = StreamController<Response<UserModelClass>>();
    _repository = OTPRepository();
  }

  sendotp(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      UserModelClass loginData = await _repository.sendOtp(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class ConfirmPasswordBloc {
  SetPasswordRepository _repository;
  StreamController _blocController;
  StreamSink<Response<UserModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<UserModelClass>> get loginStream => _blocController.stream;

  ConfirmPasswordBloc() {
    _blocController = StreamController<Response<UserModelClass>>();
    _repository = SetPasswordRepository();
  }

  sendotp(data) async {
    loginDataSink.add(Response.loading('loading'));

    try {
      UserModelClass loginData = await _repository.resendOTP(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class LogoutBloc {
  LogoutRepository _repository;
  StreamController _blocController;
  StreamSink<Response<ResendModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<ResendModelClass>> get loginStream => _blocController.stream;

  LogoutBloc() {
    _blocController = StreamController<Response<ResendModelClass>>();
    _repository = LogoutRepository();
  }

  logout() async {
    loginDataSink.add(Response.loading('loading'));
    try {
      ResendModelClass loginData = await _repository.logoutAPI();
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class ProfileBloc {
  ProfileRepository repository;
  StreamController _blocController;
  StreamSink<Response<UserProfileModel>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<UserProfileModel>> get loginStream => _blocController.stream;

  ProfileBloc() {
    _blocController = StreamController<Response<UserProfileModel>>();
    repository = ProfileRepository();
  }

  getUser() async {
    loginDataSink.add(Response.loading('loading'));
    try {
      UserProfileModel loginData = await repository.getUser();
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class EditProfileBloc {
  EditProfileRepository repository;
  StreamController _blocController;
  StreamSink<Response<UserProfileModel>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<UserProfileModel>> get loginStream => _blocController.stream;

  EditProfileBloc() {
    _blocController = StreamController<Response<UserProfileModel>>();
    repository = EditProfileRepository();
  }

  editUser(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      UserProfileModel loginData = await repository.editUser(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(USERPHONE, loginData.phone.toString());

      prefs.setString(USERNAME, loginData.firstName + " " + loginData.lastName);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class ChangePasswordBloc {
  ChangePassRepository repository;
  StreamController _blocController;
  StreamSink<Response<UserProfileModel>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<UserProfileModel>> get loginStream => _blocController.stream;

  ChangePasswordBloc() {
    _blocController = StreamController<Response<UserProfileModel>>();
    repository = ChangePassRepository();
  }

  chanegPassword(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      UserProfileModel loginData = await repository.chnagePass(data);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}

class ChangeEmailOTPBloc {
  EmailOTPRepository _repository;
  StreamController _blocController;
  StreamSink<Response<UserProfileModel>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<UserProfileModel>> get loginStream => _blocController.stream;

  ChangeEmailOTPBloc() {
    _blocController = StreamController<Response<UserProfileModel>>();
    _repository = EmailOTPRepository();
  }

  loginUser(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      UserProfileModel loginData = await _repository.getData(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(USERPHONE, loginData.phone.toString());
      prefs.setString(USERPROFILE, loginData.profileImg);
      prefs.setString(USERNAME, loginData.firstName + " " + loginData.lastName);
      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }
}

class SocialBloc {
  SocialRepository _repository;
  StreamController _blocController;
  StreamSink<Response<UserModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<UserModelClass>> get loginStream => _blocController.stream;

  SocialBloc() {
    _blocController = StreamController<Response<UserModelClass>>();
    _repository = SocialRepository();
  }

  loginUser(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      UserModelClass loginData = await _repository.getLoginData(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(AUTHTOKEN, loginData.token);
      prefs.setString(USERPHONE, loginData.phone.toString());
      prefs.setString(USERPROFILE, loginData.profileImg);
      prefs.setString(USERID, loginData.id.toString());
      prefs.setString(USERNAME, loginData.firstName + " " + loginData.lastName);
      prefs.setInt(ISBREEDER, loginData.isBreeder);
      prefs.setString(STRIPECUSTOMERID, loginData.stripeCustomerId.toString());

      loginDataSink.add(Response.completed(loginData));
    } catch (e) {
      loginDataSink.add(Response.error(e.toString()));
      print(e);
    }
    return null;
  }

  dispose() {
    _blocController.close();
  }
}
