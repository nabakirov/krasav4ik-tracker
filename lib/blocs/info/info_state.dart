import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class InfoState extends Equatable {
  InfoState([List props = const <dynamic>[]]) : super(props);
}

class BaseInfoState extends InfoState {
  final String nickname;
  final double balance;
  final int pointCount;
  final int maxPointCount;
  final int achieveCount;
  final double achievePrize;

  BaseInfoState(
      {this.nickname,
      this.balance,
      this.pointCount,
      this.maxPointCount,
      this.achieveCount,
      this.achievePrize})
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
