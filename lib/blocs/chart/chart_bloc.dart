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
  ChartState get initialState => ChartLoadingState();

  @override
  Stream<ChartState> mapEventToState(
    ChartEvent event,
  ) async* {
    if (event is LoadChartList) {
      yield await _update();
    } else if (event is FetchChartList) {
      yield await _update();
    }
  }

  Future<BaseChartState> _update() async {
    List<UserModel> users = [];
    var addresses = await web3client.call(contract: contract, function: contractGetAddresses, params: []);
    addresses = addresses[0];
    for (int i = 0; i < addresses.length; i++) {
      var address = addresses[i];
      var _rawData = await web3client.call(contract: contract, function: contractEmployees, params: [address]);
      users.add(UserModel(
        address: address.toString(),
        nickname: _rawData[2].toString(),
        points: _rawData[1],
        totalAchieves: _rawData[4]
      ));
    }
    // users.sort((a, b) {
    //   if (a.totalAchieves == b.totalAchieves) {
    //     return a.points.compareTo(b.points) * -1;
    //   }
    //   return a.totalAchieves.compareTo(b.totalAchieves) * -1;
    // });
    return BaseChartState(items: users);
  }

}
