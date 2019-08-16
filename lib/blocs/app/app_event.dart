import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AppEvent extends Equatable {
  AppEvent([List props = const <dynamic>[]]) : super(props);
}

class InitializeApp extends AppEvent {
  @override
  String toString() => 'InitializeApp';
}

class LoginPress extends AppEvent {
  final String privateKey;

  LoginPress(this.privateKey) : super([privateKey]);

  @override
  String toString() => 'InitializeApp';
}

class LogoutPress extends AppEvent {
  @override
  String toString() => 'LogoutPress';
}
