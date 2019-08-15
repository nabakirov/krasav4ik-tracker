import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/pages/logo.dart';
import 'package:krasav4ik/bloc/bloc.dart';


class LoginPage extends StatelessWidget {
  final _privateKeyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);
    return Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            
            children: <Widget>[
              Logo(),
              
              privateKeyInput(),

              RaisedButton(
                child: Text('login'),
                onPressed: () => appBloc.dispatch(LoginBtnPressed(privateKey: _privateKeyController.text)),
              ),
            ],
          ),
    );
  }

  void _paste() async {
    var data = await Clipboard.getData('text/plain');
    _privateKeyController.text = data.text;
  }

  Widget privateKeyInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('private key'),
          
          TextField(
            // decoration: InputDecoration(
            //   errorText: isUserPrivateKeyInvalid ? 'invalid key': null
            // ),
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
            onPressed: _paste ,
          ),
        ],
      ),
    );
  }
}