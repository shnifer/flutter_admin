import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/connectors/http_controller.dart';
import 'package:get/get.dart';

class ServerStatMonitor extends StatelessWidget {
  final HttpConnectController c = Get.find();

  ServerStatMonitor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),
      width: 500,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              children: [
                Obx(()=>Text(
                    "Last seen ${c.stat.online.value ? "ONLINE" : "OFFLINE"}"
                )),
                const SizedBox(height: 20),
                Obx(()=>Text("Игровое время ${c.stat.gtime.value.toStringAsFixed(2)} sec")),
                const SizedBox(height: 20),
                Obx(()=>c.stat.ticking.value ? const Text("Тикает") : const Text("Не тикает")),
                const SizedBox(height: 20),
                Obx(()=>c.stat.paused.value ? const Text("На паузе") : const Text("Не на паузе")),
                const SizedBox(height: 20),
                Obx(()=>Text("Этап ${c.stat.stage}")),
              ],
            ),
          ),
          const SizedBox(width: 50),
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("auto-refresh"),
                    Obx(() => Checkbox(
                        value: c.autoRefresh.value,
                        onChanged: (bool? val) {
                          c.autoRefresh.value = val!;
                        })
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    child: const SizedBox(width: 100, child: Center(child: Text("refresh"))),
                    onPressed: (){
                      c.refreshOnline();
                    },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const SizedBox(width: 100, child: Center(child: Text("start"))),
                  onPressed: (){
                    c.post("/debug/start");
                  },
                ),
                const SizedBox(height: 10),
                Obx((){
                  final way = c.stat.paused.value ? "resume" : "pause";
                  return ElevatedButton(
                    child: SizedBox(width: 100, child: Center(child: Text(way))),
                    onPressed: (){
                      c.post("/debug/$way");
                    },
                  );
                }),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const SizedBox(width: 100, child: Center(child: Text("reset", style: TextStyle(color: Colors.red)))),
                  onPressed: (){
                    c.post("/debug/reset");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
