import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MessageState extends Equatable {
  MessageState([List props = const <dynamic>[]]) : super(props);
}

class InitialMessageState extends MessageState {}

class ErrorMessageState extends MessageState {}

class WarningMessageState extends MessageState {}
