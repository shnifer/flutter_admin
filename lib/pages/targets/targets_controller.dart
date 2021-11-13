import 'dart:async';
import 'dart:convert';
import 'package:flutter_admin/connectors/http_controller.dart';
import 'package:flutter_admin/models/targets.dart';
import 'package:get/get.dart';

class TargetsController extends GetxController{
  final HttpConnectController http = Get.find();
  Timer? _timer;
  List<TargetData> targets = [];

  TargetsController({int dt_ms = 33}) : super() { //30 fps
    _timer = Timer.periodic(Duration(milliseconds: dt_ms), tick);
    tick(_timer);
  }

  tick(_) async{
    try {
      final resp = await http.fetch("/targets");
      final json = jsonDecode(resp.body);
      targets = json['items'].map(
          (v) => TargetData.fromJson(v)
      ).toList().cast<TargetData>();
      update();
    } on Exception catch(e){
      print("ERROR loading targets: $e");
    }
  }

  void shuffle(){
    http.post("/targets");
  }

  @override
  InternalFinalCallback<void> get onDelete {
    _timer?.cancel();
    return super.onDelete;
  }
}