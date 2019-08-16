import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BottomBarEvent extends Equatable {
  BottomBarEvent([List props = const <dynamic>[]]) : super(props);
}

class HomePageTap extends BottomBarEvent {}

class SettingsPageTap extends BottomBarEvent {}
