import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_admin/connectors/http_controller.dart';
import 'package:flutter_admin/models/rooms.dart';
import 'package:get/get.dart';

class RoomsCubit extends Cubit<RoomsState>{
  final HttpConnectController http = Get.find();
  
  RoomsCubit() : super(RoomsState.init());

  refresh () async{
    if (state.isLoading) {
      print("refresh already loading skipped");
      return;
    }
    emit(RoomsState.loading());
    try {
      final data = await _download();
      emit(RoomsState.ready(data));
    } on Exception catch (e){
      emit(RoomsState.failed(e));
    }
  }

  Future<List<RoomData>> _download() async{
    final resp = await http.fetch("/rooms");
    if (resp.statusCode != 200) throw Exception("HTTP CODE ${resp.statusCode}");
    final json = jsonDecode(resp.body);
    return json['items'].map<RoomData>(
      (itemJson) => RoomData.fromJson(itemJson)
    ).toList();
  }
}

enum LoadPhase {init, loading, ready, failed}

class RoomsState {
  final LoadPhase phase;
  final Exception? err;
  final List<RoomData> rooms;

  const RoomsState(this.phase, {this.rooms = const [], this.err});
  RoomsState.init() : this(LoadPhase.init);
  RoomsState.loading() : this(LoadPhase.loading);
  RoomsState.ready(List<RoomData> data) : this(LoadPhase.ready, rooms: data);
  RoomsState.failed(Exception err) : this(LoadPhase.failed, err: err);

  get isLoading => phase == LoadPhase.loading;

  @override
  String toString() => "$phase rooms=$rooms err=$err";
}