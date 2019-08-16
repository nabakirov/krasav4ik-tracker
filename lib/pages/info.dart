import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/bloc/bloc.dart';

Widget logoutBtn(AppBloc appBloc) {
  return Center(
      child: RaisedButton(
    child: Text('logout'),
    onPressed: () => appBloc.dispatch(LoggedOut()),
  ));
}

Widget _infoRowBuilder(Widget title, Widget data) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[title, data],
  );
}

Widget _titleBuilder(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
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
      Text(' eth', style: TextStyle(color: Colors.grey, fontSize: 15)),
    ],
  );
}

Widget nicknameWidget(String nickname) {
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

Widget etherBalanceWidget(double balance) {
  return _infoRowBuilder(
      _titleBuilder('balance'), _etherBalanceBuilder(balance));
}

Widget pointCountWidget(int pointCount, int maxPointCount) {
  var data = Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      Text(
        pointCount.toString(),
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      Text('/' + maxPointCount.toString(),
          style: TextStyle(color: Colors.grey, fontSize: 15)),
    ],
  );
  return _infoRowBuilder(_titleBuilder('points'), data);
}

Widget achieveCountWidget(int achieveCount) {
  return _infoRowBuilder(
      _titleBuilder('achieves'),
      Text(achieveCount.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)));
}

Widget contractInfoWidget(double achivePrize) {
  return _infoRowBuilder(
      _titleBuilder('achieve prize'), _etherBalanceBuilder(achivePrize));
}

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    print('state ${homeBloc.currentState}');
    print('username ${homeBloc.username}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        nicknameWidget(homeBloc.username),
        etherBalanceWidget(homeBloc.balance),
        pointCountWidget(homeBloc.points, homeBloc.maxPoints),
        achieveCountWidget(homeBloc.achieves),
        contractInfoWidget(homeBloc.achivePrize),
        FlatButton(
          child: Text('update'),
          onPressed: () {
            homeBloc.dispatch(Update());
          },
        )
      ],
    );
  }
}

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(50, 50, 50, 100),
        // color: Colors.red,
        child: Container(
            // color: Colors.green,
            child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) => Info(),
        )));
  }
}
