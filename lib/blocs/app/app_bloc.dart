import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/credentials.dart';
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


  AppBloc({
    this.rpcUrl,
    this.wsUrl,
    this.contractAddressHex,
    this.contractJson
  });

  @override
  AppState get initialState => AppLoadingState();


  Future _init() async {
    web3client = new Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
    var contractAddress = EthereumAddress.fromHex(contractAddressHex);
    contract = DeployedContract(
        ContractAbi.fromJson(contractJson, 'Krasav4ik'), contractAddress);
    secureStorage = new FlutterSecureStorage();
  }


  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is InitializeApp) {
      yield* _mapInitializeAppToState();
    } else if (event is LoginPress) {
      yield* _mapLoginPressToState(event);
    } else if (event is LogoutPress) {
      yield* _mapLogoutPressToState();
    }
  }

  Stream<AppState> _mapInitializeAppToState() async* {
    await _init();
    final privateKey = await secureStorage.read(key: _secureStorageKey);
    if (privateKey != null) {
      credentials = await web3client.credentialsFromPrivateKey(privateKey);
      yield HomePageState();
    } else {
      yield LoginPageState(failed: false);
    }
  }
  
  Stream<AppState> _mapLoginPressToState(LoginPress event) async* {
    var privateKey = event.privateKey;
      try {
        credentials = await web3client.credentialsFromPrivateKey(privateKey);
        await secureStorage.write(key: _secureStorageKey, value: privateKey);
        yield HomePageState();
      } catch (_) {
        yield LoginPageState(failed: true);
      }
  }

  Stream<AppState> _mapLogoutPressToState() async* {
      await secureStorage.delete(key: _secureStorageKey);
      yield LoginPageState(failed: false);
  }
}
