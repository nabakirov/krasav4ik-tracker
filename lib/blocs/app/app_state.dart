import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AppState extends Equatable {
  AppState([List props = const <dynamic>[]]) : super(props);
}

class AppLoadingState extends AppState {
  @override
  String toString() => 'AppLoadingState';
}

class LoginPageState extends AppState {
  final bool failed;
  LoginPageState({@required this.failed}) : super([failed]);
  @override
  String toString() => 'LoginState';
}

class HomePageState extends AppState {
  @override
  String toString() => 'HomePageState';
}
