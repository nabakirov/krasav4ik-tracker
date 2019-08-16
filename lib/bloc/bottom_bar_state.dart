import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BottomBarState extends Equatable {
  BottomBarState([List props = const <dynamic>[]]) : super(props);
}

class HomePageState extends BottomBarState {}

class SettingsPageState extends BottomBarState {}
