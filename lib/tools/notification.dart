import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:krasav4ik/configs.dart' as config;
import 'package:url_launcher/url_launcher.dart';

class NotificationWidget extends StatelessWidget {
  Widget _build(BuildContext context) {
    var notificationBloc = BlocProvider.of<NotificationBloc>(context);
    var state = notificationBloc.currentState;
    if (state is EmptyState) {
      return Container();
    }
    Color backgroundColor;
    List<Widget> children;
    Function onTap;
    if (state is ErrorState) {
      backgroundColor = Colors.red;
      children = [Text(state.message)];
      onTap() => {};
    } else if (state is MessageState) {
      backgroundColor = Colors.green;
      children = [Text(state.message)];
      onTap() => {};
    } else if (state is TxnState) {

      children = [txnCard(state.txnHash)];
      
      backgroundColor = Colors.green;
      onTap() => launch('${config.etherscan}$state.txnHash');
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
              children: children
            )

        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {return _build(context);},
    );
  }

  Widget txnCard(String txnHash) {
    return InkWell(

        child: Container(child:Text('view on etherscan', style: TextStyle(color: Colors.white))),
        onTap: () => launch('${config.etherscan}$txnHash'),
      );
    
  }
}