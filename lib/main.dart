import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/abi.dart' as abi;
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:krasav4ik/blocs/logging_bloc_delegate.dart';
import 'package:krasav4ik/configs.dart' as config;
import 'package:krasav4ik/tools/tools.dart';
import 'package:krasav4ik/screens/screen.dart';

void main() {
  BlocSupervisor.delegate = LoggingBlocDelegate();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AppBloc>(
        builder: (context) => AppBloc(
          rpcUrl: config.rpcUrl,
          wsUrl: config.wsUrl,
          contractAddressHex: config.contractAddressHex,
          contractJson: abi.contractJson,
        ),
      ),
      BlocProvider<NotificationBloc>(
        builder: (context) => NotificationBloc(),
      )
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);
    var notificationBloc = BlocProvider.of<NotificationBloc>(context);
    return MaterialApp(
      title: 'krasav4ik',
      theme: ThemeData(primaryColor: Colors.white),
      home: Stack(children: [
        BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppLoadingState) {
              appBloc.dispatch(InitializeApp());
              return Loader();
            } else if (state is LoginPageState) {
              return LoginScreen();
            } else if (state is HomePageState) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<HomeBloc>(
                    builder: (context) => HomeBloc(),
                  ),
                  BlocProvider<InfoBloc>(
                    builder: (context) => InfoBloc(
                      web3client: appBloc.web3client,
                      credentials: appBloc.credentials,
                      contract: appBloc.contract,
                      notificationBloc: notificationBloc
                    )..dispatch(InfoInitialize())
                  ),
                  BlocProvider<SettingsBloc>(
                    builder: (context) => SettingsBloc(
                      web3client: appBloc.web3client,
                      credentials: appBloc.credentials,
                      contract: appBloc.contract,
                      notificationBloc: notificationBloc
                    )..dispatch(PullSettingsEvent()),
                  ),
                  BlocProvider<ChartBloc>(
                    builder: (context) => ChartBloc(
                      web3client: appBloc.web3client,
                      credentials: appBloc.credentials,
                      contract: appBloc.contract,
                      notificationBloc: notificationBloc
                    )..dispatch(LoadChartList()),
                  )
                ],
                child: 
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) => Home(),
                ),
              );
            } else {
              return Material(child: Center(child: Text('unknown state'),),);
            }
          },
        ),
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) => NotificationWidget()
        )
      ]),
    );
  }
}
