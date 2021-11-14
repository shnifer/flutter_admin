import 'package:equatable/equatable.dart';

class ShipData extends Equatable{
  final int shieldForward;
  final int shieldLeft;
  final int shieldRight;
  final int shieldBack;
  final int structureDamage;
  final int structureMax;
  final double turnSpeed;
  final double course;
  final double accelerate;
  final double speed;
  final double maxSpeed;

  const ShipData({required this.shieldForward,required this.shieldLeft,required this.shieldRight,
  required this.shieldBack,required this.structureDamage,required this.structureMax,
  required this.turnSpeed,required this.course,required this.accelerate,required this.speed,
  required this.maxSpeed});

  ShipData.fromJson(Map<String, dynamic> json) :
        shieldForward = json['shield_forward'],
        shieldLeft = json['shield_left'],
        shieldRight = json['shield_right'],
        shieldBack = json['shield_back'],
        structureDamage = json['structure_damage'],
        structureMax = json['structure_max'],
        turnSpeed = json['turn_speed'],
        course = json['course'],
        accelerate = json['accelerate'],
        speed = json['speed'],
        maxSpeed = json['max_speed'];

  Map<String, String> patch() =>
      {
        "shield_forward": shieldForward.toString(),
        "shield_left": shieldLeft.toString(),
        "shield_right": shieldRight.toString(),
        "shield_back": shieldBack.toString(),
        "structure_damage": structureDamage.toString(),
        "structure_max": structureMax.toString(),
        "turn_speed": turnSpeed.toString(),
        "course": course.toString(),
        "accelerate": accelerate.toString(),
        "speed": speed.toString(),
        "max_speed": maxSpeed.toString(),
      };

  @override
  List<Object?> get props => [shieldBack,shieldRight,shieldLeft,shieldForward,structureDamage,
  structureMax,turnSpeed, course, accelerate, speed, maxSpeed];
}