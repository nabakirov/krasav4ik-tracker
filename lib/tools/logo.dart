import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Krasav4ik',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
            )),
        Text(
          'Tracker',
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }
}

class LogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Center(
            child: Logo(),
          )),
    );
  }
}