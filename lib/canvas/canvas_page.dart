import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/canvas/images_controller.dart';
import 'package:get/get.dart';
import 'package:touchable/touchable.dart';

const full = 800.0;
const half = full / 2;
const cullRect = Rect.fromLTRB(0, 0, full, full);

class CanvasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        maxScale: 10,
        minScale: 0.5,
        onInteractionUpdate: (details) {
          Get.find<ImagesController>().scale *= details.scale;
        },
        boundaryMargin: EdgeInsets.all(half),
        child: Container(
          width: full,
          height: full,
          color: Colors.black,
          child: GetBuilder<ImagesController>(
            builder: (c) {
              return CanvasTouchDetector(
                builder: (context) => CustomPaint(
                  painter: myPainter(context, c.images),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class myPainter extends CustomPainter {
  Map<String, ui.Image> images;
  final BuildContext context;
  myPainter(this.context, this.images) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final myPaint = Paint();
    final ship = images['ship.png'];
    if (ship != null) {
      final s = ship;
      final w = s.width.toDouble();
      final h = s.height.toDouble();

      canvas.drawImageRect(
          ship,
          Rect.fromLTWH(0, 0, s.width.toDouble(), s.height.toDouble()),
          Rect.fromLTWH(100, 100, 35, 35),
          myPaint);
      canvas.drawImageRect(
          s,
          Rect.fromLTWH(0, 0, s.width.toDouble(), s.height.toDouble()),
          Rect.fromLTWH(200, 200, half * 0.8, half * 0.8),
          myPaint);
      canvas.drawImageRect(
          s,
          Rect.fromLTWH(0, 0, s.width.toDouble(), s.height.toDouble()),
          Rect.fromLTWH(300, 300, half * 1.0, half * 1.0),
          myPaint);
    }

    final atlas = images['planet_ani.png'];
    if (atlas != null) {
      final sprites = <Sprite>[
        Sprite(pn: 0, offset: Offset(400, 100), angle: 45),
        Sprite(pn: 10, offset: Offset(100, 400), size: 2, color: Colors.green),
      ];

      _drawSprites(canvas, atlas, sprites);
    }

    final points = <Offset>[
      Offset(100, 100),
      Offset(300, 200),
      Offset(400, 400),
      Offset(200, 100),
      Offset(100, 100),
    ];
    canvas.drawPoints(
        ui.PointMode.polygon,
        points,
        myPaint
          ..color = Colors.red
          ..strokeWidth = 4);

    final positions = <Offset>[
      Offset(400, 400),
      Offset(600, 400),
      Offset(500, 500),
    ];
    final vertices = ui.Vertices(VertexMode.triangles, positions);
    canvas.drawVertices(vertices, BlendMode.srcOver, myPaint);

    final path = ui.Path()
      ..moveTo(600, 600)
      ..lineTo(700, 700)
      ..quadraticBezierTo(500, 400, 400, 500);
    canvas.drawPath(
        path,
        myPaint
          ..color = Colors.yellow
          ..strokeWidth = 2
          ..style = ui.PaintingStyle.stroke);

    canvas.drawShadow(path, Colors.red, 5, true);
    canvas.drawShadow(path, Colors.blue, -5, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void _drawSprites(Canvas canvas, ui.Image atlas, List<Sprite> sprites) {
    final w = atlas.width.toDouble();
    final h = atlas.height.toDouble();
    final pw = w / 5;
    final ph = h / 4;

    final paint = Paint();
    final rects = sprites.map((s) {
      final x = s.pn % 5;
      final y = s.pn ~/ 5;
      return Rect.fromLTWH(x * pw, y * ph, pw, ph);
    }).toList();
    final transforms = sprites.map((s) {
      return RSTransform.fromComponents(
        rotation: s.angle / 180 * pi,
        anchorX: pw / 2,
        anchorY: ph / 2,
        translateX: s.offset.dx,
        translateY: s.offset.dy,
        scale: s.size,
      );
    }).toList();
    final colors = sprites.map((s) => s.color).toList();
    canvas.drawAtlas(
        atlas, transforms, rects, colors, BlendMode.modulate, cullRect, paint);
    for (final s in sprites) {
      final span = TextSpan(
        text: "ABC #${s.pn}",
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 20 / Get.find<ImagesController>().scale,
        ),
      );
      final tp = TextPainter(text: span, textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, s.offset.translate(-tp.maxIntrinsicWidth/2, ph));
    }
    final touchy = TouchyCanvas(context, canvas);
    final touchyPaint = Paint()..blendMode = BlendMode.dst;
    for (final s in sprites) {
      final rect = Rect.fromCenter(
          center: s.offset, width: pw * s.size, height: ph * s.size);
      touchy.drawOval(rect, touchyPaint, onTapDown: (details) {
        Get.snackbar("TAP", "cloicked touchy ${s.pn}");
      }, onPanStart: (details) {
        Get.snackbar("PAN", "pan satrt ${s.pn}");
      });
    }
  }
}

class Sprite {
  final int pn;
  final Color color;
  final Offset offset;
  final double size;
  final double angle;

  Sprite(
      {required this.pn,
      required this.offset,
      this.color = Colors.white,
      this.size = 1,
      this.angle = 0});
}
