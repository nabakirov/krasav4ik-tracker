import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var notificationBloc = BlocProvider.of<NotificationBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text('home')),
      body: Center(
        child: Text('login'),
      ),
    );
  }
}
