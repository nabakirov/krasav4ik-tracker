import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => InfoScreenState();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is InfoSelected) {
      yield InfoScreenState();
    } else if (event is SettingsSelected) {
      yield SettingsScreenState();
    }
  }
}
