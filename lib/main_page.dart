import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'logo.dart';
import 'contract/abi.dart';

enum Page {
  homePage,
  settings
}


class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => new _MainPageState();
}


class _MainPageState extends State<MainPage> {

  Page currectPage = Page.homePage;
  
  String rpcUrl = 'http://ropsten.fridayte.ch';
  String wsUrl = 'ws://ropsten.fridayte.ch:5001';
  EthereumAddress contractAddress = EthereumAddress.fromHex('0xb012241f80f77a728b144a50be2c3f8135bd7ca8');
  String userPrivateKey = '';
  Credentials userCredentials;
  Client httpClient;
  Web3Client ethClient;
  File abiFile;
  DeployedContract contract;


  bool isLoading = false;
  bool isStartedLoading = false;

  BottomNavigationBarItem _buildItem({IconData icon, String text}) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: Colors.grey[500]),
      title: Text(text, style: TextStyle(color: Colors.grey[500])),
      backgroundColor: Colors.white
    );
  }

  void pageChanged(Page page) {
    setState(() {
      currectPage = page;
    });
  }

  void _onSelectTap(int index) {
    switch(index) {
      case 0: 
        pageChanged(Page.homePage);
        break;
      case 1: 
        pageChanged(Page.settings);
        break;
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(icon: Icons.view_headline, text: 'Home'),
        _buildItem(icon: Icons.traffic, text: 'Settings')
      ],
      onTap: _onSelectTap,
    );
  }

  Widget _buildBody() {
    switch (currectPage) {
      case Page.homePage: return HomePage(
        ethClient: ethClient, 
        contractAddress: 
        contractAddress, 
        userCredentials: 
        userCredentials, 
        contract: contract,);
      case Page.settings: return SettingsPage();
    }
  }

  Widget get _loadingView {
    return new Center(
      child: Logo()
    );
  }

  void init() async {
    
    var _contract = DeployedContract(ContractAbi.fromJson(abiJsonString, 'MetaCoin'), contractAddress);
    isStartedLoading = true;
    isLoading = true;
    ethClient = new Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });

    ethClient.credentialsFromPrivateKey(userPrivateKey).then((value){
      setState(() {
        userCredentials = value;
        contract = _contract;
        isLoading = false;
      });
    });
  }

  Widget _pageToDisplay() {
    print(isStartedLoading);
    print(isLoading);
    if (isStartedLoading) {
      if (!isLoading) {
        return app();
      }
    } else {
      init();
    }
    return _loadingView;
  }

  Widget app() {
    return Scaffold(
      appBar: AppBar(title: Text('Krasav4ik tracker'),),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return _pageToDisplay();
  }
}