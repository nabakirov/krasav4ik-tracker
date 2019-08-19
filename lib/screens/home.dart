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
      appBar = AppBar(title: Text('home'));
      body = BlocBuilder<InfoBloc, InfoState>(
        builder: (context, state) => InfoScreen(),
      );
    }
    if (state is SettingsScreenState) {
      appBar = AppBar(title: Text('Settings'));
      body = BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => SettingsScreen(),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        _buildNavBarItem(icon: Icons.home, text: 'home'),
        _buildNavBarItem(icon: Icons.settings, text: 'settings')
      ],
      onTap: _onButtomNavBarTap,
    );
  }
  

  BottomNavigationBarItem _buildNavBarItem({IconData icon, String text}) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: Colors.grey[500]),
      title: Text(text, style: TextStyle(color: Colors.grey[500])),
      backgroundColor: Colors.white
    );
  }
  void _onButtomNavBarTap(int index) {
    switch (index) {
      case 0: 
        homeBloc.dispatch(InfoSelected());
        return;
      case 1:
        homeBloc.dispatch(SettingsSelected());
        return;
    }
  }
}