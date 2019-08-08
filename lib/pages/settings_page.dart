
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}


class _SettingsPageState extends State<SettingsPage> {

  final storage = new FlutterSecureStorage();

  Widget _rowBuilder(String text, Function onPressed) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          
          FlatButton(child: Text(text, style: TextStyle(fontSize: 20)), onPressed: onPressed,)
        ],
      ),
    );
  }

  void logout() async {
    await storage.delete(key: 'secretKey');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _rowBuilder('logout', logout)
      ],
    );
  }
}