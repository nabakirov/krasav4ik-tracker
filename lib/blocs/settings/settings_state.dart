import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsState extends Equatable {
  SettingsState([List props = const <dynamic>[]]) : super(props);
}

class InitialSettingsState extends SettingsState {}
