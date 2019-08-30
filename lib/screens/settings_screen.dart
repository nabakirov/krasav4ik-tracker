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
    var infoBloc = BlocProvider.of<InfoBloc>(context);
    var state = settingsBloc.currentState;
    if (state is NicknameInputState) {
      return modalWidgetGenerator(
          background: mainWidget(notificationBloc, appBloc, settingsBloc),
          onBackgroundTap: () => settingsBloc.dispatch(LoadSettingsScreen()),
          modal: nicknameChangerWidget(
              settingsBloc, notificationBloc, infoBloc.currentState));
    }
    if (state is BaseSettingsState) {
      return mainWidget(notificationBloc, appBloc, settingsBloc);
    }

    if (state is InitialValueInputState) {
      return modalWidgetGenerator(
          background: mainWidget(notificationBloc, appBloc, settingsBloc),
          onBackgroundTap: () => settingsBloc.dispatch(LoadSettingsScreen()),
          modal: initialValueWidget(infoBloc.currentState, settingsBloc, notificationBloc));
    }
  }

  Widget initialValueWidget(BaseInfoState state,
      SettingsBloc settingsBloc, NotificationBloc notificationBloc) {
    var _pointsController = TextEditingController();
    var _achievesController = TextEditingController();

    _pointsController.text = state.pointCount.toString();
    _achievesController.text = state.achieveCount.toString();

    var body = Container(
      width: 200,
      child: Column(
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            controller: _pointsController,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 20),
            maxLines: 1,
            decoration: InputDecoration(labelText: 'points'),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _achievesController,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 20),
            maxLines: 1,
            decoration: InputDecoration(labelText: 'achieves'),
          )
        ],
      ),
    );

    return cardBuilder(
        title: 'set inital values',
        body: body,
        onCancel: () => settingsBloc.dispatch(LoadSettingsScreen()),
        onOk: () {
          if (_achievesController.text.isEmpty) {
            notificationBloc
                .dispatch(NewError('total achieves cannot be empty'));
            return;
          }
          if (_pointsController.text.isEmpty) {
            notificationBloc.dispatch(NewError('points cannot be empty'));
            return;
          }
          var achievesValue = BigInt.parse(_achievesController.text);
          var pointsValue = BigInt.parse(_pointsController.text);
          if (achievesValue.isNegative || pointsValue.isNegative) {
            notificationBloc.dispatch(NewError('values cannot be negative'));
            return;
          }
          settingsBloc.dispatch(ChangeInitialValue(
              points: pointsValue, totalAchieves: achievesValue));
        });
  }

  Widget nicknameChangerWidget(SettingsBloc settingsBloc,
      NotificationBloc notificationBloc, BaseInfoState infoState) {
    var _nicknameController = TextEditingController();
    _nicknameController.text = infoState.nickname;

    var body = Container(
        width: 200,
        child: TextField(
          controller: _nicknameController,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 20),
          maxLines: 1,
        ));
    return cardBuilder(
        title: 'new nickname',
        body: body,
        onOk: () {
          String text = _nicknameController.text;
          if (text.isEmpty) {
            notificationBloc.dispatch(NewError('nickname cannot be empty'));
          } else if (text.toLowerCase() == infoState.nickname.toLowerCase()) {
            settingsBloc.dispatch(LoadSettingsScreen());
          } else {
            settingsBloc.dispatch(ChangeNickname(nickname: text));
          }
        },
        onCancel: () => settingsBloc.dispatch(LoadSettingsScreen()));
  }

  Widget mainWidget(NotificationBloc notificationBloc, AppBloc appBloc,
      SettingsBloc settingsBloc) {
    return Material(
        child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _rowBuilder(Text('change nickname', style: TextStyle(fontSize: 25),), () {
            settingsBloc.dispatch(OpenNicknameInputWidget());
          }),
          _rowBuilder(Text('set initial values', style: TextStyle(fontSize: 25)),
              () => settingsBloc.dispatch(OpenInitialValueWidget())),
          _rowBuilder(Text('logout', style: TextStyle(color: Colors.redAccent, fontSize: 20),), () {
            appBloc.dispatch(LogoutPress());
            notificationBloc.dispatch(NewMessage('logout'));
          }),
        ],
      ),
    ));
  }

  Widget _rowBuilder(Text text, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        child: Center(child: text),
      ),
    );
  }
}
