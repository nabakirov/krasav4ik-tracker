import 'package:flutter/material.dart';
import 'package:krasav4ik/pages/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            
            children: <Widget>[
              Logo(),
              
              

              RaisedButton(
                child: Text('login'),
                onPressed: () => null,
              ),
            ],
          ),
    );
  }
}