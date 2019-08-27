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
  @override
  String toString() => 'NicknameInputState';
}

class InitialValueInputState extends SettingsState {
  @override
  String toString() => 'InitialValueInputState';
}
