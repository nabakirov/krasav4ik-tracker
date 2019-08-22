import 'package:equatable/equatable.dart';
import 'package:krasav4ik/blocs/settings/settings_state.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  SettingsEvent([List props = const <dynamic>[]]) : super(props);
}

class PullSettingsEvent extends SettingsEvent {
  @override
  String toString() => 'PullSettingsEvent';
}

class ChangeNickname extends SettingsEvent {
  @override
  String toString() => 'ChangeNickname';

  final String nickname;
  final String address;

  ChangeNickname({this.nickname, this.address}) : super([nickname, address]);
}

class OpenNicknameInputWidget extends SettingsEvent {
  final BaseSettingsState baseState;

  OpenNicknameInputWidget({this.baseState}) : super([baseState]);

  @override
  String toString() => 'OpenNicknameInputWidget';
}
