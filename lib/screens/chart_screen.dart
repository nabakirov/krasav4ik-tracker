import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:krasav4ik/models/models.dart';

class ChartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Material(child: Center(child: Text('chart'),),);
    ChartBloc chartBloc = BlocProvider.of<ChartBloc>(context);
    var state = chartBloc.currentState;
    if (state is BaseChartState) {
      List<Widget> items = [];
      for (int i = 0; i < state.items.length; i++) {
        items.add(_cardBuilder(context, state.items[i], i));
      }
      return RefreshIndicator(
        onRefresh: () => _onRefresh(chartBloc),
        child: ListView(
          children: items,
        ),
      );
    }
  }

  Future<void> _onRefresh(ChartBloc chartBloc) async {
    chartBloc.dispatch(FetchChartList());
  }

  Widget _cardBuilder(BuildContext context, UserModel userModel, int index) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              (index + 1).toString(),
              style: TextStyle(fontSize: 15),
            ),
            Column(
              children: <Widget>[
                Text(
                  userModel.nickname,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  getShortenAddress(userModel.address),
                  style: TextStyle(color: Colors.grey[500]),
                )
              ],
            ),
            Text(
              '${userModel.totalAchieves}/${userModel.points}',
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
  
  String getShortenAddress(String address) {
    int length = address.length;
    String shorten =
        address.substring(0, 7) + '...' + address.substring(length - 7, length);
    return shorten;
  }
}
