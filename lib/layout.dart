import 'package:flutter/material.dart';
import 'package:flutter_admin/pages/options/options_page.dart';
import 'package:flutter_admin/pages/rooms/rooms_page.dart';
import 'package:flutter_admin/pages/ship/ship_page.dart';
import 'package:flutter_admin/pages/targets/targets_page.dart';
import 'package:flutter_admin/pages/users/users_page.dart';
import 'package:flutter_admin/side_menu.dart';
import 'package:get/get.dart';

enum MenuPage { options, users, rooms, targets, ship }

class MenuController extends GetxController {
  var curPage = MenuPage.options.obs;
}

class Layout extends StatelessWidget {
  final bool compact;
  const Layout({Key? key, required this.compact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MenuController c = Get.find();
    return Row(
      children: [
        if (compact)
        Container() else
        Container(
          width: 150,
          color: Colors.black12,
          child: const SideMenu(),
        ),

        Expanded(
          child: Obx(() {
            switch (c.curPage.value) {
              case MenuPage.options:
                return OptionsPage();
              case MenuPage.users:
                return const UsersPage();
              case MenuPage.rooms:
                return const RoomsPage();
              case MenuPage.targets:
                return const TargetsPage();
              case MenuPage.ship:
                return const ShipPage();
            }
          }),
        ),
      ],
    );
  }
}
