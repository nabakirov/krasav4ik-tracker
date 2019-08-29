import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:krasav4ik/models/models.dart';
import 'package:krasav4ik/tools/tools.dart';

class ChartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Material(child: Center(child: Text('chart'),),);
    ChartBloc chartBloc = BlocProvider.of<ChartBloc>(context);
    var state = chartBloc.currentState;
    if (state is ChartLoadingState) {
      return Loader();
    }
    if (state is BaseChartState) {
      List<Widget> items = [];
      for (int i = 0; i < state.items.length; i++) {
        items.add(_cardBuilder(context, state.items[i], i));
      }
      // var theOneUser;
      // if (state.items.length == 0) {
      //   theOneUser = UserModel(
      //       points: BigInt.from(0),
      //       totalAchieves: BigInt.from(0),
      //       address: '0x0',
      //       nickname: 'no nickname');
      // } else {
      //   theOneUser = state.items[0];
      // }
      // if (items.length != 0) {
      //   items.removeAt(0);
      // }
      return RefreshIndicator(
        onRefresh: () => _onRefresh(chartBloc),
        child: Center(
                  child: Container(
                    // color: Colors.green,
                    child: ListView(
                      children: items,
                    ),
                  ),
                ));
    }
  }

  Future<void> _onRefresh(ChartBloc chartBloc) async {
    chartBloc.dispatch(FetchChartList());
  }

  Widget _cardBuilder(BuildContext context, UserModel userModel, int index) {
    List<Widget> icons = [];
    int boxesCount, titsCount;
    boxesCount = userModel.totalAchieves.toInt();
    var pointsCount = userModel.points.toInt();
    titsCount = pointsCount ~/ 10;
    for (int i = 0; i < boxesCount; i++) {
      icons.add(Container(
        width: 20,
        child: imgBuilder('images/box.png'),
      ));
    }
    for (int i = 0; i < titsCount; i++) {
      icons.add(Container(
        width: 20,
        child: Icon(Icons.adjust),
      ));
    }
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    userModel.nickname,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    getShortenAddress(address: userModel.address),
                    style: TextStyle(color: Colors.grey[500]),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  '${userModel.totalAchieves}/${userModel.points}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Wrap(
                direction: Axis.horizontal,
                children: icons,
              ),
            )
          ],
        ),
      ),
    );
  }

  String getShortenAddress({String address, int count: 7}) {
    int length = address.length;
    String shorten = address.substring(0, count) +
        '...' +
        address.substring(length - count, length);
    return shorten;
  }

  Widget theOne(UserModel userModel) {
    List<Widget> icons = [];
    int boxesCount, titsCount;
    boxesCount = userModel.totalAchieves.toInt();
    var pointsCount = userModel.points.toInt();
    titsCount = pointsCount ~/ 10;
    for (int i = 0; i < boxesCount; i++) {
      icons.add(Container(
        child: imgBuilder('images/box.png'),
      ));
    }
    for (int i = 0; i < titsCount; i++) {
      icons.add(Container(
        child: Icon(Icons.adjust),
      ));
    }
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Container(
            child: _theOneIcon(),
            padding: EdgeInsets.only(top: 5),
          )),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  userModel.nickname,
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                Text(getShortenAddress(address: userModel.address, count: 12),
                    style: TextStyle(color: Colors.grey)),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: Text(
                          "$boxesCount/$pointsCount",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: icons,
                          ),
                          height: 20,
                        )
                      ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _theOneIcon() {
    final String path = 'images/dumbbell.png';
    return Container(
      child: imgBuilder(path),
    );
  }
}
