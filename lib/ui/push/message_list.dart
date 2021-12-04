import 'package:east_telecom_project/bloc/push/push_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageList extends StatelessWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<PushCubit>();
    return BlocBuilder<PushCubit, PushState>(
      buildWhen: (previous, current) => current is MessageReceived,
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: cubit.messages.length,
          itemBuilder: (context, index) {
            RemoteMessage message = cubit.messages[index];
            return ListTile(
              title: Text(message.notification?.title ?? ''),
              subtitle: Text(message.notification?.body?.toString() ?? ''),
            );
          },
        );
      },
    );
  }
}
