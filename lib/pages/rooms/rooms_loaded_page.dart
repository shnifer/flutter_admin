import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/connectors/http_controller.dart';
import 'package:flutter_admin/models/rooms.dart';
import 'package:flutter_admin/pages/rooms/room_edit_page.dart';
import 'package:flutter_admin/pages/rooms/rooms_controller.dart';
import 'package:flutter_admin/widgets/horizontal_table.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class RoomsLoadedPage extends StatelessWidget {
  final List<RoomData> rooms;
  Rx<int?> selectedId = Rx(null);
  final HttpConnectController http = Get.find();

  RoomsLoadedPage(this.rooms, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() =>
                  ElevatedButton(
                      child: const Text("Edit"),
                      onPressed: selectedId.value == null ? null : () async {
                        final changed = await editRoom(selectedId.value!);
                        if (changed) BlocProvider.of<RoomsCubit>(context).refresh();
                      })),
              const SizedBox(width: 20),
              ElevatedButton(
                child: const Text("Refresh"),
                onPressed: () {
                  BlocProvider.of<RoomsCubit>(context).refresh();
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() {
            final _to_observe = selectedId.value;
            return HorizontalTable(
              columns: _columns,
              rows: rooms.map((e) => _row(e)).toList(),
            );
          })
        ],
      ),
    );
  }

  Future<bool> editRoom (int id) async{
    try {
      final data = await _loadData(id);
      final got = await Get.dialog<RoomData>(Dialog(child: RoomEditPage(data)));
      if (got==null) return false;
      await _saveData(got);
      return true;
    } on Exception catch(e) {
      print("ERR: edit room: $e");
      return false;
    }
  }

  Future<RoomData> _loadData(int id) async{
    final resp = await http.fetch("/rooms/$id");
    if (resp.statusCode != 200) throw Exception("HTTP CODE ${resp.statusCode}");
    final json = jsonDecode(resp.body);
    return RoomData.fromJson(json);
  }

  Future<void> _saveData(RoomData data) async{
    final resp = await http.post("/rooms/${data.id}", body: data.patch());
    if (resp.statusCode != 200) throw Exception("HTTP CODE ${resp.statusCode}");
  }

  DataRow2 _row(RoomData data) => DataRow2(
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

  List<DataCell> _cells(RoomData data) {
    return [
      DataCell(Text("${data.id}")),
      DataCell(Text(data.name)),
      DataCell(Text("${data.damage}")),
      DataCell(Text("${data.cooler}")),
      DataCell(Text("${data.temperature}")),
      DataCell(Text("${data.roomers}")),
    ];
  }

  static const List<DataColumn2> _columns = [
    DataColumn2(label: Text("id"), size: ColumnSize.S, numeric: true),
    DataColumn2(label: Text("name"), size: ColumnSize.L),
    DataColumn2(label: Text("damage"), numeric: true),
    DataColumn2(label: Text("cooler"), numeric: true),
    DataColumn2(label: Text("temperature"), numeric: true),
    DataColumn2(label: Text("roomers"), size: ColumnSize.L),
  ];
}
