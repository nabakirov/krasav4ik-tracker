import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import './bloc.dart';
import 'package:http/http.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  FlutterSecureStorage secureStorage;
  Credentials credentials;
  String _secureStorageKey = 'privateKey';
  Web3Client web3client;
  DeployedContract contract;

  String rpcUrl;
  String wsUrl;
  String contractAddressHex;
  String contractJson;


  AppBloc(
      {@required this.rpcUrl,
      @required this.wsUrl,
      @required this.contractAddressHex,
      @required this.contractJson});

  Future init() async {
    web3client = new Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
    var contractAddress = EthereumAddress.fromHex(contractAddressHex);
    contract = DeployedContract(
        ContractAbi.fromJson(contractJson, 'Krasav4ik'), contractAddress);
    secureStorage = new FlutterSecureStorage();
  }

  @override
  AppState get initialState => AppStartedState();

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {

    if (event is AppStarted) {
      await init();
      String token = await secureStorage.read(key: _secureStorageKey);
      if (token != null) {
        yield HomePageInitialState();
      } else {
        yield LoginInitialState();
      }
    } 
    
    else if (event is LoginBtnPressed) {
      yield LoadingState();
      var privateKey = event.privateKey;
      try {
        credentials = await web3client.credentialsFromPrivateKey(privateKey);
        await secureStorage.write(key: _secureStorageKey, value: privateKey);
        yield HomePageInitialState();
      } catch (_) {
        yield LoginFailureState();
      }
    } 
    
    else if (event is LoggedOut) {
      yield LoadingState();
      await secureStorage.delete(key: _secureStorageKey);
      yield LoginInitialState();
    }
  }


}
