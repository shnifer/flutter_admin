import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/connectors/http_controller.dart';
import 'package:flutter_admin/helpers/web_files.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              children: [
                Obx(() => Text("Last seen ${c.stat.online.value ? "ONLINE" : "OFFLINE"}")),
                const SizedBox(height: 20),
                Obx(() => Text("Cron: ${c.stat.cron.value}")),
                const SizedBox(height: 20),
                Obx(() => Text("Игровое время ${c.stat.gtime.value.toStringAsFixed(2)} sec")),
                const SizedBox(height: 20),
                Obx(() => c.stat.ticking.value ? const Text("Тикает") : const Text("Не тикает")),
                const SizedBox(height: 20),
                Obx(() => c.stat.paused.value ? const Text("На паузе") : const Text("Не на паузе")),
                const SizedBox(height: 20),
                Obx(() => Text("Этап ${c.stat.stage}")),
              ],
            ),
          ),
          const SizedBox(width: 20),
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
                        })),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const SizedBox(width: 100, child: Center(child: Text("refresh"))),
                  onPressed: () {
                    c.refreshOnline();
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const SizedBox(width: 100, child: Center(child: Text("start"))),
                  onPressed: () async {
                    await c.post("/debug/start");
                    c.refreshOnline();
                  },
                ),
                const SizedBox(height: 10),
                Obx(() {
                  final way = c.stat.paused.value ? "resume" : "pause";
                  return ElevatedButton(
                    child: SizedBox(width: 100, child: Center(child: Text(way))),
                    onPressed: () async {
                      await c.post("/debug/$way");
                      c.refreshOnline();
                    },
                  );
                }),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const SizedBox(
                      width: 100,
                      child: Center(child: Text("reset", style: TextStyle(color: Colors.red)))),
                  onPressed: () async {
                    await c.post("/debug/reset");
                    c.refreshOnline();
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const SizedBox(
                      width: 100,
                      child: Center(
                          child: Text("HARD reset",
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))),
                  onPressed: () async {
                    await c.post("/debug/hardreset");
                    c.refreshOnline();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Column(
              children: [
                const Text("CONFIG"),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    _saveConfigFromServer();
                  },
                  child: SizedBox(width: 100, child: Center(child: Row(
                    children: const [
                      Icon(Icons.download),
                      SizedBox(width: 5),
                      Text("Download"),
                    ],
                  ))),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _sendConfigToServer();
                  },
                  child: SizedBox(width: 100, child: Center(child: Row(
                    children: const [
                      Icon(Icons.upload_file),
                      SizedBox(width: 5),
                      Text("Push"),
                    ],
                  ))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _saveConfigFromServer() async {
    try {
      final resp = await c.fetch("/debug/config");
      final json = jsonDecode(resp.body);
      final pretty = const JsonEncoder.withIndent("  ").convert(json);
      saveFile(pretty, "config.json");
    } on Exception catch (e) {
      print("ERR: config fetch: $e");
    }
  }

  _sendConfigToServer() async {
    try {
      final pick = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        dialogTitle: "Выбери JSON с конфигом",
        allowedExtensions: ["json"],
        withData: true,
      );
      if (pick == null) return;
      final fileBytes = pick.files.single.bytes!;
      final fileString = utf8.decode(fileBytes.cast());
      jsonDecode(fileString); // just for check
      c.post("/debug/config", body: fileString);
      Get.snackbar("WARNING", "Реальная обработка пока не реализована");
    } on Exception catch (e) {
      Get.snackbar("ERROR", "config send: $e");
    }
  }
}
