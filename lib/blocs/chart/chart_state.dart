import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChartState extends Equatable {
  ChartState([List props = const <dynamic>[]]) : super(props);
}

class InitialChartState extends ChartState {}
