import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  @override
  NotificationState get initialState => EmptyState();

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is NewError) {
      yield ErrorState(event.message);
    } else if (event is NewMessage) {
      yield MessageState(event.message);
    }
  }
}
