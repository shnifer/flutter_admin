import 'package:flutter/material.dart';
import 'package:flutter_admin/connectors/http_controller.dart';
import 'package:flutter_admin/pages/options/stat_widget.dart';
import 'package:get/get.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpConnectController c = Get.find();
    final addrController = TextEditingController();

    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() => Text("Current address ${c.address}")),
            const SizedBox(height: 30),
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
                    onEditingComplete: (){
                      c.setAddress(addrController.text);
                      addrController.text = "";
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ServerStatMonitor(),
          ],
        );
  }
}
