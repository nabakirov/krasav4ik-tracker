import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeState extends Equatable {
  HomeState([List props = const <dynamic>[]]) : super(props);
}

class InfoScreenState extends HomeState {
  @override
  String toString() => 'InfoScreenState';
}

class SettingsScreenState extends HomeState {
  @override
  String toString() => 'SettingsScreenState';
}

class ChartScreenState extends HomeState {
  @override
  String toString() => 'ChartScreenState';
}
