export './loader.dart';
export './notification.dart';
export './logo.dart';
export './modal.dart';
export './image_builder.dart';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

String getShortenAddress({String address, int count: 7}) {
    int length = address.length;
    String shorten = address.substring(0, count) +
        '...' +
        address.substring(length - count, length);
    return shorten;
  }

Widget link({@required Widget child, @required String url}) {
    return InkWell(
      onTap: () => launch(url),
      child: child,
    );
  }