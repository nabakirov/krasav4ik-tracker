import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:krasav4ik/models/models.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  Web3Client web3client;
  DeployedContract contract;
  Credentials credentials;
  ContractFunction contractEmployees;
  ContractFunction contractGetAddresses;
  EthereumAddress address;
  StreamSubscription _updateSubscription;
  NotificationBloc notificationBloc;

  ChartBloc(
      {@required this.web3client,
      @required this.contract,
      @required this.credentials,
      @required this.notificationBloc}) {
    contractEmployees = contract.function('employees');
    contractGetAddresses = contract.function('getAddresses');
  }

  @override
  ChartState get initialState => BaseChartState(items: []);

  @override
  Stream<ChartState> mapEventToState(
    ChartEvent event,
  ) async* {
    if (event is LoadChartList) {
      yield await _update();
      _updateSubscription =
          Stream.periodic(Duration(seconds: 10)).listen((dynamic) {
        dispatch(FetchChartList());
      });
    } else if (event is FetchChartList) {
      yield await _update();
    }
  }

  Future<BaseChartState> _update() async {
    List<UserModel> users = [];
    var addresses = await web3client.call(contract: contract, function: contractGetAddresses, params: []);
    for (int i = 0; i < addresses.length; i++) {
      var address = addresses[i];
      var _rawData = await web3client.call(contract: contract, function: contractEmployees, params: [address[0]]);
      users.add(UserModel(
        address: address[0].toString(),
        nickname: _rawData[2].toString(),
        points: _rawData[1].toInt(),
        totalAchieves: _rawData[4].toInt()
      ));
    }
    users.sort((a, b) {
      if (a.totalAchieves == b.totalAchieves) {
        return a.points.compareTo(b.points) * -1;
      }
      return a.totalAchieves.compareTo(b.totalAchieves) * -1;
    });
    return BaseChartState(items: users);
  }

}