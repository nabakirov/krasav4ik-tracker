import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget modalWidgetGenerator({
    Widget background, Function onBackgroundTap, Widget modal}) {
  List<Widget> items;
  if (background == null) {
    items = [_opacityLayer(onBackgroundTap), Center(child: modal)];
  } else {
    items = [background, _opacityLayer(onBackgroundTap), Center(child: modal)];
  }
  return Material(
      child: Stack(
    children: items,
  ));
}

Widget _opacityLayer(Function onBackgroundTap) {
  return Positioned.fill(
      child: Opacity(
    opacity: 0.5,
    child: InkWell(
      child: Container(color: Colors.grey[500]),
      onTap: onBackgroundTap,
    ),
  ));
}

Widget _title(String title) {
  return Center(
      child: Container(
          padding: EdgeInsets.only(top: 15),
          child: Text(title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))));
}

Widget _buttons(
    String cancelText, Function onCancel, String okText, Function onOk) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          child: Text(
            cancelText,
            style: TextStyle(color: Colors.redAccent),
          ),
          onPressed: onCancel,
        ),
        FlatButton(
          child: Text(okText, style: TextStyle(color: Colors.blueAccent)),
          onPressed: onOk,
        )
      ]);
}

Widget cardBuilder(
    {@required String title,
    Widget body,
    @required Function onOk,
    @required Function onCancel,
    String cancelText: 'cancel',
    String okText: 'save'}) {
  var children;
  if (body != null) {
    children = [
      _title(title),
      body,
      _buttons(cancelText, onCancel, okText, onOk)
    ];
  } else {
    children = [
      _title(title),
      SizedBox(
        height: 20,
      ),
      _buttons(cancelText, onCancel, okText, onOk)
    ];
  }
  return Card(
      color: Colors.white,
      child: Container(
          width: 250,
          // height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: children,
          )));
}
