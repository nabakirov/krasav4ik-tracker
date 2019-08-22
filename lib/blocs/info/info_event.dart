import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class InfoEvent extends Equatable {
  InfoEvent([List props = const <dynamic>[]]) : super(props);
}

class InfoInitialize extends InfoEvent {
  @override
  String toString() => 'InfoInitialize';
}

class UpdateInfo extends InfoEvent {
  @override
  String toString() => 'UpdateInfo';
}

class PlusPointPress extends InfoEvent {
  @override
  String toString() => 'PlusPointPress';
}

class MinusPointPress extends InfoEvent {
  @override
  String toString() => 'MinusPointPress';
}
