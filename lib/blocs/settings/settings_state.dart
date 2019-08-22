import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsState extends Equatable {
  SettingsState([List props = const <dynamic>[]]) : super(props);
}

class BaseSettingsState extends SettingsState {
  final String nickname;
  final String address;
  BaseSettingsState({
    this.nickname,
    this.address
  }) : super([nickname, address]);

  @override
  String toString() => 'BaseSettingsState';
}

class NicknameInputState extends SettingsState {
  final BaseSettingsState baseState;
  NicknameInputState({
    this.baseState
  }) : super([baseState]);

  @override
  String toString() => 'NicknameInputState';
}