part of 'push_cubit.dart';

abstract class PushState extends Equatable {
  const PushState();

  @override
  List<Object> get props => [];
}

class PushInitialState extends PushState {}

class MessageReceived extends PushState {
  final List<RemoteMessage> messages;

  const MessageReceived(this.messages);
}
