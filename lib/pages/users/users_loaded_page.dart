import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/models/users.dart';
import 'package:front/pages/users/user_edit_page.dart';
import 'package:front/pages/users/users_controller.dart';
import 'package:get/get.dart';

class UsersLoadedPage extends StatelessWidget{
  final List<UserData> users;
  Rx<int?> selectedId = Rx(null);

  UsersLoadedPage(this.users, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(40),
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("Add def"),
                  onPressed: (){
                    BlocProvider.of<UsersCubit>(context).addDef();
                  },
                ),
                const SizedBox(width: 20),
                Obx(() => ElevatedButton(
                  child: const Text("Edit"),
                  onPressed: selectedId.value == null ? null : (){
                    Get.dialog(Dialog(child: UserEditPage(selectedId.value!)))
                        .then((_) {
                          BlocProvider.of<UsersCubit>(context).refresh();
                        });
                  },
                )),
                const SizedBox(width: 20),
                Obx(() => ElevatedButton(
                  child: const Text("Delete"),
                  onPressed: selectedId.value == null ? null : (){
                    BlocProvider.of<UsersCubit>(context).delete(selectedId.value!);
                  },
                )),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() => DataTable2(
              columns: _columns,
              rows: users.map(
                      (e) => _row(e)
              ).toList(),
            )),
          ],
        ),
      ),
    );
  }

  DataRow2 _row(UserData data) => DataRow2(
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

  List<DataCell> _cells(UserData data) {
    return [
      DataCell(Text("${data.id}")),
      DataCell(Text(data.name)),
      DataCell(Text("${data.curAP}")),
      DataCell(Text("${data.maxAP}")),
      DataCell(Text("${data.wounds}")),
      DataCell(Text("${data.stim}")),
      DataCell(Text("${data.waste}")),
      DataCell(Text("${data.prof}")),
    ];
  }

  static const List<DataColumn2> _columns = [
    DataColumn2(label: Text("id"), size: ColumnSize.S, numeric: true),
    DataColumn2(label: Text("name"), size: ColumnSize.L),
    DataColumn2(label: Text("cur AP"), numeric: true),
    DataColumn2(label: Text("max AP"), numeric: true),
    DataColumn2(label: Text("wounds"), numeric: true),
    DataColumn2(label: Text("stim"), numeric: true),
    DataColumn2(label: Text("waste"), numeric: true),
    DataColumn2(label: Text("prof"), size: ColumnSize.L),
  ];
}