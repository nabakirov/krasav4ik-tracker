import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NotificationEvent extends Equatable {
  NotificationEvent([List props = const <dynamic>[]]) : super(props);
}

class NewError extends NotificationEvent {
  final String message;

  NewError(this.message) : super([message]);

  @override
  String toString() => "NewError";
}

class NewMessage extends NotificationEvent {
  final String message;

  NewMessage(this.message) : super([message]);

  @override
  String toString() => "NewMessage";
}

class HideNotificationBar extends NotificationEvent {
  @override
  String toString() => 'HideNotificationBar';
}

class ShowTransactionHash extends NotificationEvent {
  @override
  String toString() => 'ShowTransactionHash';

  final String txnHash;

  ShowTransactionHash({@required this.txnHash})
      : super([txnHash]);
}
