import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin/models/users.dart';
import 'package:get/get.dart';

class UserEditPage extends StatelessWidget {
  final UserData data;
  final name = TextEditingController();
  final room = TextEditingController();
  final curAP = TextEditingController();
  final maxAP = TextEditingController();
  final wounds = TextEditingController();
  final stim = TextEditingController();
  final waste = TextEditingController();
  final tactic = TextEditingController();
  final engineer = TextEditingController();
  final operative = TextEditingController();
  final navigator = TextEditingController();
  final science = TextEditingController();

  UserEditPage(this.data, {Key? key}) : super(key: key) {
    name.text = data.name;
    room.text = data.room.toString();
    curAP.text = data.curAP.toString();
    maxAP.text = data.maxAP.toString();
    wounds.text = data.wounds.toString();
    stim.text = data.stim.toString();
    waste.text = data.waste.toString();
    tactic.text = data.tactic.toString();
    engineer.text = data.engineer.toString();
    operative.text = data.operative.toString();
    navigator.text = data.navigator.toString();
    science.text = data.science.toString();
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
            _fieldRaw("Room:", room),
            const SizedBox(height: 5),
            _fieldRaw("Cur AP:", curAP),
            const SizedBox(height: 5),
            _fieldRaw("Max AP:", maxAP),
            const SizedBox(height: 5),
            _fieldRaw("Wounds:", wounds),
            const SizedBox(height: 5),
            _fieldRaw("Stim:", stim),
            const SizedBox(height: 5),
            _fieldRaw("Waste:", waste),
            const SizedBox(height: 5),
            _fieldRaw("Tactic:", tactic),
            const SizedBox(height: 5),
            _fieldRaw("Engineer:", engineer),
            const SizedBox(height: 5),
            _fieldRaw("Operative:", operative),
            const SizedBox(height: 5),
            _fieldRaw("Navigator:", navigator),
            const SizedBox(height: 5),
            _fieldRaw("Science:", science),
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

  UserData? composeData(){
    try{
      return UserData(
        id: data.id,
        name: name.text,
        room: int.parse(room.text),
        curAP: int.parse(curAP.text),
        maxAP: int.parse(maxAP.text),
        wounds: int.parse(wounds.text),
        stim: double.parse(stim.text),
        waste: double.parse(waste.text),
        tactic: int.parse(tactic.text),
        engineer: int.parse(engineer.text),
        operative: int.parse(operative.text),
        navigator: int.parse(navigator.text),
        science: int.parse(science.text),
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