import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class InfoState extends Equatable {
  InfoState([List props = const <dynamic>[]]) : super(props);
}

class BaseInfoState extends InfoState {
  String nickname = 'no nickname';
  double balance = 0;
  int pointCount = 0;
  int maxPointCount = 0;
  int achieveCount = 0;
  double achievePrize = 0;

  @override 
  String toString() => 'InitialInfoState';
}
