import 'package:flutter/material.dart';
import 'package:flutter_admin/connectors/http_controller.dart';
import 'package:flutter_admin/pages/options/stat_widget.dart';
import 'package:get/get.dart';

class OptionsPage extends StatelessWidget {
  OptionsPage({Key? key}) : super(key: key);
  final HttpConnectController c = Get.find();

  @override
  Widget build(BuildContext context) {
    final addrController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => Text("Current address ${c.address}")),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Введите новый адрес сервера',
                  ),
                  controller: addrController,
                  onEditingComplete: () {
                    c.setAddress(addrController.text);
                    addrController.text = "";
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: c.address.value == "xiiith.ru"
                        ? null
                        : () {
                            c.setAddress("xiiith.ru");
                          },
                    child: const Text("set REMOTE")),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: c.address.value == "127.0.0.1"
                        ? null
                        : () {
                            c.setAddress("127.0.0.1");
                          },
                    child: const Text("set LOCAL")),
              ],
            );
          }),
          const SizedBox(height: 10),
          ServerStatMonitor(),
        ],
      ),
    );
  }
}
