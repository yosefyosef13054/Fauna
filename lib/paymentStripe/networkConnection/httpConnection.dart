import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../component/stripePaymentId.dart';

Future<String> authaRegisterStripe(String url, body, context) async {
  Map<String,String> headers = {
    'Authorization': 'Bearer $skKey',
    "Content-Type": "application/x-www-form-urlencoded"};

  return http.post(url, body: body,headers: headers).then((http.Response response) async {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {}
    print('response');
    print(response.body);
    String reply =  response.body;
    return reply;
  });
}
Future<String> authaCardAddStripe(String url, body, context) async {
  Map<String,String> headers = {
    'Authorization': 'Bearer $skKey',
    "Content-Type": "application/x-www-form-urlencoded"};

  return http.post(url, body: body,headers: headers).then((http.Response response) async {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {}
    print('response');
    print(response.body);
    String reply =  response.body;
    return reply;
  });
}
Future<String> authaGetAddStripe(String url, context) async {
  Map<String,String> headers = {
    'Authorization': 'Bearer $skKey',
    "Content-Type": "application/x-www-form-urlencoded"};

  return http.get(url,headers: headers).then((http.Response response) async {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {}
    print('response');
    print(response.body);
    String reply =  response.body;
    return reply;
  });
}
Future<String> authaCardDetechStripe(String url, body, context) async {
  Map<String,String> headers = {
    'Authorization': 'Bearer $skKey',
    "Content-Type": "application/x-www-form-urlencoded"};

  return http.post(url, body: body,headers: headers).then((http.Response response) async {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {}
    print('response');
    print(response.body);
    String reply =  response.body;
    return reply;
  });
}
Future<String> authaPayStripe(String url, body, context) async {
  Map<String,String> headers = {
    'Authorization': 'Bearer $skKey',
    "Content-Type": "application/x-www-form-urlencoded",
  };

  return http.post(url, body: body,headers: headers).then((http.Response response) async {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
    } else {}
    print('response');
    print(response.body);
    String reply =  response.body;
    return reply;
  });
}