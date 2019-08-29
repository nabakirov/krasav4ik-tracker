import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';
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
  ContractFunction contractBalance;
  EthereumAddress address;
  StreamSubscription _updateSubscription;

  NotificationBloc notificationBloc;

  InfoBloc(
      {@required this.web3client,
      @required this.contract,
      @required this.credentials,
      @required this.notificationBloc}) {
    contractEmployees = contract.function('employees');
    contractMaxPointCount = contract.function('prizePointCount');
    contractAchievePrize = contract.function('prizePointAmount');
    contractPlus = contract.function('plus');
    contractMinus = contract.function('minus');
    contractBalance = contract.function('balance');
  }

  @override
  InfoState get initialState => BaseInfoState();

  @override
  void dispose() {
    _updateSubscription?.cancel();
    super.dispose();
  }

  @override
  Stream<InfoState> mapEventToState(
    InfoEvent event,
  ) async* {
    if (event is InfoInitialize) {
      yield await _update();
      _updateSubscription =
          Stream.periodic(Duration(seconds: 5)).listen((dynamic) {
        dispatch(UpdateInfo());
      });
    } else if (event is UpdateInfo) {
      yield await _update();
    } else if (event is PlusPointPress) {
      _updateSubscription.resume();
      yield event.infoState;
      try {
        var txnHash = await _plusPointPress();
        notificationBloc.dispatch(ShowTransactionHash(txnHash: txnHash));
      } catch (_) {
        notificationBloc.dispatch(NewError('something went wrong'));
      }
    } else if (event is MinusPointPress) {
      _updateSubscription.resume();
      yield event.infoState;
      try {
        var txnHash = await _minusPointPress();
        notificationBloc.dispatch(ShowTransactionHash(txnHash: txnHash));
      } catch (_) {
        notificationBloc.dispatch(NewError('something went wrong'));
      }
      yield await _update();
    } else if (event is OpenConfirmationWidget) {
      _updateSubscription.pause();
      yield ConfirmationState(isPlus: event.isPlus, prevState: event.state);
    } else if (event is CloseConfirmationWidget) {
      _updateSubscription.resume();
      yield event.infoState;
    }
  }

  Future<String> _plusPointPress() async {
    String transactionHash = await web3client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: contractPlus, parameters: []),
        fetchChainIdFromNetworkId: true);
    return transactionHash;
  }

  Future<String> _minusPointPress() async {
    String transactionHash = await web3client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: contractMinus, parameters: []),
        fetchChainIdFromNetworkId: true);
    return transactionHash;
  }

  Future<BaseInfoState> _update() async {
    if (address == null) {
      address = await credentials.extractAddress();
    }
    var userData = await web3client.call(
        contract: contract, function: contractEmployees, params: [address]);
    var maxPointCaunt = await web3client
        .call(contract: contract, function: contractMaxPointCount, params: []);
    var achievePrize = await web3client
        .call(contract: contract, function: contractAchievePrize, params: []);
    var balance = await web3client.getBalance(address);
    var smartBalance = await web3client.call(contract: contract, function: contractBalance, params: []);

    return BaseInfoState(
        balance: balance.getValueInUnit(EtherUnit.ether),
        contractBalance: smartBalance[0].toDouble() / pow(10, 18),
        pointCount: userData[1].toInt(),
        nickname: userData[2].toString(),
        achieveCount: userData[4].toInt(),
        achievePrize: achievePrize[0].toDouble() / pow(10, 18),
        maxPointCount: maxPointCaunt[0].toInt());
  }
}
