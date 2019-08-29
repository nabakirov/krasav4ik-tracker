import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget imgBuilder(String path) {
    return Material(
      child: Image.asset(path),
    );
  }