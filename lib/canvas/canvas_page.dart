import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/canvas/images_controller.dart';
import 'package:get/get.dart';

const full = 800.0;
const half = full / 2;
const cullRect = Rect.fromLTRB(0, 0, full, full);

class CanvasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: full,
        height: full,
        color: Colors.black,
        child: GetBuilder<ImagesController>(
          builder: (c) {
            return CustomPaint(
              painter: myPainter(c.images),
            );
          },
        ),
      ),
    );
  }
}

class myPainter extends CustomPainter {
  Map<String, ui.Image> images;

  myPainter(this.images) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final myPaint = Paint();
    final ship = images['ship.png'];
    if (ship != null) {
      final s = ship;
      final w = s.width.toDouble();
      final h = s.height.toDouble();

      canvas.drawImageRect(ship, Rect.fromLTWH(0, 0, s.width.toDouble(), s.height.toDouble()),
          Rect.fromLTWH(100, 100, half*0.6, half*0.6), myPaint);
      canvas.drawImageRect(s, Rect.fromLTWH(0, 0, s.width.toDouble(), s.height.toDouble()),
          Rect.fromLTWH(200, 200, half*0.8, half*0.8), myPaint);
      canvas.drawImageRect(s, Rect.fromLTWH(0, 0, s.width.toDouble(), s.height.toDouble()),
          Rect.fromLTWH(300, 300, half*1.0, half*1.0), myPaint);
    }

    final atlas = images['planet_ani.png'];
    if (atlas != null){
      final sprites = <Sprite>[
        Sprite(pn: 0, offset: Offset(400,100), angle: 45),
        Sprite(pn: 10, offset: Offset(100,400), size: 2, color: Colors.green),
      ] ;

      _drawSprites(canvas, atlas, sprites);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void _drawSprites(Canvas canvas, ui.Image atlas, List<Sprite> sprites) {
    final w = atlas.width.toDouble();
    final h = atlas.height.toDouble();
    final pw = w/5;
    final ph = h/4;

    final paint = Paint();
    final rects = sprites.map((s) {
      final x = s.pn % 5;
      final y = s.pn ~/ 5;
      return Rect.fromLTWH(x*pw, y*ph, pw, ph);
    }).toList();
    final transforms = sprites.map((s) {
      return RSTransform.fromComponents(
        rotation: s.angle/180*pi,
        anchorX: pw/2,
        anchorY: ph/2,
        translateX: s.offset.dx,
        translateY: s.offset.dy,
        scale: s.size,
      );
    }).toList();
    final colors = sprites.map((s) => s.color).toList();
    canvas.drawAtlas(atlas, transforms, rects, colors, BlendMode.modulate, cullRect, paint);
  }
}

class Sprite{
  final int pn;
  final Color color;
  final Offset offset;
  final double size;
  final double angle;

  Sprite({required this.pn, required this.offset, this.color=Colors.white, this.size=1, this.angle=0});
}