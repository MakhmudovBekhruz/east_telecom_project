import 'dart:convert';

import 'package:east_telecom_project/bloc/push/push_cubit.dart';
import 'package:east_telecom_project/ui/push/token_monitor.dart';
import 'package:east_telecom_project/utils/globals.dart';
import 'package:east_telecom_project/ui/push/push_permission.dart';
import 'package:east_telecom_project/widgets/meta_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'message_list.dart';

class PushScreen extends StatelessWidget {
  const PushScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<PushCubit>();

    return BlocBuilder<PushCubit, PushState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('East telecom push test'),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: cubit.sendPushMessage,
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.send_sharp,
              color: Colors.indigo,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const MetaCard('Permissions', PushPermission()),
              MetaCard(
                'FCM Token',
                TokenMonitor(
                  (token) {
                    cubit.token = token;
                    return token == null
                        ? const CircularProgressIndicator()
                        : Text(token, style: const TextStyle(fontSize: 12));
                  },
                ),
              ),
              const MetaCard('Message listener', MessageList()),
              MetaCard(
                'Send message',
                Column(
                  children: [
                    TextField(
                      controller: cubit.titleCtrl,
                      decoration: const InputDecoration(hintText: "Title"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: cubit.bodyCtrl,
                      decoration: const InputDecoration(hintText: "Body"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
