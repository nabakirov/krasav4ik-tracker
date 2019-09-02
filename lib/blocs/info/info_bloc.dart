import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:krasav4ik/configs.dart' as config;
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
  StreamSubscription _transactionInfo;

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
  InfoState get initialState => InfoLoadingState();

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
      yield event.infoState;
      try {
        var txnHash = await _plusPointPress();
        notificationBloc.dispatch(ShowTransactionHash(txnHash: txnHash));
        _waitTransactionInfo(txnHash);
      } catch (_) {
        notificationBloc.dispatch(NewError('something went wrong'));
      }
      _updateSubscription.resume();
    } else if (event is MinusPointPress) {
      yield event.infoState;
      try {
        var txnHash = await _minusPointPress();
        notificationBloc.dispatch(ShowTransactionHash(txnHash: txnHash));
        _waitTransactionInfo(txnHash);
      } catch (_) {
        notificationBloc.dispatch(NewError('something went wrong'));
      }
      _updateSubscription.resume();
    } else if (event is OpenConfirmationWidget) {
      _updateSubscription.pause();
      yield ConfirmationState(isPlus: event.isPlus, prevState: event.state);
    } else if (event is CloseConfirmationWidget) {
      _updateSubscription.resume();
      yield event.infoState;
    }
  }

  void _waitTransactionInfo(String txnHash) {
    _transactionInfo =
        Stream.periodic(Duration(seconds: 5)).listen((dynamic) async {
      TransactionReceipt response =
          await web3client.getTransactionReceipt(txnHash).catchError((dynamic) {
            notificationBloc.dispatch(NewError('web3 call failed'));
            _transactionInfo.cancel();
          });
      print('getTransactionReceipt of $txnHash = $response');
      if (response != null) {
        notificationBloc.dispatch(ShowTransactionInfo(
            transactionReceipt: response,
            postAction: () => _transactionInfo?.cancel()));
      }
    });
  }

  Future<String> _plusPointPress() async {
    return await _btnPress(contractPlus);
  }

  Future<String> _minusPointPress() async {
    return await _btnPress(contractMinus);
  }

  Future<String> _btnPress(ContractFunction function) async {
    String transactionHash = await web3client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: function,
            parameters: [],
            maxGas: config.maxGas,
            gasPrice: EtherAmount.inWei(BigInt.from(config.gasPriceInWei))),
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
    var smartBalance = await web3client
        .call(contract: contract, function: contractBalance, params: []);

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
