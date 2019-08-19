import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class InfoEvent extends Equatable {
  InfoEvent([List props = const <dynamic>[]]) : super(props);
}


class UpdateInfo extends InfoEvent {
  @override
  String toString() => 'UpdateInfo';
}
