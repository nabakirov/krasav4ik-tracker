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
  ContractFunction contractPlus;
  ContractFunction contractMinus;

  InfoBloc(
      {@required this.web3client,
      @required this.contract,
      @required this.credentials}) {
    contractEmployees = contract.function('employees');
    contractMaxPointCount = contract.function('prizePointCount');
    contractAchievePrize = contract.function('prizePointAmount');
    contractPlus = contract.function('plus');
    contractMinus = contract.function('minus');
  }

  @override
  InfoState get initialState => BaseInfoState();

  @override
  Stream<InfoState> mapEventToState(
    InfoEvent event,
  ) async* {
    if (event is UpdateInfo) {
      yield await _update();
    } else if (event is PlusPointPress) {
      var txnHash = await _plusPointPress();
      yield CreatedInfoState(txnHash: txnHash);
    } else if (event is MinusPointPress) {
      var txnHash = await _minusPointPress();
      yield CreatedInfoState(txnHash: txnHash);
    }
  }

  Future<String> _plusPointPress() async {
    String transactionHash = await web3client.sendTransaction(credentials, 
    Transaction.callContract(contract: contract, function: contractPlus, parameters: []), fetchChainIdFromNetworkId: true);
    return transactionHash;
  }

  Future<String> _minusPointPress() async {
    String transactionHash = await web3client.sendTransaction(credentials, 
    Transaction.callContract(contract: contract, function: contractMinus, parameters: []), fetchChainIdFromNetworkId: true);
    return transactionHash;
  }

  Future<BaseInfoState> _update() async {
    var userData = await web3client
        .call(contract: contract, function: contractEmployees, params: []);
    var maxPointCaunt = await web3client
        .call(contract: contract, function: contractMaxPointCount, params: []);
    var achievePrize = await web3client
        .call(contract: contract, function: contractAchievePrize, params: []);
    var balance =
        await web3client.getBalance(await credentials.extractAddress());

    return BaseInfoState(
      balance: balance.getValueInUnit(EtherUnit.ether),
      pointCount: userData[1].toInt(),
      nickname: userData[2].toString(),
      achieveCount: userData[4].toInt(),
      achievePrize: achievePrize[0].toDouble() / pow(10, 18),
      maxPointCount: maxPointCaunt[0].toInt()
    );
  }
}
