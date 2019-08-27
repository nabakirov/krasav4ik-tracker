import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:web3dart/web3dart.dart';
import './bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  Web3Client web3client;
  DeployedContract contract;
  Credentials credentials;
  ContractFunction contractEmployees;
  ContractFunction contractChangeNickname;
  ContractFunction contractSetInitialValue;
  EthereumAddress address;

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
                parameters: [event.nickname]),
            fetchChainIdFromNetworkId: true);
        notificationBloc.dispatch(ShowTransactionHash(txnHash: txnHash));
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
              parameters: [address, event.points, event.totalAchieves]),
          fetchChainIdFromNetworkId: true);
      notificationBloc.dispatch(ShowTransactionHash(txnHash: txnHash));
      yield BaseSettingsState();
    }
  }
}
