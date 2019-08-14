import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AppEvent extends Equatable {
  AppEvent([List props = const <dynamic>[]]) : super(props);
}


class AppStarted extends AppEvent {
  @override
  String toString() => "AppStarted";
}

class LoginBtnPressed extends AppEvent {
  @override
  String toString() => "LoginBtnPressed";

  final String privateKey;
  LoginBtnPressed({
    @required this.privateKey
  }) : super([privateKey]);
}


class LoggedOut extends AppEvent {
  @override
  String toString() => "LoggedOut";
}
