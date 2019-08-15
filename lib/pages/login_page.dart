import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/pages/logo.dart';
import 'package:krasav4ik/bloc/bloc.dart';

class ActionWidgets extends StatelessWidget {
  final _privateKeyController = TextEditingController();
  final AppBloc appBloc;
  final MessageBloc messageBloc;

  ActionWidgets({@required this.appBloc, @required this.messageBloc});
  void _paste() async {
    var data = await Clipboard.getData('text/plain');
    _privateKeyController.text = data.text;
  }

  Widget privateKeyInput(AppBloc appBloc) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('private key'),
          TextField(
            controller: _privateKeyController,
            autocorrect: false,
            autofocus: true,
            textCapitalization: TextCapitalization.none,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
            maxLines: 5,
            minLines: 1,
          ),
          FlatButton(
            child: Text('paste'),
            onPressed: _paste,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        privateKeyInput(appBloc),
        RaisedButton(
          child: Text('login'),
          onPressed: () {
            String key = _privateKeyController.text;
            print(key);
            if (key.isEmpty) {
              messageBloc.dispatch(ErrorMessage(message: 'private key is empty'));
              return null;
            } else {
              return appBloc.dispatch(LoginBtnPressed(privateKey: key));
            }
          },
        ),
      ],
    ));
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);
    var messageBloc = BlocProvider.of<MessageBloc>(context);
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(50, 180, 50, 100),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[Logo(), ActionWidgets(appBloc: appBloc, messageBloc: messageBloc,)],
            )));
  }
}
