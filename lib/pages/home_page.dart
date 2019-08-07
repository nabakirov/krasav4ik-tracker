
import 'dart:math';

import 'package:web3dart/web3dart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.ethClient, this.contractAddress, this.userCredentials, this.contract});
  final Web3Client ethClient;
  final EthereumAddress contractAddress;
  final Credentials userCredentials;
  final DeployedContract contract;

  @override
  _HomePageState createState() => new _HomePageState();
}


class _HomePageState extends State<HomePage> {
  double userBalance = 0;
  int pointCount = 0;
  int maxPointCount = 0;
  int achieveCount = 0;
  String nickname = 'no nickname';
  double achivePrize = 0;
  EthereumAddress userAddress;
  bool loaded = false;

  Widget nicknameWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          nickname,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }


  Widget _textBuilder(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
    );
  }

  Widget _rowBuilder(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _etherBalanceBuilder(double balance) {
    return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              balance.toStringAsFixed(3),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              ' eth',
              style: TextStyle(color: Colors.grey, fontSize: 15)
            ),
          ],
        );
  }

  Widget etherBalanceWidget(){
    return _rowBuilder(<Widget>[
      _textBuilder('balance'),
      _etherBalanceBuilder(userBalance)
    ]);
  }
  Widget pointCountWidget() {
    return _rowBuilder([
      _textBuilder('points'),
      Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              pointCount.toString(),
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              '/' + maxPointCount.toString(),
              style: TextStyle(color: Colors.grey, fontSize: 15)
            ),
          ],
        ),
    ]);
  }
  Widget achieveCountWidget() {
    return _rowBuilder([
      _textBuilder('achieves'),
      Text(
        achieveCount.toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)
      ),
    ]);
  }

  Widget contractInfoWidget() {
    return _rowBuilder([
      _textBuilder('achieve prize'),
      _etherBalanceBuilder(achivePrize)
    ]);
  }

  void onButtonPressed(bool isPlus) async {
    ContractFunction functionToCall;
    if (isPlus) {
      functionToCall = widget.contract.function('plus');
    } else {
      functionToCall = widget.contract.function('minus');
    }
    var transactionHash = await widget.ethClient.sendTransaction(widget.userCredentials, Transaction.callContract(contract: widget.contract, function: functionToCall, parameters: []), fetchChainIdFromNetworkId: true);
    print(transactionHash);
  }

  Widget actionButtonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: () => onButtonPressed(false),
          child: Text('-'),
          color: Colors.red
        ),
        RaisedButton(
          onPressed: () => onButtonPressed(true),
          child: Text('+'),
          color: Colors.green
        ),
      ],
    );
  }


  Widget buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        nicknameWidget(),
        etherBalanceWidget(),
        pointCountWidget(),
        achieveCountWidget(),
        contractInfoWidget(),
        actionButtonWidget(),
        FlatButton(
          child: Text('update', style: TextStyle(color: Colors.grey)),
          onPressed: updateState,
        )
      ],
    );
  }

  void updateState() async {
    userAddress = await widget.userCredentials.extractAddress();
    var _balance = await widget.ethClient.getBalance(userAddress);
    userBalance = _balance.getValueInUnit(EtherUnit.ether);


    final employeesFunction = widget.contract.function('employees');
    var userData = await widget.ethClient.call(
      contract: widget.contract, function: employeesFunction, params: [userAddress]
    );
    

    final prizePointAmountFunstion = widget.contract.function('prizePointAmount');
    var prizePointAmount = await widget.ethClient.call(
      contract: widget.contract, function: prizePointAmountFunstion, params: []
    );

    final prizePointCountFunstion = widget.contract.function('prizePointCount');
    var prizePointCount = await widget.ethClient.call(
      contract: widget.contract, function: prizePointCountFunstion, params: []
    );
    setState(() {
      pointCount = userData[1].toInt();
      nickname = userData[2].toString();
      achieveCount = userData[4].toInt();
      userBalance = userBalance;
      userAddress = userAddress;
      achivePrize = prizePointAmount[0].toDouble() / pow(10, 18);
      maxPointCount = prizePointCount[0].toInt();
      loaded = true;
    });

  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      updateState();
    }
    return buildContent();
  }
}