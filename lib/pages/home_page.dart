import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/bloc/bloc.dart';

class HomePage extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('krasav4ik')
      ),
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: RaisedButton(
            child: Text('logout'),
            onPressed: () => appBloc.dispatch(LoggedOut()),
          )
        ),
      ),
    );

  }
}