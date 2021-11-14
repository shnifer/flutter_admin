import 'package:equatable/equatable.dart';

class RoomData extends Equatable{
  final int id;
  final String name;
  final int damage;
  final int cooler;
  final int temperature;
  final List<int> roomers;
  final double damageAmplify;
  final double ammo;
  final double energy;
  final double cpu;
  final double fuel;
  final double maxAmmo;
  final double maxEnergy;
  final double maxCpu;
  final double maxFuel;
  final double incAmmo;
  final double incEnergy;
  final double incCpu;
  final double incFuel;

  const RoomData({required this.id, required this.name, required this.damage, required this.cooler,
    required this.temperature, required this.ammo, required this.energy, required this.cpu,
    required this.fuel, required this.maxAmmo, required this.maxEnergy, required this.maxCpu,
    required this.maxFuel, required this.incAmmo, required this.incEnergy, required this.incCpu,
    required this.incFuel, required this.damageAmplify, this.roomers = const []});

  RoomData.fromJson(Map<String, dynamic> json) :
      id = json['id'],
      name = json['name'],
      damage = json['damage'],
      cooler = json['cooler'],
      temperature = json['temperature'],
      roomers = json['roomers']?.cast<int>() ?? [],
      damageAmplify = json['damage_amplify'],
      ammo = json['ammo'],
      energy = json['energy'],
      cpu = json['cpu'],
      fuel = json['fuel'],
      maxAmmo = json['max_ammo'],
      maxEnergy = json['max_energy'],
      maxCpu = json['max_cpu'],
      maxFuel = json['max_fuel'],
      incAmmo = json['inc_ammo'],
      incEnergy = json['inc_energy'],
      incCpu = json['inc_cpu'],
      incFuel = json['inc_fuel'];

  Map<String, String> patch() =>
      {
        "name": name,
        "damage": damage.toString(),
        "cooler": cooler.toString(),
        "temperature": temperature.toString(),
        "damage_amplify": damageAmplify.toString(),
        "ammo": ammo.toString(),
        "energy": energy.toString(),
        "cpu": cpu.toString(),
        "fuel": fuel.toString(),
        "max_ammo": maxAmmo.toString(),
        "max_energy": maxEnergy.toString(),
        "max_cpu": maxCpu.toString(),
        "max_fuel": maxFuel.toString(),
        "inc_ammo": incAmmo.toString(),
        "inc_energy": incEnergy.toString(),
        "inc_cpu": incCpu.toString(),
        "inc_fuel": incFuel.toString(),
      };

  @override
  List<Object?> get props => [id, name, damage, cooler, temperature, roomers, damageAmplify,
  ammo, energy, cpu, fuel, maxAmmo, maxEnergy, maxCpu, maxFuel, incAmmo, incEnergy, incCpu, incFuel];
}