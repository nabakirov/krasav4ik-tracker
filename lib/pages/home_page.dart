import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/bloc/bloc.dart';
import 'package:krasav4ik/pages/info.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (context) => BottomBarBloc(),
        child: Scaffold(
          appBar: AppBar(title: Text('krasav4ik')),
          body: BlocBuilder(builder: (context, state) => HomeBodyWidget()),
          bottomNavigationBar: BottomBarWidget(),
        ));
  }
}

class HomeBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);
    var barBloc = BlocProvider.of<BottomBarBloc>(context);
    var state = barBloc.currentState;

    if (state is HomePageState) {
      return BlocProvider(
        builder: (context) => HomeBloc(
          web3client: appBloc.web3client,
          contract: appBloc.contract,
          credentials: appBloc.credentials
        ),
        child: InfoPage(),
      );
    }
    if (state is SettingsPageState) {
      return Text('settings');
    }
    return Text('hello');
  }
}

class BottomBarWidget extends StatelessWidget {
  BottomNavigationBarItem _buildItem({IconData icon, String text}) {
    return BottomNavigationBarItem(
        icon: Icon(icon, color: Colors.grey[500]),
        title: Text(text, style: TextStyle(color: Colors.grey[500])),
        backgroundColor: Colors.white);
  }

  void _onTap(BottomBarBloc barBloc, int index) {
    switch (index) {
      case 0:
        barBloc.dispatch(HomePageTap());
        break;
      case 1:
        barBloc.dispatch(SettingsPageTap());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarBloc = BlocProvider.of<BottomBarBloc>(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(icon: Icons.home, text: 'Home'),
        _buildItem(icon: Icons.settings, text: 'Settings')
      ],
      onTap: (index) {
        _onTap(bottomBarBloc, index);
      },
    );
  }
}
