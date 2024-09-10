import 'dart:async';
import 'dart:convert';
import 'package:fauna/models/chat_history.dart';
import 'package:fauna/supportingClass/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:pusher_websocket_flutter/pusher.dart';

class PusherService {
  Event lastEvent;
  String lastConnectionState;
  Channel channel;
  String userid;

  final APP_KEY = "4da7e95964828ac92d4c";
  final PUSHER_CLUSTER = "ap2";

  StreamController<ChatHistory> _eventData = StreamController<ChatHistory>();
  Sink get _inEventData => _eventData.sink;
  Stream get eventStream => _eventData.stream;

  Future<void> initPusher() async {
    try {
      await getUser();
      await Pusher.init(APP_KEY, PusherOptions(cluster: PUSHER_CLUSTER));
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(USERID);
  }

  void connectPusher() {
    Pusher.connect(
        onConnectionStateChange: (ConnectionStateChange connectionState) async {
      lastConnectionState = connectionState.currentState;
      print(lastConnectionState);
    }, onError: (ConnectionError e) {
      print("Error: ${e.message}");
    });
  }

  Future<void> subscribePusher(String channelName) async {
    channel = await Pusher.subscribe(channelName);
  }

  void unSubscribePusher(String channelName) {
    Pusher.unsubscribe(channelName);
  }

  void bindEvent(String eventName) {
    channel.bind(eventName, (last) {
      final String data = last.data;
      Map<String, dynamic> json = jsonDecode(data);
      print(json["message"]);
      ChatHistory message = ChatHistory.fromJson(json["message"]);
      if (userid == message.fromUserId.toString()) {
        return;
      }
      _eventData.add(message);
    });
  }

  void unbindEvent(String eventName) {
    channel.unbind(eventName);
    _eventData.close();
  }

  Future<void> firePusher(String channelName, String eventName) async {
    await initPusher();
    connectPusher();
    await subscribePusher(channelName);
    bindEvent(eventName);
  }
}
