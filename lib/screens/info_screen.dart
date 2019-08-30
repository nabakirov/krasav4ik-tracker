import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krasav4ik/blocs/blocs.dart';
import 'package:krasav4ik/tools/tools.dart';

class InfoScreen extends StatelessWidget {
  InfoBloc infoBloc;
  @override
  Widget build(BuildContext context) {
    infoBloc = BlocProvider.of<InfoBloc>(context);
    var state = infoBloc.currentState;
    if (state is InfoLoadingState) {
      return Loader();
    }
    if (state is ConfirmationState) {
      InfoEvent event;
      if (state.isPlus) {
        event = PlusPointPress(infoState: state.prevState);
      } else {
        event = MinusPointPress(infoState: state.prevState);
      }
      return modalWidgetGenerator(
          background: _build(state.prevState),
          onBackgroundTap: () => infoBloc
              .dispatch(CloseConfirmationWidget(infoState: state.prevState)),
          modal: cardBuilder(
              title: 'do u want to continue?',
              onOk: () => infoBloc.dispatch(event),
              onCancel: () =>
                  CloseConfirmationWidget(infoState: state.prevState),
              okText: 'yes',
              cancelText: 'no'));
    }
    return _build(infoBloc.currentState);
  }

  Widget _build(BaseInfoState state) {
    List<Widget> icons = [];
    int boxesCount, titsCount;
    boxesCount = state.achieveCount.toInt();
    var pointsCount = state.pointCount.toInt();
    titsCount = pointsCount ~/ 10;
    for (int i = 0; i < boxesCount; i++) {
      icons.add(Container(
        width: 25,
        child: imgBuilder('images/box.png'),
      ));
    }
    for (int i = 0; i < titsCount; i++) {
      icons.add(Container(
        width: 25,
        child: Icon(Icons.adjust),
      ));
    }
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    nicknameWidget(state.nickname),
                    Wrap(
                      children: icons,
                    )
                  ]),
              flex: 2),
          Expanded(child: etherBalanceWidget(state.balance)),
          Expanded(
              child: pointCountWidget(state.pointCount, state.maxPointCount)),
          Expanded(child: achieveCountWidget(state.achieveCount)),
          Expanded(child: contractInfoWidget(state.achievePrize)),
          Expanded(
            child: contractBalance(state.contractBalance),
          ),
          Expanded(child: actionButtonWidget(state)),
        ],
      ),
    );
  }

  Widget actionButtonWidget(BaseInfoState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.all(5),
            child: RaisedButton(
                onPressed: () => infoBloc.dispatch(
                    OpenConfirmationWidget(isPlus: false, state: state)),
                child: Text('-',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
                color: Colors.red),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(5),
            child: RaisedButton(
                onPressed: () => infoBloc.dispatch(
                    OpenConfirmationWidget(isPlus: true, state: state)),
                child: Text('+',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
                color: Colors.green),
          ),
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

  Widget contractBalance(double balance) {
    return _infoRowBuilder(
        _titleBuilder('contract balance'), _etherBalanceBuilder(balance));
  }

  Widget _etherBalanceBuilder(double balance) {
    if (balance == null) {
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
    if (nickname == null) {
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
