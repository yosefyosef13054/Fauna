import 'dart:async';

import 'package:fauna/models/chat_history.dart';
import 'package:fauna/models/chat_list.dart';
import 'package:fauna/networking/Response.dart';
import 'package:fauna/repository/repositories.dart';

class ChatBloc {
  ChatListRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<ChatList>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<ChatList>>> get loginStream => _blocController.stream;

  ChatBloc() {
    _blocController = StreamController<Response<List<ChatList>>>();
    _repository = ChatListRepository();
  }

  getChatList() async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<ChatList> loginData = await _repository.getChatList();
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

class MessagesBloc {
  ChatMessagesRepository _repository;
  StreamController _blocController;
  StreamSink<Response<List<ChatHistory>>> get loginDataSink =>
      _blocController.sink;
  Stream<Response<List<ChatHistory>>> get loginStream => _blocController.stream;

  MessagesBloc() {
    _blocController = StreamController<Response<List<ChatHistory>>>();
    _repository = ChatMessagesRepository();
  }

  getChatList(Map<String, dynamic> data) async {
    loginDataSink.add(Response.loading('loading'));
    try {
      List<ChatHistory> loginData = await _repository.getMessages(data);
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
