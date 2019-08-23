import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget modalWidgetGenerator(Widget background, Function onBackgroundTap, Widget modal) {
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
          )
        ),
        Center(child: modal)
      ],
    )
  );
}