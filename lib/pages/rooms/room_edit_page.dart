import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin/models/rooms.dart';
import 'package:get/get.dart';

class RoomEditPage extends StatelessWidget {
  final RoomData data;

  final Map<String, TextEditingController> textControllers = {};
  static const strFields = <String>["name"];
  static const intFields = <String>["damage", "cooler", "temperature"];
  static const doubleFields = <String>[
    "damage_amplify",
    "ammo",
    "energy",
    "cpu",
    "fuel",
    "max_ammo",
    "max_energy",
    "max_cpu",
    "max_fuel",
    "inc_ammo",
    "inc_energy",
    "inc_cpu",
    "inc_fuel"
  ];

  RoomEditPage(this.data, {Key? key}) : super(key: key) {
    data.patch().forEach((key, value) {
      _addController(key, value);
    });
  }

  _addController(String name, Object val) {
    textControllers[name] = TextEditingController()..text = val.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("ID: ${data.id}"),
            const SizedBox(height: 20),
            _fieldRaw("Name:", "name"),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _fieldRaw("Damage:", "damage"),
                      const SizedBox(height: 5),
                      _fieldRaw("Cooler:", "cooler"),
                      const SizedBox(height: 5),
                      _fieldRaw("Temperature:", "temperature"),
                      const SizedBox(height: 5),
                      _fieldRaw("Dmg. amplify:", "damage_amplify"),
                      const SizedBox(height: 5),
                      _fieldRaw("Ammo:", "ammo"),
                      const SizedBox(height: 5),
                      _fieldRaw("Energy:", "energy"),
                      const SizedBox(height: 5),
                      _fieldRaw("Cpu:", "cpu"),
                      const SizedBox(height: 5),
                      _fieldRaw("Fuel:", "fuel"),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      _fieldRaw("Max Ammo:", "max_ammo"),
                      const SizedBox(height: 5),
                      _fieldRaw("Max Energy:", "max_energy"),
                      const SizedBox(height: 5),
                      _fieldRaw("Max Cpu:", "max_cpu"),
                      const SizedBox(height: 5),
                      _fieldRaw("Max Fuel:", "max_fuel"),
                      const SizedBox(height: 5),
                      _fieldRaw("Inc Ammo:", "inc_ammo"),
                      const SizedBox(height: 5),
                      _fieldRaw("Inc Energy:", "inc_energy"),
                      const SizedBox(height: 5),
                      _fieldRaw("Inc Cpu:", "inc_cpu"),
                      const SizedBox(height: 5),
                      _fieldRaw("Inc Fuel:", "inc_fuel"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                child: const Text("Save"),
                onPressed: () {
                  Get.back(result: composeData());
                })
          ],
        ),
      ),
    );
  }

  RoomData? composeData() {
    try {
      final json = <String, dynamic>{};
      json['id'] = data.id;
      textControllers.forEach((field, controller) {
        if (strFields.contains(field)) json[field] = controller.text;
        if (intFields.contains(field)) json[field] = int.parse(controller.text);
        if (doubleFields.contains(field)) json[field] = double.parse(controller.text);
      });
      return RoomData.fromJson(json);
    } on Exception catch (e) {
      Get.showSnackbar(GetBar(message: e.toString()));
      return null;
    }
  }

  Widget _fieldRaw(String prefix, String name) {
    return Row(children: [
      SizedBox(
        width: 75,
        child: Text(
          prefix,
          style: const TextStyle(fontSize: 12),
        ),
      ),
      Expanded(
        child: SizedBox(
          height: 35,
          child: TextField(
            controller: textControllers[name]!,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    ]);
  }
}
