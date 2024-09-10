import 'dart:async';

import 'package:fauna/models/breeder_infoModel.dart';
import 'package:fauna/models/paymentHistoryModel.dart';
import 'package:fauna/models/user_model.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/repository/repositories.dart';

class BreederInfoBloc {
  InfoModelRepository _repository;
  StreamController _blocController;
  StreamSink<Response<BreederInfoModelClass>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<BreederInfoModelClass>> get loginStream =>
      _blocController.stream;

  BreederInfoBloc() {
    _blocController = StreamController<Response<BreederInfoModelClass>>();
    _repository = InfoModelRepository();
  }

  addBreederInfo(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      BreederInfoModelClass loginData = await _repository.breederInfo(data);
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

class PaymentHistoryBloc {
  PayHistoryRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<PaymentHistoryModel>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<PaymentHistoryModel>>> get loginStream =>
      _blocController.stream;

  PaymentHistoryBloc() {
    _blocController = StreamController<Response<List<PaymentHistoryModel>>>();
    _repository = PayHistoryRepository();
  }

  getHistory(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<PaymentHistoryModel> loginData = await _repository.getHistory(data);
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

class MarkHomeBloc {
  MarkHomeRepository _repository;
  StreamController _blocController;
  StreamSink<Response<MarkModel>> get loginDataSink => _blocController.sink;
  Stream<Response<MarkModel>> get loginStream => _blocController.stream;

  MarkHomeBloc() {
    _blocController = StreamController<Response<MarkModel>>();
    _repository = MarkHomeRepository();
  }

  markHomeFound(data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      MarkModel loginData = await _repository.rateOwner(data);
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
