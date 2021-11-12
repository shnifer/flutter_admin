import 'package:equatable/equatable.dart';

class UserData extends Equatable{
  final int id;
  final String name;
  final int curAP;
  final int maxAP;
  final int wounds;
  final double stim;
  final double waste;
  final int room;
  final int tactic;
  final int engineer;
  final int operative;
  final int navigator;
  final int science;

  const UserData({required this.id, required this.name, required this.room, required this.curAP,
    required this.maxAP, required this.wounds, required this.stim, required this.waste,
    required this.tactic, required this.engineer, required this.operative, required this.navigator,
    required this.science});

  UserData.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'],
        curAP = json['cur_ap'],
        maxAP = json['max_ap'],
        wounds = json['wounds'],
        stim = json['stim'],
        waste = json['waste'],
        room = json['room'],
        tactic = json['tactic'],
        engineer = json['engineer'],
        operative = json['operative'],
        navigator = json['navigator'],
        science = json['science'];

  Map<String, String> patch() =>
      {
        "name": name,
        "room": room.toString(),
        "cur_ap": curAP.toString(),
        "max_ap": maxAP.toString(),
        "wounds": wounds.toString(),
        "stim": stim.toString(),
        "waste": waste.toString(),
        "tactic": tactic.toString(),
        "engineer": engineer.toString(),
        "operative": operative.toString(),
        "navigator": navigator.toString(),
        "science": science.toString(),
      };


  @override
  List<Object?> get props =>
      [id, name, room, curAP, maxAP, wounds, stim, waste, room, tactic, engineer,
       operative, navigator, science];
}