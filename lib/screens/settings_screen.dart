import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var notificationBloc = BlocProvider.of<NotificationBloc>(context);
    var appBloc = BlocProvider.of<AppBloc>(context);
    var settingsBloc = BlocProvider.of<SettingsBloc>(context);
    var state = settingsBloc.currentState;
    if (state is NicknameInputState) {
      var _nicknameController = TextEditingController();
      return Material(
          child: Stack(
        children: <Widget>[
          mainWidget(notificationBloc, appBloc, state.baseState, settingsBloc),
          Stack(
            children: <Widget>[
              Positioned.fill(
                child: Opacity(
                  opacity: 0.7,
                  child: InkWell(
                      child: Container(
                        color: Colors.grey,
                      ),
                      onTap: () => settingsBloc.dispatch(PullSettingsEvent())),
                ),
              ),
              Center(
                  child: Card(
                color: Colors.white,
                child: Container(
                  width: 250,
                  height: 250,
                  child: Column(
                    children: <Widget>[
                      Text('change nickname'),
                      TextField(
                        controller: _nicknameController,
                      ),
                      Row(
                        children: <Widget>[
                          RaisedButton(
                            child: Text('cancel'),
                            onPressed: () =>
                                settingsBloc.dispatch(PullSettingsEvent()),
                          ),
                          RaisedButton(
                            child: Text('save'),
                            onPressed: () {
                              String text = _nicknameController.text;
                              if (text.isEmpty) {
                                notificationBloc.dispatch(
                                    NewError('nickname cannot be empty'));
                              } else {
                                settingsBloc.dispatch(ChangeNickname(
                                    nickname: text,
                                    address: state.baseState.address));
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
            ],
          )
        ],
      ));
    }
    if (state is BaseSettingsState) {
      return mainWidget(notificationBloc, appBloc, state, settingsBloc);
    }
  }

  Widget mainWidget(NotificationBloc notificationBloc, AppBloc appBloc,
      BaseSettingsState state, SettingsBloc settingsBloc) {
    return Material(
        child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            color: Colors.greenAccent,
            child: InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(state.nickname),
                  Text('change nickname')
                ],
              ),
              onTap: () {
                settingsBloc
                    .dispatch(OpenNicknameInputWidget(baseState: state));
              },
            ),
          ),
          Container(color: Colors.redAccent, child: Text(state.address)),
          RaisedButton(
            child: Text('logout'),
            onPressed: () {
              appBloc.dispatch(LogoutPress());
              notificationBloc.dispatch(NewMessage('logout'));
            },
          )
        ],
      ),
    ));
  }
}
