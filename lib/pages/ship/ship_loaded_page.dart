import 'package:flutter/material.dart';
import 'package:flutter_admin/models/ship.dart';
import 'package:flutter_admin/pages/ship/ship_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ShipLoadedPage extends StatelessWidget {
  final ShipData ship;
  final Map<String, TextEditingController> textControllers = {};
  final editedFields = <String>[].obs;
  late ShipCubit cubit;

  ShipLoadedPage(this.ship, {Key? key}) : super(key: key) {
    ship.patch().forEach((key, value) {
      _addController(key, value);
    });
  }

  _addController(String name, Object val) {
    textControllers[name] = TextEditingController()
      ..text = val.toString();
  }

  @override
  Widget build(BuildContext context) {
    cubit = BlocProvider.of<ShipCubit>(context);
    return Container(
      width: 400,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      cubit.refresh();
                    },
                    child: const Text("Refresh")),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {
                      Map <String, String> patch = Map.fromIterable(
                          editedFields,
                          value: (name)=>textControllers[name]!.text);
                      editedFields.clear();
                      cubit.patch(patch);
                    },
                    child: const Text("Save")),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.blue,
                        child: Column(
                          children: [
                            const Text("SHIELDS:"),
                            const SizedBox(height: 10),
                            _fieldRaw("forward", "shield_forward"),
                            const SizedBox(height: 10),
                            _fieldRaw("left", "shield_left"),
                            const SizedBox(height: 10),
                            _fieldRaw("right", "shield_right"),
                            const SizedBox(height: 10),
                            _fieldRaw("back", "shield_back"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.green,
                        child: Column(
                          children: [
                            const Text("STRUCTURE:"),
                            const SizedBox(height: 10),
                            _fieldRaw("damage", "structure_damage"),
                            const SizedBox(height: 10),
                            _fieldRaw("maximum", "structure_max"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.yellow,
                        child: Column(
                          children: [
                            const Text("MOVEMENT:"),
                            const SizedBox(height: 10),
                            _fieldRaw("turn", "turn_speed"),
                            const SizedBox(height: 10),
                            _fieldRaw("course", "course"),
                            const SizedBox(height: 10),
                            _fieldRaw("accelerate", "accelerate"),
                            const SizedBox(height: 10),
                            _fieldRaw("speed", "speed"),
                            const SizedBox(height: 10),
                            _fieldRaw("max speed", "max_speed"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldRaw(String prefix, String name) {
    return Row(children: [
      SizedBox(
        width: 75,
        child: Obx(() {
          return Text(
            prefix,
            style: !editedFields.contains(name) ?
            const TextStyle(fontSize: 12) :
            const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
          );
        }),
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
            onChanged: (_) {
              if (!editedFields.contains(name)) editedFields.add(name);
            },
            onEditingComplete: () async {
              editedFields.remove(name);
              await cubit.patchField(name, textControllers[name]!.text);
            },
          ),
        ),
      ),
    ]);
  }
}
