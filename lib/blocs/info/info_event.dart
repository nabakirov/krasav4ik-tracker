import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:krasav4ik/blocs/blocs.dart';

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

class OpenConfirmationWidget extends InfoEvent {
  final bool isPlus;
  final InfoState state;

  OpenConfirmationWidget({@required this.isPlus, @required this.state}) : super([isPlus]);
  
  @override
  String toString() => 'OpenConfirmationWidget';
}

class CloseConfirmationWidget extends InfoEvent {
  final InfoState infoState;
  CloseConfirmationWidget({@required this.infoState}) : super([infoState]);
  @override
  String toString() => 'CloseConfirmationWidget';
}

class PlusPointPress extends InfoEvent {
  final InfoState infoState;
  PlusPointPress({@required this.infoState}) : super([infoState]);
  @override
  String toString() => 'PlusPointPress';
}

class MinusPointPress extends InfoEvent {
  final InfoState infoState;
  MinusPointPress({@required this.infoState}) : super([infoState]);
  @override
  String toString() => 'MinusPointPress';
}
