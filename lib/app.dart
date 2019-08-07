import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'logo.dart';

var rpcUrl = 'http://ropsten.fridayte.ch';
var contractAddress = '0x2e8dA0868e46fc943766a98b8D92A0380B29CE2A';


class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  String balance = '';
  int blockNum = 0;
  static var httpClient = new Client();
  var ethClient = new Web3Client(rpcUrl, httpClient);
  final TextEditingController controller = TextEditingController();

  int currentState = 8;
  int maxTotalPoints = 10;
  int totalArchieves = 3;
  double archievePrize = 0.01;


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 10), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Logo()),
              Expanded(child: Spacer()),


              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'current state',
                            style: TextStyle(
                              color: Colors.grey[500]
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Text(
                                    currentState.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50
                                    ),
                                  ),
                              ),
                              Text(
                                '/' + maxTotalPoints.toString(),
                                style: TextStyle(
                                  color: Colors.grey[500]
                                ),
                              )
                            ],
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'total achieves',
                            style: TextStyle(
                              color: Colors.grey[500]
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Text(
                                    totalArchieves.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 40
                                    ),
                                  ),
                              ),
                              
                              
                            ],
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
              ),



              Expanded(
                child: CupertinoButton(
                  child: Text('eth call'),
                  onPressed: () => ethCall(),
                ),
              ),
              Text("address: " + contractAddress),
              Text('blockNum: ' + blockNum.toString()),
              Text('balance: ' + balance),

            ],
          ),
        ),
      )
    );
  }

  ethCall() {
    ethClient.getBlockNumber().then((val) {
       setState(() {
       blockNum = val;
     });
    });
    var _balance = ethClient.getBalance(EthereumAddress.fromHex(contractAddress));
    _balance.then((val) {
      setState(() {
       balance = val.getValueInUnit(EtherUnit.ether).toString();
     });
    });

     
  }

}