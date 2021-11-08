import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/connectors/http_controller.dart';
import 'package:front/models/users.dart';
import 'package:get/get.dart';

class UserEditPage extends StatelessWidget {
  final int id;
  const UserEditPage(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserEditCubit(id)..load(),
      child: BlocBuilder<UserEditCubit, UserEditState>(
        builder: (context, state) {
          switch (state.success) {
            case null:
              return const CircularProgressIndicator();
            case false:
              return Text("ERROR! ${state.err}",
                style: const TextStyle(color: Colors.red),
              );
            case true:
              return _UserEditPage(state.data!);
          }
          return Container();
        },
      ),
    );
  }
}

class _UserEditPage extends StatelessWidget {
  final UserData data;
  final name = TextEditingController();
  final curAP = TextEditingController();
  final maxAP = TextEditingController();
  final wounds = TextEditingController();
  final stim = TextEditingController();
  final waste = TextEditingController();
  final prof = TextEditingController();

  _UserEditPage(this.data, {Key? key}) : super(key: key) {
    name.text = data.name;
    curAP.text = data.curAP.toString();
    maxAP.text = data.maxAP.toString();
    wounds.text = data.wounds.toString();
    stim.text = data.stim.toString();
    waste.text = data.waste.toString();
    prof.text = jsonEncode(data.prof);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 500,
      child: Column(
        children:[
          Text("ID: ${data.id}"),
          const SizedBox(height: 30),
          _fieldRaw("Name:", name),
          const SizedBox(height: 20),
          _fieldRaw("Cur AP:", curAP, isDigit: true),
          const SizedBox(height: 20),
          _fieldRaw("Max AP:", maxAP, isDigit: true),
          const SizedBox(height: 20),
          _fieldRaw("Wounds:", wounds, isDigit: true),
          const SizedBox(height: 20),
          _fieldRaw("Stim:", stim, isDigit: true),
          const SizedBox(height: 20),
          _fieldRaw("Waste:", waste, isDigit: true),
          const SizedBox(height: 20),
          _fieldRaw("Prof:", prof),
          const SizedBox(height: 30),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () async{
              final newData = composeData();
              if (newData!=null){
                final ok = await BlocProvider.of<UserEditCubit>(context).save(newData);
                if (ok) Get.back();
              }
            },
          )
        ],
      ),
    );
  }

  UserData? composeData(){
    try{
      final List profs = jsonDecode(prof.text);
      return UserData(
          data.id,
          name.text,
          int.parse(curAP.text),
          int.parse(maxAP.text),
          int.parse(wounds.text),
          int.parse(stim.text),
          int.parse(waste.text),
          profs.cast());
    } on Exception catch (e){
      Get.showSnackbar(GetBar(message: e.toString()));
      return null;
    }
  }

  Widget _fieldRaw(String prefix, TextEditingController controller, {isDigit = false}) {
    return Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(prefix),
          ),
          const SizedBox(width: 30),
          SizedBox(
            width: 300,
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border:  OutlineInputBorder(),
              ),
              inputFormatters: [
                if (isDigit) FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
        ]
    );
  }
}



class UserEditCubit extends Cubit<UserEditState>{
  UserEditCubit(this.id) : super (UserEditState());

  final int id;
  final HttpConnectController http = Get.find();

  Future<void> load() async{
    try {
      final resp = await http.fetch("/users/$id");
      if (resp.statusCode != 200) throw Exception("HTTP CODE ${resp.statusCode}");
      final json = jsonDecode(resp.body);
      final data = UserData.fromJson(json);
      emit(UserEditState(success: true, data: data));
    } on Exception catch (e){
      emit(UserEditState(success: false, err: e));
    }
  }

  Future<bool> save(UserData data) async{
    try {
      final resp = await http.post("/users/$id", body: <String, String>{
        "name": data.name,
        "cur_ap": data.curAP.toString(),
        "max_ap": data.maxAP.toString(),
        "wounds": data.wounds.toString(),
        "stim": data.stim.toString(),
        "waste": data.waste.toString(),
        "prof": jsonEncode(data.prof),
      });
      if (resp.statusCode != 200) throw Exception("HTTP CODE ${resp.statusCode}");
      return true;
    } on Exception catch (e){
      return false;
    }
  }
}

class UserEditState{
  final bool? success;
  final UserData? data;
  final Exception? err;
  UserEditState({this.success, this.data, this.err});
}