import 'package:equatable/equatable.dart';

class RoomData extends Equatable{
  final int id;
  final String name;
  final int damage;
  final int cooler;
  final int temperature;
  final List<int> roomers;

  const RoomData(this.id, this.name, this.damage, this.cooler, this.temperature, this.roomers);
  RoomData.fromJson(Map<String, dynamic> json) :
      id = json['id'],
      name = json['name'],
      damage = json['damage'],
      cooler = json['cooler'],
      temperature = json['temperature'],
      roomers = json['roomers'].cast<int>();

  @override
  List<Object?> get props => [id, name, damage, cooler, temperature, roomers];
}