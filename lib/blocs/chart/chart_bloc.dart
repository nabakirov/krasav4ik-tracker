import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  @override
  ChartState get initialState => InitialChartState();

  @override
  Stream<ChartState> mapEventToState(
    ChartEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
