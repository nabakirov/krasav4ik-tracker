import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import './bloc.dart';
import 'package:web3dart/web3dart.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Credentials credentials;
  Web3Client web3client;
  DeployedContract contract;

  ContractFunction employeesFunction;
  ContractFunction prizePointAmountFunstion;
  ContractFunction prizePointCountFunstion;
  ContractFunction plusFunction;
  ContractFunction minusFunction;

  HomeBloc({
    @required this.credentials,
    @required this.web3client,
    @required this.contract
  }) {
    employeesFunction = contract.function('employees');
    prizePointAmountFunstion = contract.function('prizePointAmount');
    prizePointCountFunstion = contract.function('prizePointCount');
    plusFunction = contract.function('plus');
    minusFunction = contract.function('minus');
  }

  @override
  HomeState get initialState => InitialHomeState();

  String username = 'no username';
  double balance = 0;
  int points = 0; 
  int maxPoints = 0;
  int achieves = 0;
  double achivePrize = 0;

  Future _init() async {
    var userAddress = await credentials.extractAddress();
    var _balance = await web3client.getBalance(userAddress);
    balance = _balance.getValueInUnit(EtherUnit.ether);

    var data = await web3client.call(
      contract: contract, function: employeesFunction, params: [userAddress]
    );
    points = data[1].toInt();
    username = data[2].toString();
    achieves = data[4].toInt();
    
    var prizeAmount = await web3client.call(
      contract: contract, function: prizePointAmountFunstion, params: []
    );
    var prizeCount = await web3client.call(
      contract: contract, function: prizePointCountFunstion, params: []
    );
    achivePrize = prizeAmount[0].toDouble() / pow(10, 18);
    maxPoints = prizeCount[0].toInt();
  }

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    print('EVENT!!!!!!!!!! $event');
    if (event is Update) {
      await _init();
      yield HomeStateWithData();
    }
  }
}
