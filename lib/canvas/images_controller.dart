import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'dart:isolate';

class DecodeParam {
  final String name;
  final SendPort sendPort;
  DecodeParam(this.name, this.sendPort);
}

class ImagesController extends GetxController {
  Map<String, Image> images = {};
  var scale = 1.0;
  final names = <String>["ship.png", "planet_ani.png"];

  loadImages() async{
    for (final name in names){
      images[name] = await _loadAsset(name);
    }
    update();
  }

  Future<Image> _loadAsset(String name) async{
    final data = await rootBundle.load(name);
    final buf = await ImmutableBuffer.fromUint8List(data.buffer.asUint8List());
    final descr = await ImageDescriptor.encoded(buf);
    final codec = await descr.instantiateCodec();
    assert (codec.frameCount==1);
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;
    codec.dispose();
    descr.dispose();
    buf.dispose();
    return image;
  }

  @override
  void dispose() {
    for (final image in images.values) {
      image.dispose();
    }
    super.dispose();
  }
}