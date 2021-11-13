import 'dart:ui' as ui;

import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/models/targets.dart';
import 'package:flutter_admin/pages/targets/targets_controller.dart';
import 'package:get/get.dart';
import 'package:touchable/touchable.dart';

const viewSize = 500.0;
const halfSize = viewSize / 2;
const viewK = 2.0;

class TargetsPage extends StatelessWidget {
  const TargetsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TargetsController c = TargetsController();
    return GetBuilder<TargetsController>(
        init: c,
        builder: (TargetsController controller) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            c.shuffle();
                          },
                          child: const Text("shuffle")),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: viewSize,
                    height: viewSize,
                    color: Colors.black,
                    child: CanvasTouchDetector(
                      builder: (context) => CustomPaint(
                        painter: MyPainter(context, controller.targets),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class MyPainter extends CustomPainter {
  final List<TargetData> data;
  final BuildContext context;
  MyPainter(this.context, this.data);

  static final linePaint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke;

  static final arrowPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final myCanvas = TouchyCanvas(context, canvas);
    myCanvas.clipRect(const Rect.fromLTWH(0, 0, viewSize, viewSize));
    myCanvas.drawLine(const Offset(halfSize, 0), const Offset(halfSize, viewSize), linePaint);
    myCanvas.drawLine(const Offset(0, halfSize), const Offset(viewSize, halfSize), linePaint);
    myCanvas.drawRRect(
        const RRect.fromLTRBXY(-110 * viewK + halfSize, -110 * viewK + halfSize,
            110 * viewK + halfSize, 110 * viewK + halfSize, 20, 20),
        linePaint);

    for (final item in data) {
      _drawTarget(myCanvas, item);
    }
  }

  void _drawTarget(TouchyCanvas canvas, TargetData item) {
    final centerOff = Offset(item.pos.x * viewK + halfSize, item.pos.y * viewK + halfSize);
    canvas.drawCircle(
      centerOff,
      item.size * viewK,
      Paint()..color = item.color,
      onTapDown: (_) {
        Get.snackbar("Удар!", "Tapped target #${item.id} (${item.name})");
      },
    );

    final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle());
    paragraphBuilder.pushStyle(ui.TextStyle(color: Colors.yellow));
    paragraphBuilder.addText(item.name);
    final paragraph = paragraphBuilder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: 80));
    canvas.drawParagraph(
        paragraph, centerOff.translate(-paragraph.longestLine / 2, item.size * viewK + 10));

    /// Draw a single arrow.
    var path = Path()
      ..moveTo(item.pos.x * viewK + halfSize, item.pos.y * viewK + halfSize)
      ..relativeLineTo(item.vel.x * 3, item.vel.y * 3);
    path = ArrowPath.make(path: path);
    canvas.drawPath(path, arrowPaint);
  }

  @override
  bool shouldRepaint(_) => true;
}
