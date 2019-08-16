import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class BottomBarBloc extends Bloc<BottomBarEvent, BottomBarState> {
  @override
  BottomBarState get initialState => HomePageState();

  @override
  Stream<BottomBarState> mapEventToState(
    BottomBarEvent event,
  ) async* {
    if (event is HomePageTap) {
      yield HomePageState();
    }
    if (event is SettingsPageTap) {
      yield SettingsPageState();
    }
  }
}
