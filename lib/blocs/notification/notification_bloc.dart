import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import './bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  @override
  NotificationState get initialState => EmptyState();
  final duration = 3;

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is NewError) {
      yield* _stateWithSelfDestroy(notificationState: ErrorState(event.message), duration: duration) ;
    } else if (event is NewMessage) {
      yield* _stateWithSelfDestroy(notificationState: MessageState(event.message), duration: duration) ;
    } else if (event is HideNotificationBar) {
      yield EmptyState();
    }
  }

  Stream<NotificationState> _stateWithSelfDestroy({@required NotificationState notificationState, @required int duration}) async* {
    yield notificationState;
    Future.delayed(Duration(seconds: duration), () => dispatch(HideNotificationBar()));
  }
}
