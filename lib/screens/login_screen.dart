import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:krasav4ik/tools/tools.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatelessWidget {
  NotificationBloc notificationBloc;
  AppBloc appBloc;
  final _privateKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    appBloc = BlocProvider.of<AppBloc>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[Logo(), privateKeyInput()],
        ),
      ),
    );
  }

  void _pasteFromClipboard() async {
    var data = await Clipboard.getData('text/plain');
    if (data != null) {
      _privateKeyController.text = data.text;
    }
  }

  Widget privateKeyInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        children: <Widget>[
          Text('private key'),
          TextField(
            controller: _privateKeyController,
            autocorrect: false,
            autofocus: false,
            textCapitalization: TextCapitalization.none,
            // textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
            maxLines: 5,
            minLines: 1,
          ),
          FlatButton(
            child: Text('paste'),
            onPressed: _pasteFromClipboard,
          ),
          RaisedButton(
            child: Text('login'),
            onPressed: () {
              String key = _privateKeyController.text;
              print(key);
              if (key.isEmpty) {
                notificationBloc.dispatch(NewError('private key is empty'));
                return null;
              } else {
                return appBloc.dispatch(LoginPress(key));
              }
            },
          )
        ],
      ),
    );
  }
}
