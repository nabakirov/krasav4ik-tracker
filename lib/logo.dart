
import 'package:flutter/cupertino.dart';

class Logo extends StatelessWidget {

  @override
  Widget build (BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Krasav4ik',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          )
        ),
        Text('Tracker')
      ],
    );
  }
}