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
  EthereumAddress address;

  NotificationBloc notificationBloc;

  SettingsBloc(
      {@required this.web3client,
      @required this.contract,
      @required this.credentials,
      @required this.notificationBloc}) {
    contractEmployees = contract.function('employees');
    contractChangeNickname = contract.function('changeNickname');
  }
  @override
  SettingsState get initialState =>
      BaseSettingsState(nickname: 'no nickname', address: '0x0');

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is PullSettingsEvent) {
      if (address == null) {
        address = await credentials.extractAddress();
      }
      var userData = await web3client.call(
          contract: contract, function: contractEmployees, params: [address]);
      yield BaseSettingsState(
          nickname: userData[2].toString(), address: address.toString());
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
      yield BaseSettingsState(nickname: event.nickname, address: event.address);
      dispatch(PullSettingsEvent());
    } else if (event is OpenNicknameInputWidget) {
      yield NicknameInputState(baseState: event.baseState);
    }
  }
}
