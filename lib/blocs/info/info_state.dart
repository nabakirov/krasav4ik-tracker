import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class InfoState extends Equatable {
  InfoState([List props = const <dynamic>[]]) : super(props);
}

class InfoLoadingState extends InfoState {
  @override
  String toString() => 'LoadingState';
}

class BaseInfoState extends InfoState {
  final String nickname;
  final double balance;
  final int pointCount;
  final int maxPointCount;
  final int achieveCount;
  final double achievePrize;
  final double contractBalance;

  BaseInfoState(
      {this.nickname,
      this.balance,
      this.pointCount,
      this.maxPointCount,
      this.achieveCount,
      this.achievePrize,
      this.contractBalance})
      : super([
          nickname,
          balance,
          pointCount,
          maxPointCount,
          achieveCount,
          achievePrize
        ]);

  @override
  String toString() => 'InitialInfoState';
}

class CreatedInfoState extends InfoState {
  @override
  String toString() => 'CreatedInfoState';

  final String txnHash;
  CreatedInfoState({@required this.txnHash}) : super([txnHash]);
}

class ConfirmationState extends InfoState {
  final bool isPlus;
  final InfoState prevState;

  ConfirmationState({@required this.isPlus, @required this.prevState}) : super([isPlus]);
  @override
  String toString() => 'ConfirmationState';
}