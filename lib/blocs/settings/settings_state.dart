import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsState extends Equatable {
  SettingsState([List props = const <dynamic>[]]) : super(props);
}

class BaseSettingsState extends SettingsState {
  @override
  String toString() => 'BaseSettingsState';
}

class NicknameInputState extends SettingsState {
  final String nickname;
  NicknameInputState({this.nickname}) : super([nickname]);

  @override
  String toString() => 'NicknameInputState';
}

class InitialValueInputState extends SettingsState {
  final int points;
  final int totalAchieves;

  InitialValueInputState({this.points, this.totalAchieves})
      : super([points, totalAchieves]);
  
  @override
  String toString() => 'InitialValueInputState';
}
