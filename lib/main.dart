import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/bloc/bloc.dart';
import 'package:krasav4ik/contract/abi.dart' as prefix0;
import 'package:krasav4ik/pages/loader.dart';
import 'package:krasav4ik/pages/login_page.dart';
import 'package:krasav4ik/pages/logo.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  String contractAddressHex = '0xb012241f80f77a728b144a50be2c3f8135bd7ca8';
  String rpcUrl = 'http://ropsten.fridayte.ch';
  String wsUrl = 'ws://ropsten.fridayte.ch:5001';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //   brightness: Brightness.light
      // ),
      title: 'krasav4ik',
      home: BlocProvider(
        builder: (context) => AppBloc(
          contractAddressHex: contractAddressHex,
          contractJson: prefix0.contractJson,
          rpcUrl: rpcUrl,
          wsUrl: wsUrl
          ),
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) => Home(),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);
    final state = appBloc.currentState;
    print(state.toString());
    if (state is AppStartedState) {
      appBloc.dispatch(AppStarted());
    }
    if (state is LoadingState) {
      return Loader();
    }
    if (state is LoginInitialState) {
      return LoginPage();
    }
    return Center(
      child: Text('init')
    );
  }
}
