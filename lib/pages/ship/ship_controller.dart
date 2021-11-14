import 'dart:convert';

import 'package:flutter_admin/models/ship.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin/connectors/http_controller.dart';
import 'package:get/get.dart';

class ShipCubit extends Cubit<ShipState>{
  final HttpConnectController http = Get.find();

  ShipCubit() : super(ShipState.init());

  refresh () async{
    if (state.isLoading) {
      return;
    }
    var stillLoading = true;
    Future.delayed(const Duration(milliseconds: 300)).
    then((_) {if (stillLoading) emit(ShipState.loading());});
    try {
      final data = await _download();
      stillLoading = false;
      emit(ShipState.ready(data));
    } on Exception catch (e){
      stillLoading = false;
      emit(ShipState.failed(e));
    }
  }

  Future<ShipData> _download() async{
    final resp = await http.fetch("/ship");
    final json = jsonDecode(resp.body);
    return ShipData.fromJson(json);
  }

  Future<void> patchField(String field, String val) async{
    try {
      final patch = <String, String>{field: val};
      await http.post("/ship", body: patch);
    } on Exception catch (e) {
      print("ERR: edit ship: $e");
    }
  }

  Future<void> patch(Map<String, String> patch) async{
    try {
      await http.post("/ship", body: patch);
    } on Exception catch (e) {
      print("ERR: edit ship: $e");
    }
  }
}

enum LoadPhase {init, loading, ready, failed}

class ShipState {
  final LoadPhase phase;
  final Exception? err;
  final ShipData? ship;

  const ShipState(this.phase, {this.ship, this.err});
  ShipState.init() : this(LoadPhase.init);
  ShipState.loading() : this(LoadPhase.loading);
  ShipState.ready(ShipData data) : this(LoadPhase.ready, ship: data);
  ShipState.failed(Exception err) : this(LoadPhase.failed, err: err);

  get isLoading => phase == LoadPhase.loading;

  @override
  String toString() => "$phase ship=$ship err=$err";
}