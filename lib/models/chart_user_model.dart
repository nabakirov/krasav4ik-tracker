import 'package:flutter/material.dart';

class UserModel {
  String address;
  String nickname;
  int totalAchieves;
  int points;

  UserModel({
    @required this.address,
    @required this.nickname,
    @required this.totalAchieves,
    @required this.points
  });
}