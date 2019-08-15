import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import './bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  @override
  MessageState get initialState => InitialMessageState();

  String message;
  List<Widget> data;

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is EmptyMessage) {
      yield InitialMessageState();
    }
    if (event is ErrorMessage) {
      message = event.message;
      data = [
        Text(message),

      ];
      yield ErrorMessageState();
      Stream.periodic(Duration(seconds: 3)).listen(
        (dynamic) {
          dispatch(EmptyMessage());
        }
      );
    }
    if (event is WarningMessage) {
      message = event.message;
      data = [
        Text(message)
      ];
      yield WarningMessageState();
    }
  }
}
