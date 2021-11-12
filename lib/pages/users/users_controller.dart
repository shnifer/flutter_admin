import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin/connectors/http_controller.dart';
import 'package:flutter_admin/models/users.dart';
import 'package:get/get.dart';

class UsersCubit extends Cubit<UsersState>{
  final HttpConnectController http = Get.find();
  
  UsersCubit() : super(UsersState.init());

  Future<void> refresh () async{
    if (state.isLoading) {
      return;
    }
    var stillLoading = true;
    Future.delayed(const Duration(milliseconds: 300)).
       then((_) {if (stillLoading) emit(UsersState.loading());});
    try {
      final data = await _download();
      stillLoading = false;
      emit(UsersState.ready(data));
    } on Exception catch (e){
      stillLoading = false;
      emit(UsersState.failed(e));
    }
  }

  Future<void> addDef() async{
    try {
      final resp = await http.post("/users");
      if (resp.statusCode != 200) throw Exception("HTTP CODE ${resp.statusCode}");
      refresh();
    } on Exception catch (e){
      emit(UsersState.failed(e));
    }
  }

  Future<void> delete(int id) async{
    try {
      final resp = await http.delete("/users/$id");
      if (resp.statusCode != 200) throw Exception("HTTP CODE ${resp.statusCode}");
      refresh();
    } on Exception catch (e){
      emit(UsersState.failed(e));
    }
  }

  Future<List<UserData>> _download() async{
    final resp = await http.fetch("/users");
    if (resp.statusCode != 200) throw Exception("HTTP CODE ${resp.statusCode}");
    final json = jsonDecode(resp.body);
    return json['items'].map<UserData>(
      (itemJson) => UserData.fromJson(itemJson)
    ).toList();
  }
}

enum LoadPhase {init, loading, ready, failed}

class UsersState {
  final LoadPhase phase;
  final Exception? err;
  final List<UserData> users;

  const UsersState(this.phase, {this.users = const [], this.err});
  UsersState.init() : this(LoadPhase.init);
  UsersState.loading() : this(LoadPhase.loading);
  UsersState.ready(List<UserData> data) : this(LoadPhase.ready, users: data);
  UsersState.failed(Exception err) : this(LoadPhase.failed, err: err);

  get isLoading => phase == LoadPhase.loading;

  @override
  String toString() => "$phase users=$users err=$err";
}