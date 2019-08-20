import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';

class InfoScreen extends StatelessWidget {
  InfoBloc infoBloc;
  @override
  Widget build(BuildContext context) {
    infoBloc = BlocProvider.of<InfoBloc>(context);
    return Padding(
      child: _build(infoBloc.currentState),
      padding: EdgeInsets.all(20),
    );

  }

  Widget _build(BaseInfoState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        nicknameWidget(state.nickname),
        etherBalanceWidget(state.balance),
        pointCountWidget(state.pointCount, state.maxPointCount),
        achieveCountWidget(state.achieveCount),
        contractInfoWidget(state.achievePrize),
        actionButtonWidget(),
        FlatButton(
          child: Text('update'),
          onPressed: () {
            infoBloc.dispatch(UpdateInfo());
          },
        )
      ],
    );
  }

  Widget actionButtonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: () => infoBloc.dispatch(MinusPointPress()),
          child: Text('-'),
          color: Colors.red
        ),
        RaisedButton(
          onPressed: () => infoBloc.dispatch(PlusPointPress()),
          child: Text('+'),
          color: Colors.green
        ),
      ],
    );
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
    if (balance  == null) {
      balance = 0;
    }
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
    if (nickname  == null) {
      nickname = 'no nickname';
    }
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
    if (pointCount == null) {
      pointCount = 0;
    }
    if (maxPointCount == null) {
      maxPointCount = 0;
    }
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
    if (achieveCount == null) {
      achieveCount = 0;
    }
    return _infoRowBuilder(
        _titleBuilder('achieves'),
        Text(achieveCount.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)));
  }

  Widget contractInfoWidget(double achivePrize) {
    if (achivePrize == null) {
      achivePrize = 0;
    }
    return _infoRowBuilder(
        _titleBuilder('achieve prize'), _etherBalanceBuilder(achivePrize));
  }
  
}