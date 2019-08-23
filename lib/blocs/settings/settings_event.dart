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

class LoadSettingsScreen extends SettingsEvent {
  @override
  String toString() => 'LoadSettingsScreen';
}

class ChangeNickname extends SettingsEvent {
  @override
  String toString() => 'ChangeNickname';

  final String nickname;

  ChangeNickname({this.nickname}) : super([nickname]);
}

class OpenNicknameInputWidget extends SettingsEvent {
  @override
  String toString() => 'OpenNicknameInputWidget';
}
