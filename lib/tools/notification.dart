import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:krasav4ik/configs.dart' as config;
import 'package:krasav4ik/tools/modal.dart';
import 'package:krasav4ik/tools/tools.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class NotificationWidget extends StatelessWidget {
  Widget _build(BuildContext context) {
    var notificationBloc = BlocProvider.of<NotificationBloc>(context);
    var state = notificationBloc.currentState;
    if (state is EmptyState) {
      return Container();
    }
    if (state is TxnState) {
      return _opacityLayer(_loadingWidget(state));
    } else if (state is TransactionInfo) {
      var receipt = state.transactionReceipt;
      if (receipt.status) {
        return _opacityLayer(_txnInfo(receipt, notificationBloc));
      } else {
        return _opacityLayer(_txnFailed(receipt, notificationBloc));
      }
    } else {
      return _topBarNotification(state);
    }
  }

  Widget _opacityLayer(Widget body) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: Opacity(
          opacity: 0.5,
          child: Container(
            color: Colors.grey,
          ),
        )),
        Center(
          child: body,
        )
      ],
    );
  }

  Widget _loadingWidget(TxnState state) {
    return Container(
      height: 100,
      width: 200,
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            link(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'view on etherscan',
                      style: TextStyle(color: Colors.blue),
                    ),
                    Text(
                      getShortenAddress(address: state.txnHash),
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                url: '${config.etherscan}${state.txnHash}'),
            Loader()
          ],
        ),
      ),
    );
  }

  Widget _txnInfo(
      TransactionReceipt receipt, NotificationBloc notificationBloc) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('transaction info', style: TextStyle(fontSize: 20),),
          _rowBuilder(Text('block number'),
              Text(receipt.blockNumber.blockNum.toString())),
          _rowBuilder(Text('gas used'), Text(receipt.gasUsed.toString())),
          FlatButton(
            child: Text('close', style: TextStyle(color: Colors.blue)),
            onPressed: () => notificationBloc.dispatch(HideNotificationBar()),
          )
        ],
      ),
    );
  }

  Widget _txnFailed(
      TransactionReceipt receipt, NotificationBloc notificationBloc) {
        var txnHash = bytesToHex(receipt.transactionHash, include0x: true);
    return Container(
      width: 200,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('transaction not sent'),
            link(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'view on etherscan',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Text(
                        getShortenAddress(address: txnHash),
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  url: '${config.etherscan}$txnHash'),
            FlatButton(
              child: Text('close', style: TextStyle(color: Colors.blue)),
              onPressed: () => notificationBloc.dispatch(HideNotificationBar()),
            )
          ],
        ),
      ),
    );
  }

  Widget _rowBuilder(Widget title, Widget body) {
    return Container(
      width: 250,
      padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          title,
          body
        ],
      ),
    );
  }

  Widget _topBarNotification(state) {
    Color backgroundColor;
    List<Widget> children;
    if (state is ErrorState) {
      backgroundColor = Colors.red;
      children = [Text(state.message)];
    } else if (state is MessageState) {
      backgroundColor = Colors.green;
      children = [Text(state.message)];
    } else if (state is TxnState) {
      children = [txnCard(state.txnHash)];

      backgroundColor = Colors.green;
    }
    return SafeArea(
      child: Material(
        child: Container(
            height: 50,
            color: backgroundColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: children)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return _build(context);
      },
    );
  }

  Widget txnCard(String txnHash) {
    return InkWell(
      child: Container(
          child:
              Text('view on etherscan', style: TextStyle(color: Colors.blue))),
      onTap: () => launch('${config.etherscan}$txnHash'),
    );
  }
}
