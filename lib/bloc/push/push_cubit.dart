import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:east_telecom_project/utils/globals.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

part 'push_state.dart';

class PushCubit extends Cubit<PushState> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController bodyCtrl = TextEditingController();

  final List<RemoteMessage> messages = [];
  String? token;
  int count = 0;

  PushCubit() : super(PushInitialState()) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }

      messages.add(message);
      emit(MessageReceived(messages));
    });
  }

  Future<void> sendPushMessage() async {
    if (token == null) {
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAboQ8DEQ:APA91bG19s-qUB1NXbvZHM_c-APOlNnBfefGaTSFBD1HlPbCH1-__qYpvP7Q9roJ7xgHz3GI6ecVJDBYLfqeetfycDTiUUzz_Efhxq1jg3KQZvtlLTchhjphd9ggRxxYYxP2daJ-DzRd'
        },
        body: _constructFCMPayload(),
      );
    } catch (e) {
      print(e);
    }
  }

  String _constructFCMPayload() {
    count++;
    return jsonEncode({
      'to': token,
      'data': {
        'via': 'East telecom messages',
        'count': count.toString(),
      },
      'notification': {
        'title': titleCtrl.text.isEmpty ? "Title" : titleCtrl.text,
        'body': bodyCtrl.text.isEmpty ? "Body" : bodyCtrl.text,
      },
    });
  }
}
