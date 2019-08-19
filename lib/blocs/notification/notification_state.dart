import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NotificationState extends Equatable {
  NotificationState([List props = const <dynamic>[]]) : super(props);
}

class EmptyState extends NotificationState {
  @override
  String toString() => "Empty";
}

class ErrorState extends NotificationState {
  final String message;

  ErrorState(this.message) : super([message]);

  @override
  String toString() => "ErrorState";
}

class MessageState extends NotificationState {
  final String message;

  MessageState(this.message) : super([message]);

  @override
  String toString() => "MessageState";
}

class TxnState extends NotificationState {
  final String txnHash;
  TxnState({this.txnHash}) : super([txnHash]);

  @override
  String toString() => "TxnState";
}
