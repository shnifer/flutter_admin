import 'package:flutter/material.dart';
import 'package:flutter_admin/canvas/images_controller.dart';
import 'package:flutter_admin/connectors/http_controller.dart';
import 'package:flutter_admin/side_menu.dart';
import 'package:get/get.dart';
import 'package:flutter_admin/layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    Get.put(HttpConnectController()..initLocalSettings());
    Get.put(MenuController());
    Get.put(ImagesController()..loadImages());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nemesis admin front',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: LayoutBuilder(
        builder: (context, constraints) {
          final bool compact = constraints.maxWidth<600;
          return Scaffold(
            appBar: AppBar(
              title: const Center(child: Text("Админка Немезиды")),
            ),
            drawer: compact ? 
            Container(
                color: Colors.grey,
                padding: const EdgeInsets.all(40),
                margin: const EdgeInsets.all(40),
                child: const SideMenu(),
            ) : null,
            body: Layout(compact: compact),
          );
        },
      ),
    );
  }
}