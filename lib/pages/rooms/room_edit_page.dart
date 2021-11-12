import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin/models/rooms.dart';
import 'package:get/get.dart';

class RoomEditPage extends StatelessWidget {
  final RoomData data;
  final name = TextEditingController();
  final damage = TextEditingController();
  final cooler = TextEditingController();
  final temperature = TextEditingController();

  RoomEditPage(this.data, {Key? key}) : super(key: key) {
    name.text = data.name;
    damage.text = data.damage.toString();
    cooler.text = data.cooler.toString();
    temperature.text = data.temperature.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          children:[
            Text("ID: ${data.id}"),
            const SizedBox(height: 20),
            _fieldRaw("Name:", name, isDigit: false),
            const SizedBox(height: 5),
            _fieldRaw("Damage:", damage),
            const SizedBox(height: 5),
            _fieldRaw("Cooler:", cooler),
            const SizedBox(height: 5),
            _fieldRaw("Temperature:", temperature),
            const SizedBox(height: 20),
            ElevatedButton(
                child: const Text("Save"),
                onPressed: () {
                  Get.back(result: composeData());
                }
            )
          ],
        ),
      ),
    );
  }

  RoomData? composeData(){
    try{
      return RoomData(
        id: data.id,
        name: name.text,
        damage: int.parse(damage.text),
        cooler: int.parse(cooler.text),
        temperature: int.parse(temperature.text),
      );
    } on Exception catch (e){
      Get.showSnackbar(GetBar(message: e.toString()));
      return null;
    }
  }

  Widget _fieldRaw(String prefix, TextEditingController controller, {isDigit = true}) {
    return Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(prefix),
          ),
          Expanded(
            child: SizedBox(
              height: 35,
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border:  OutlineInputBorder(),
                ),
                inputFormatters: [
                  if (isDigit) FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ),
        ]
    );
  }
}