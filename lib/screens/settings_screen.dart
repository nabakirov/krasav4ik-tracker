import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:krasav4ik/tools/modal.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var notificationBloc = BlocProvider.of<NotificationBloc>(context);
    var appBloc = BlocProvider.of<AppBloc>(context);
    var settingsBloc = BlocProvider.of<SettingsBloc>(context);
    var state = settingsBloc.currentState;
    if (state is NicknameInputState) {
      return modalWidgetGenerator(
          mainWidget(notificationBloc, appBloc, settingsBloc),
          () => settingsBloc.dispatch(LoadSettingsScreen()),
          nicknameChangerWidget(state, settingsBloc, notificationBloc));
    }
    if (state is BaseSettingsState) {
      return mainWidget(notificationBloc, appBloc, settingsBloc);
    }
  }

  Widget nicknameChangerWidget(NicknameInputState state,
      SettingsBloc settingsBloc, NotificationBloc notificationBloc) {
    var _nicknameController = TextEditingController();
    _nicknameController.text = state.nickname;
    return Card(
      color: Colors.white,
      child: Container(
        width: 250,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Center(
                child: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('new nickname',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)))),
            TextField(
              controller: _nicknameController,
              autofocus: true,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 20),
              maxLines: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'cancel',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onPressed: () => settingsBloc.dispatch(LoadSettingsScreen()),
                ),
                FlatButton(
                  child: Text('save',
                  style: TextStyle(color: Colors.blueAccent)),
                  onPressed: () {
                    String text = _nicknameController.text;
                    if (text.isEmpty) {
                      notificationBloc
                          .dispatch(NewError('nickname cannot be empty'));
                    } else if (text.toLowerCase() ==
                        state.nickname.toLowerCase()) {
                      settingsBloc.dispatch(LoadSettingsScreen());
                    } else {
                      settingsBloc.dispatch(ChangeNickname(nickname: text));
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget mainWidget(NotificationBloc notificationBloc, AppBloc appBloc,
      SettingsBloc settingsBloc) {
    return Material(
        child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _rowBuilder('change nickname', () {
            settingsBloc.dispatch(OpenNicknameInputWidget());
          }),
          _rowBuilder('logout', () {
            appBloc.dispatch(LogoutPress());
            notificationBloc.dispatch(NewMessage('logout'));
          }),
        ],
      ),
    ));
  }

  Widget _rowBuilder(String text, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        child: Center(child: Text(text, style: TextStyle(fontSize: 20))),
      ),
    );
  }
}
