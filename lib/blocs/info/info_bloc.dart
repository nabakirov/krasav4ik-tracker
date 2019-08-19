import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';
import './bloc.dart';
import 'dart:math';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  Web3Client web3client;
  DeployedContract contract;
  Credentials credentials;
  ContractFunction contractEmployees;
  ContractFunction contractMaxPointCount;
  ContractFunction contractAchievePrize;


  InfoBloc({
    @required this.web3client,
    @required this.contract,
    @required this.credentials
  }) {
    contractEmployees = contract.function('employees');
    contractMaxPointCount = contract.function('prizePointCount');
    contractAchievePrize = contract.function('prizePointAmount');
  }

  @override
  InfoState get initialState => BaseInfoState();

  @override
  Stream<InfoState> mapEventToState(
    InfoEvent event,
  ) async* {
    if (event is UpdateInfo) {
      yield await _update();
    }
  }

  Future<BaseInfoState> _update() async {
    var userData = await web3client.call(
      contract: contract, function: contractEmployees, params: []
    );
    var maxPointCaunt = await web3client.call(
      contract: contract, function: contractMaxPointCount, params: []
    );
    var achievePrize = await web3client.call(
      contract: contract, function: contractAchievePrize, params: []
    );
    var balance = await web3client.getBalance(await credentials.extractAddress());


    var baseInfoState = BaseInfoState();
    baseInfoState.balance = balance.getValueInUnit(EtherUnit.ether);
    baseInfoState.pointCount = userData[1].toInt();
    baseInfoState.nickname = userData[2].toString();
    baseInfoState.achieveCount = userData[4].toInt();
    baseInfoState.achievePrize = achievePrize[0].toDouble() / pow(10, 18);
    baseInfoState.maxPointCount = maxPointCaunt[0].toInt();
    return baseInfoState;
  }
}
