import 'package:equatable/equatable.dart';
import 'package:krasav4ik/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChartState extends Equatable {
  ChartState([List props = const <dynamic>[]]) : super(props);
}

class BaseChartState extends ChartState {
  final List<UserModel> items;
  BaseChartState({@required this.items}) : super([items]);
  @override
  String toString() => 'BaseChartState';
}
