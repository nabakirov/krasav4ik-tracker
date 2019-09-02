import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:web3dart/web3dart.dart';
import './bloc.dart';
import 'package:krasav4ik/configs.dart' as config;

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  Web3Client web3client;
  DeployedContract contract;
  Credentials credentials;
  ContractFunction contractEmployees;
  ContractFunction contractChangeNickname;
  ContractFunction contractSetInitialValue;
  EthereumAddress address;
  StreamSubscription _transactionInfo;

  NotificationBloc notificationBloc;

  SettingsBloc(
      {@required this.web3client,
      @required this.contract,
      @required this.credentials,
      @required this.notificationBloc}) {
    contractEmployees = contract.function('employees');
    contractChangeNickname = contract.function('changeNickname');
    contractSetInitialValue = contract.function('setInitialValue');
  }
  @override
  SettingsState get initialState => BaseSettingsState();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is PullSettingsEvent) {
      if (address == null) {
        address = await credentials.extractAddress();
      }
      yield BaseSettingsState();
    } else if (event is ChangeNickname) {
      try {
        String txnHash = await web3client.sendTransaction(
            credentials,
            Transaction.callContract(
                contract: contract,
                function: contractChangeNickname,
                parameters: [event.nickname],
                gasPrice: EtherAmount.inWei(BigInt.from(config.gasPriceInWei)),
                maxGas: config.maxGas),
            fetchChainIdFromNetworkId: true);
        notificationBloc.dispatch(ShowTransactionHash(txnHash: txnHash));
        _waitTransactionInfo(txnHash);
      } catch (_) {
        notificationBloc.dispatch(NewError('something went wrong'));
      }
      yield BaseSettingsState();
    } else if (event is OpenNicknameInputWidget) {
      yield NicknameInputState();
    } else if (event is LoadSettingsScreen) {
      yield BaseSettingsState();
    } else if (event is OpenInitialValueWidget) {
      yield InitialValueInputState();
    } else if (event is ChangeInitialValue) {
      String txnHash = await web3client.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract,
              function: contractSetInitialValue,
              parameters: [address, event.points, event.totalAchieves],
              gasPrice: EtherAmount.inWei(BigInt.from(config.gasPriceInWei)),
              maxGas: config.maxGas),
          fetchChainIdFromNetworkId: true);
      notificationBloc.dispatch(ShowTransactionHash(txnHash: txnHash));
      _waitTransactionInfo(txnHash);
      yield BaseSettingsState();
    }
  }

  void _waitTransactionInfo(String txnHash) {
    _transactionInfo =
        Stream.periodic(Duration(seconds: 5)).listen((dynamic) async {
      TransactionReceipt response =
          await web3client.getTransactionReceipt(txnHash);
      print('getTransactionReceipt of $txnHash = $response');
      if (response != null) {
        notificationBloc.dispatch(ShowTransactionInfo(
            transactionReceipt: response,
            postAction: () => _transactionInfo?.cancel()));
      }
    });
  }
}
