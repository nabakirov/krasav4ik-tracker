import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget modalWidgetGenerator(
    Widget background, Function onBackgroundTap, Widget modal) {
  return Material(
      child: Stack(
    children: <Widget>[
      background,
      Positioned.fill(
          child: Opacity(
        opacity: 0.5,
        child: InkWell(
          child: Container(color: Colors.grey[500]),
          onTap: onBackgroundTap,
        ),
      )),
      Center(child: modal)
    ],
  ));
}

Widget cardBuilder(
    {@required String title,
    Widget body,
    @required Function onOk,
    @required Function onCancel}) {
  return Card(
      color: Colors.white,
      child: Container(
        width: 250,
        // height: 150,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)))),
              body,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'cancel',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: onCancel,
                  ),
                  FlatButton(
                    child: Text('save',
                        style: TextStyle(color: Colors.blueAccent)),
                    onPressed: onOk,
                  )
                ],
              )
            ]),
      ));
}
