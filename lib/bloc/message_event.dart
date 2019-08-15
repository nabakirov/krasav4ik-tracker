import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MessageEvent extends Equatable {
  MessageEvent([List props = const <dynamic>[]]) : super(props);
}

class EmptyMessage extends MessageEvent {}

class ErrorMessage extends MessageEvent {
  String message = 'unknown error';
  ErrorMessage({this.message});
}

class WarningMessage extends MessageEvent {
  String message = 'unknown warning';
  WarningMessage({this.message});
}