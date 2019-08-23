import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const <dynamic>[]]) : super(props);
}

class InfoSelected extends HomeEvent {
  @override
  String toString() => 'InfoSelected';
}

class SettingsSelected extends HomeEvent {
  @override
  String toString() => 'SettingsSelected';
}

class ChartSelected extends HomeEvent {
  @override
  String toString() => 'ChartSelected';
}