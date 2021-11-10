import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/models/rooms.dart';
import 'package:flutter_admin/widgets/horizontal_table.dart';
import 'package:get/get.dart';

class RoomsLoadedPage extends StatelessWidget{
  final List<RoomData> rooms;
  Rx<int?> selectedId = Rx(null);

  RoomsLoadedPage(this.rooms, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [Obx(() => HorizontalTable(
          columns: _columns,
          rows: rooms.map(
                  (e) => _row(e)
          ).toList(),
      ))],
    );
  }

  DataRow2 _row(RoomData data) => DataRow2(
      cells: _cells(data),
      selected: data.id == selectedId.value,
      onTap:() {
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