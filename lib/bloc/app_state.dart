import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AppState extends Equatable {
  AppState([List props = const <dynamic>[]]) : super(props);
}

class AppStartedState extends AppState {
  @override
  String toString() => "AppStartedState";
}

class LoginInitialState extends AppState {
  @override
  String toString() => "LoginInitialState";
}

class LoadingState extends AppState {
  @override
  String toString() => "LoadingState";
}

class LoginFailureState extends AppState {
  @override
  String toString() => "LoginFailureState";
}

class HomePageInitialState extends AppState {
  @override
  String toString() => "HomePageInitialState";
}
