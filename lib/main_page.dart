import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  String userPrivateKey;
  // String userPrivateKey = '9857c0274f686e96653680cd176efa3001ef670567cc65ff91862e966d40ba19';
  Credentials userCredentials;
  Client httpClient;
  Web3Client ethClient;
  File abiFile;
  DeployedContract contract;
  bool isUserPrivateKeyInvalid = false;

  final storage = new FlutterSecureStorage();


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

  void _initPrivateKey() async {
    try{
      userCredentials = await ethClient.credentialsFromPrivateKey(userPrivateKey);
      isLoading = false;
      await storage.write(key: 'secretKey', value: userPrivateKey);
    } on FormatException {
      isLoading = true;
      isUserPrivateKeyInvalid = true;
    }
  }

  void _initWeb3() async {
    contract = DeployedContract(ContractAbi.fromJson(abiJsonString, 'MetaCoin'), contractAddress);
    ethClient = new Web3Client(rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUrl).cast<String>();
    });
  }


  void init() async {
    isLoading = true;
    isStartedLoading = true;
    await _initWeb3();
    userPrivateKey = await storage.read(key: 'secretKey');
    if (userPrivateKey != null) {
      await _initPrivateKey();
    }
    setState(() {
      isLoading = isLoading;
      isStartedLoading = isStartedLoading;
    });
  }

  Widget privateKeyInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('private key'),
          TextField(
            decoration: InputDecoration(
              errorText: isUserPrivateKeyInvalid ? 'invalid key': null
            ),
            onChanged: (text) {
              
              setState(() {
                userPrivateKey = text;
                isUserPrivateKeyInvalid = false;
              });
            },
            autocorrect: false,
            autofocus: true,
            textCapitalization: TextCapitalization.none,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
            maxLines: 5,
            minLines: 1,
          ),
        ],
      ),
    );
  }

  void loginBtnOnPressed() async {
    await _initPrivateKey();

    setState(() {
      contract = contract;
      ethClient = ethClient;
      isLoading = isLoading;
      userCredentials = userCredentials;
    });
  }

  Widget loginWidget() {
    return Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Logo(),
              
              privateKeyInput(),

              RaisedButton(
                child: Text('login'),
                onPressed: () => loginBtnOnPressed(),
              ),
            ],
          ),
    );
  }

  Widget _pageToDisplay() {
    if (isStartedLoading) {
      if (!isLoading) {
        return app();
      } else {
        return loginWidget();
      }
    } else {
      init();
    }
    return Scaffold(
      body: Center(child: Logo(),)
      );
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