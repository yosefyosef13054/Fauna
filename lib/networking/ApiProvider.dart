import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fauna/networking/CustomException.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {
  static String baseUrl = "https://fauna.live/adminportal/api/v1/";

  Future<dynamic> get(String url) async {
    print('request url:- ${baseUrl + url}');
    var responseJson;
    try {
      Map<String, String> headers = {
        "secretKey": "sZZv9H3OwRp0gj3pQzy0SeiI972mALher3R9w518"
      };
      var uri = Uri.parse(baseUrl + url);
      var request = new http.MultipartRequest("GET", uri);
      request.headers.addAll(headers);
      http.Response sresponse =
          await http.Response.fromStream(await request.send());
      responseJson = _response(sresponse);
    } on SocketException {
      print("not working");
      throw NoInternetException(NO_INTERNET);
    }
    return responseJson;
  }

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    return token;
  }

  Future<dynamic> getWithToken(String url, var body) async {
    print('request url:- ${baseUrl + url}');
    print('request body:- $body');
    var responseJson;
    try {
      var token = await getAuthToken();
      Map<String, String> headers = {
        "Authorization": "Bearer " + token,
        "secretKey": "sZZv9H3OwRp0gj3pQzy0SeiI972mALher3R9w518"
      };
      var uri = Uri.parse(baseUrl + url);
      var request = new http.MultipartRequest("GET", uri);
      request.headers.addAll(headers);

      http.Response sresponse =
          await http.Response.fromStream(await request.send());
      responseJson = _response(sresponse);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, var body) async {
    print('request url:- ${baseUrl + url}');
    print('request body:- $body');
    var responseJson;

    try {
      Map<String, String> headers = <String, String>{
        "secretKey": "sZZv9H3OwRp0gj3pQzy0SeiI972mALher3R9w518"
      };
      var uri = Uri.parse(baseUrl + url);
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..fields.addAll(body);

      http.Response sresponse =
          await http.Response.fromStream(await request.send());
      responseJson = _response(sresponse);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<String> getApiDataRequest(String url, headerType) async {
    print('request url:- ${baseUrl + url}');
    print('request body:- $headerType');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AUTHTOKEN);
    print("token :- " + token.toString());
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    if (headerType == SECRETKEY) {
      request.headers
          .set('secretKey', 'sZZv9H3OwRp0gj3pQzy0SeiI972mALher3R9w518');
    } else {
      request.headers.set("Authorization", "Bearer " + token);
    }

    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  Future<dynamic> postWithToken(String url, var body) async {
    print('request url:- ${baseUrl + url}');
    print('request body:- $body');
    var responseJson;
    var token = await getAuthToken();
    try {
      Map<String, String> headers = <String, String>{
        "secretKey": "sZZv9H3OwRp0gj3pQzy0SeiI972mALher3R9w518",
        "Authorization": "Bearer " + token,
      };
      print('request body:- $token');

      var uri = Uri.parse(baseUrl + url);
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..fields.addAll(body);
      http.Response sresponse =
          await http.Response.fromStream(await request.send());
      responseJson = _response(sresponse);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postWithTokenWithoutScret(String url, var body) async {
    var responseJson;
    var token = await getAuthToken();
    print("token :-" + token.toString());
    try {
      Map<String, String> headers = <String, String>{
        "Authorization": "Bearer " + token,
      };
      var uri = Uri.parse(baseUrl + url);
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..fields.addAll(body);
      http.Response sresponse =
          await http.Response.fromStream(await request.send());
      responseJson = _response(sresponse);
      print("responseJson :-" + responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 202:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;

      case 400:
        var responseJson = json.decode(response.body.toString());
        throw BadRequestException(responseJson['message'].toString());
      case 401:
        var responseJson = json.decode(response.body.toString());
        throw NoInternetException(responseJson["message"]);
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        var responseJson = json.decode(response.body.toString());
        var error =
            responseJson["errors"] != null ? responseJson["errors"] : "";
        var msg = "";
        if (error != "") {
          msg = error["message"] != null ? error["message"] : "";
        }
        throw BadRequestException(msg ?? response.body.toString());
      // } else {
      //   throw BadRequestException(response.body.toString());
      // }
      case 422:
        var responseJson = json.decode(response.body.toString());
        var error = responseJson["errors"];
        var msg = error["msg"];
        print(msg);
        throw BadRequestException(msg);
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
