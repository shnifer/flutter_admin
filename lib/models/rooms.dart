import 'package:equatable/equatable.dart';

class RoomData extends Equatable{
  final int id;
  final String name;
  final int damage;
  final int cooler;
  final int temperature;
  final List<int> roomers;

  const RoomData({required this.id, required this.name, required this.damage, required this.cooler,
    required this.temperature, this.roomers = const []});

  RoomData.fromJson(Map<String, dynamic> json) :
      id = json['id'],
      name = json['name'],
      damage = json['damage'],
      cooler = json['cooler'],
      temperature = json['temperature'],
      roomers = json['roomers']?.cast<int>() ?? [];

  Map<String, String> patch() =>
      {
        "name": name,
        "damage": damage.toString(),
        "cooler": cooler.toString(),
        "temperature": temperature.toString(),
      };

  @override
  List<Object?> get props => [id, name, damage, cooler, temperature, roomers];
}