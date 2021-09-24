import 'package:floor/floor.dart';

@entity
class SuspEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String? name;

  //Fork
  int? forkPsi;
  int? forkTokens;

  int? forkHSRebound;
  int? forkHSRebMaxClick;

  int? forkLSReb;
  int? forkLSRebMaxClick;

  int? forkHSComp;
  int? forkHSCompMaxClick;

  int? forkLSComp;
  int? forkLSCompMaxClick;

  //Shock
  int? shockPsi;
  int? shockTokens;

  int? shockHSRebound;
  int? shockHSRebMaxClick;

  int? shockLSReb;
  int? shockLSRebMaxClick;

  int? shockHSComp;
  int? shockHSCompMaxClick;

  int? shockLSComp;
  int? shockLSCompMaxClick;

  bool? showTutorial;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuspEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  SuspEntity({
    this.id,
    this.name,
    this.forkPsi,
    this.forkTokens,
    this.forkHSRebound,
    this.forkHSRebMaxClick,
    this.forkLSReb,
    this.forkLSRebMaxClick,
    this.forkHSComp,
    this.forkHSCompMaxClick,
    this.forkLSComp,
    this.forkLSCompMaxClick,
    this.shockPsi,
    this.shockTokens,
    this.shockHSRebound,
    this.shockHSRebMaxClick,
    this.shockLSReb,
    this.shockLSRebMaxClick,
    this.shockHSComp,
    this.shockHSCompMaxClick,
    this.shockLSComp,
    this.shockLSCompMaxClick,
    this.showTutorial});


  static SuspEntity getDefault() {
    return SuspEntity(
        name: 'Main',
        id: 1,
        forkPsi: 50,
        forkTokens: 0,
        forkHSRebound: 0,
        forkHSRebMaxClick: 5,
        forkLSReb: 0,
        forkLSRebMaxClick: 5,
        forkHSComp: 0,
        forkHSCompMaxClick: 5,
        forkLSComp: 0,
        forkLSCompMaxClick: 5,
        shockPsi: 50,
        shockTokens: 0,
        shockHSRebound: 0,
        shockHSRebMaxClick: 5,
        shockLSReb: 0,
        shockLSRebMaxClick: 5,
        shockHSComp: 0,
        shockHSCompMaxClick: 5,
        shockLSComp: 0,
        shockLSCompMaxClick: 5,
        showTutorial: true);
  }

  @override
  String toString() {
    return 'SuspEntity{name: $name, forkPsi: $forkPsi, forkTokens: $forkTokens}';
  }
}


enum SuspEnum{
  MAIN,
  HSR,
  LSR,
  HSC,
  LSC
}
