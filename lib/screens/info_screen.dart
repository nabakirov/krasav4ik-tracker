import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var notificationBloc = BlocProvider.of<NotificationBloc>(context);
    var appBloc = BlocProvider.of<AppBloc>(context);
    return Material(
      child: Center(
        child: RaisedButton(
          child: Text('notification error'),
          onPressed: () => notificationBloc.dispatch(NewError('new error')),
        ),
      ),
    );
  }
}
