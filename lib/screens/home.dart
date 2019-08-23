import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:krasav4ik/screens/screen.dart';

class Home extends StatelessWidget {
  HomeBloc homeBloc;
  @override
  Widget build(BuildContext context) {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    var state = homeBloc.currentState;
    AppBar appBar;
    Widget body;
    if (state is InfoScreenState) {
      appBar = AppBar(title: Text('krasav4ik'));
      body = BlocBuilder<InfoBloc, InfoState>(
        builder: (context, state) => InfoScreen(),
      );
    }
    if (state is SettingsScreenState) {
      appBar = AppBar(title: Text('Settings'));
      body = BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => SettingsScreen(),
      );
      if (state is ChartScreenState) {
        appBar = AppBar(title: Text('Top krasav4iks'));
        body = ChartScreen();
      }
    }

    List<BottomNavigationBarItem> items = [
      _buildNavBarItem(
          icon: Icons.home, text: 'home', selected: state is InfoScreenState),
      _buildNavBarItem(
          icon: Icons.assessment,
          text: 'top',
          selected: state is ChartScreenState),
      _buildNavBarItem(
          icon: Icons.settings,
          text: 'settings',
          selected: state is SettingsScreenState),
    ];

    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: _bottomNavigationBar(items),
    );
  }

  Widget _bottomNavigationBar(List<BottomNavigationBarItem> items) {
    return BottomNavigationBar(
      items: items,
      onTap: _onButtomNavBarTap,
    );
  }

  BottomNavigationBarItem _buildNavBarItem(
      {IconData icon, String text, bool selected: false}) {
    Color color;
    if (!selected) {
      color = Colors.grey[500];
    } else {
      color = Colors.blueAccent;
    }
    return BottomNavigationBarItem(
      icon: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: Colors.grey[500])),
      backgroundColor: Colors.white,
    );
  }

  void _onButtomNavBarTap(int index) {
    switch (index) {
      case 0:
        homeBloc.dispatch(InfoSelected());
        return;
      case 1:
        homeBloc.dispatch(ChartSelected());
        return;
      case 2:
        homeBloc.dispatch(SettingsSelected());
        return;
    }
  }
}
