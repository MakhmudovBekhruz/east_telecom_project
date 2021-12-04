import 'bloc/push/push_cubit.dart';
import 'package:east_telecom_project/ui/home/home_screen.dart';
import 'package:east_telecom_project/ui/map/map_screen.dart';
import 'package:east_telecom_project/utils/globals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'bloc/map/map_cubit.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PushCubit(),
        ),

        BlocProvider(
          create: (context) => MapCubit(),
        )
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: HomeScreen(),
      ),
    ),
  );
}
