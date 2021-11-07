import 'package:equatable/equatable.dart';

class UserData extends Equatable{
  final int id;
  final String name;
  final int curAP;
  final int maxAP;
  final int wounds;
  final int stim;
  final int waste;
  final List<String> prof;

  const UserData(this.id, this.name, this.curAP, this.maxAP, this.wounds, this.stim, this.waste, this.prof);
  UserData.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'],
        curAP = json['cur_ap'],
        maxAP = json['max_ap'],
        wounds = json['wounds'],
        stim = json['stim'],
        waste = json['waste'],
        prof = json['prof'].cast<String>();

  @override
  List<Object?> get props => [id, name, curAP, maxAP, wounds, stim, waste, prof];
}