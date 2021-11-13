import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_admin/consts/consts.dart';
import 'package:flutter_admin/connectors/http_controller.dart';
import 'package:flutter_admin/widgets/horizontal_table.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin/models/users.dart';
import 'package:flutter_admin/pages/users/user_edit_page.dart';
import 'package:flutter_admin/pages/users/users_controller.dart';
import 'package:get/get.dart';

class UsersLoadedPage extends StatelessWidget {
  final List<UserData> users;
  Rx<int?> selectedId = Rx(null);
  final HttpConnectController http = Get.find();

  UsersLoadedPage(this.users, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text("Add def"),
                onPressed: () {
                  BlocProvider.of<UsersCubit>(context).addDef();
                },
              ),
              const SizedBox(width: 20),
              Obx(() =>
                  ElevatedButton(
                    child: const Text("Edit"),
                    onPressed: selectedId.value == null ? null : () async {
                      final changed = await editUser(selectedId.value!);
                      if (changed) BlocProvider.of<UsersCubit>(context).refresh();
                    })),
              const SizedBox(width: 20),
              Obx(() =>
                  ElevatedButton(
                    child: const Text("Delete"),
                    onPressed: selectedId.value == null ? null : () {
                      BlocProvider.of<UsersCubit>(context).delete(selectedId.value!);
                    },
                  )),
              const SizedBox(width: 20),
              ElevatedButton(
                child: const Text("Refresh"),
                onPressed: () {
                  BlocProvider.of<UsersCubit>(context).refresh();
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 20),
          Obx((){
            final _to_observe = selectedId.value;
            return HorizontalTable(
              width: 1400,
              columns: _columns,
              rows: users.map(
                      (e) => _row(e)
              ).toList(),
            );
          }
          ),
        ],
      ),
    );
  }

  Future<bool> editUser (int id) async{
    try {
      final data = await _loadData(id);
      final got = await Get.dialog<UserData>(Dialog(child: UserEditPage(data)));
      if (got==null) return false;
      await _saveData(got);
      return true;
    } on Exception catch(e) {
      print("ERR: edit user: $e");
      return false;
    }
  }
  
  Future<UserData> _loadData(int id) async{
    final resp = await http.fetch("/users/$id");
    final json = jsonDecode(resp.body);
    return UserData.fromJson(json);
  }

  Future<void> _saveData(UserData data) async{
    await http.post("/users/${data.id}", body: data.patch());
  }

  DataRow2 _row(UserData data) =>
      DataRow2(
        cells: _cells(data),
        selected: data.id == selectedId.value,
        onTap: () {
          if (selectedId.value == data.id) {
            selectedId.value = null;
          } else {
            selectedId.value = data.id;
          }
        },
      );

  List<DataCell> _cells(UserData data) {
    return [
      DataCell(Text("${data.id}")),
      DataCell(Text(data.name)),
      DataCell(Text("${data.room}")),
      DataCell(Text("${data.curAP}")),
      DataCell(Text("${data.maxAP}")),
      DataCell(Text("${data.wounds}")),
      DataCell(Text(shortFloat.format(data.stim))),
      DataCell(Text(shortFloat.format(data.waste))),
      DataCell(Text("${data.tactic}")),
      DataCell(Text("${data.engineer}")),
      DataCell(Text("${data.operative}")),
      DataCell(Text("${data.navigator}")),
      DataCell(Text("${data.science}")),
    ];
  }

  static const List<DataColumn2> _columns = [
    DataColumn2(label: Text("id"), size: ColumnSize.S, numeric: true),
    DataColumn2(label: Text("name"), size: ColumnSize.L),
    DataColumn2(label: Text("room"), numeric: true),
    DataColumn2(label: Text("cur AP"), numeric: true),
    DataColumn2(label: Text("max AP"), numeric: true),
    DataColumn2(label: Text("wounds"), numeric: true),
    DataColumn2(label: Text("stim"), numeric: true),
    DataColumn2(label: Text("waste"), numeric: true),
    DataColumn2(label: Text("tactic"), numeric: true),
    DataColumn2(label: Text("engineer"), numeric: true),
    DataColumn2(label: Text("operative"), numeric: true),
    DataColumn2(label: Text("navigator"), numeric: true),
    DataColumn2(label: Text("science"), numeric: true),
  ];
}