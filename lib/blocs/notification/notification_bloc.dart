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
    } else if (event is ShowTransactionHash) {
      yield TxnState(txnHash: event.txnHash);
    } else if (event is ShowTransactionInfo) {
      yield TransactionInfo(transactionReceipt: event.transactionReceipt);
      // yield FrozenApp(duration: event.duration);
      // Stream.periodic(event.duration).take(1).listen((dynamic) => dispatch(HideNotificationBar()));
    }
  }

  Stream<NotificationState> _stateWithSelfDestroy({@required NotificationState notificationState, @required int duration}) async* {
    yield notificationState;
    Future.delayed(Duration(seconds: duration), () => dispatch(HideNotificationBar()));
  }
}
