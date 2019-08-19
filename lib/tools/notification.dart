import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';

class NotificationWidget extends StatelessWidget {
  Widget _build(BuildContext context) {
    var notificationBloc = BlocProvider.of<NotificationBloc>(context);
    var state = notificationBloc.currentState;
    if (state is EmptyState) {
      return Container();
    }
    Color backgroundColor;
    if (state is ErrorState) {
      backgroundColor = Colors.red;
    } else if (state is MessageState) {
      backgroundColor = Colors.green;
    }
    return SafeArea(
      child: Material(
        child: Container(
            height: 50,
            color: backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(state.message)
              ],
            )),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {return _build(context);},
    );
  }
}