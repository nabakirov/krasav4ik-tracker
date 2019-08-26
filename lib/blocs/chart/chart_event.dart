import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChartEvent extends Equatable {
  ChartEvent([List props = const <dynamic>[]]) : super(props);
}

class LoadChartList extends ChartEvent {
  @override
  String toString() => 'LoadChartList';
}

class FetchChartList extends ChartEvent {
  @override
  String toString() => 'FetchChartList';
}

class OpenChartList extends ChartEvent {
  @override
  String toString() => 'OpenChartList';
}

class UpdateChartList extends ChartEvent {
  @override
  String toString() => 'UpdateChartList';
}