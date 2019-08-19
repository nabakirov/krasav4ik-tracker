import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class InfoState extends Equatable {
  InfoState([List props = const <dynamic>[]]) : super(props);
}

class InitialInfoState extends InfoState {}
