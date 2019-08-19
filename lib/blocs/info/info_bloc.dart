import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  @override
  InfoState get initialState => InitialInfoState();

  @override
  Stream<InfoState> mapEventToState(
    InfoEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
