import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/bloc/bloc.dart';
import 'package:krasav4ik/bloc_delegate.dart';
import 'package:krasav4ik/contract/abi.dart' as prefix0;
import 'package:krasav4ik/pages/home_page.dart';
import 'package:krasav4ik/pages/loader.dart';
import 'package:krasav4ik/pages/login_page.dart';
import 'package:krasav4ik/pages/logo.dart';
import 'package:bloc/bloc.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  String contractAddressHex = '0xb012241f80f77a728b144a50be2c3f8135bd7ca8';
  String rpcUrl = 'http://ropsten.fridayte.ch';
  String wsUrl = 'ws://ropsten.fridayte.ch:5001';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // routes: ,
        theme: ThemeData(primaryColor: Colors.white),
        title: 'krasav4ik',
        home: BlocProvider(
          builder: (context) => MessageBloc(),
          child: Stack(children: <Widget>[
            BlocProvider(
                builder: (context) => AppBloc(
                    contractAddressHex: contractAddressHex,
                    contractJson: prefix0.contractJson,
                    rpcUrl: rpcUrl,
                    wsUrl: wsUrl),
                child: BlocBuilder<AppBloc, AppState>(
                  builder: (context, state) => Home(),
                )),
            BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) => Message(),
            )
          ]),
        ));
  }
}

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var messageBloc = BlocProvider.of<MessageBloc>(context);
    var state = messageBloc.currentState;
    if (state is InitialMessageState) {
      return Container();
    }
    Color backgroundColor;
    if (state is ErrorMessageState) {
      backgroundColor = Colors.red;
    } else if (state is WarningMessageState) {
      backgroundColor = Colors.green;
    }
    return SafeArea(
      child: Material(
        child: Container(
            height: 40,
            color: backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: messageBloc.data
            )),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);
    var messageBloc = BlocProvider.of<MessageBloc>(context);
    final state = appBloc.currentState;
    if (state is AppStartedState) {
      appBloc.dispatch(AppStarted());
    }
    if (state is LoadingState) {
      return Loader();
    }
    if (state is LoginInitialState) {
      return LoginPage();
    }
    if (state is HomePageInitialState) {
      return HomePage();
    }
    if (state is LoginFailureState) {
      messageBloc.dispatch(ErrorMessage(message: 'invalid private key'));
      return LoginPage();
    }
    return LogoPage();
  }
}
