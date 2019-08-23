import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChartEvent extends Equatable {
  ChartEvent([List props = const <dynamic>[]]) : super(props);
}
