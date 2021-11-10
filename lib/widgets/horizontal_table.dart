import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HorizontalTable extends StatelessWidget {
  final double width;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  const HorizontalTable({
    Key? key,
    this.width=1000,
    required this.columns,
    required this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      }),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: ScrollController(),
        child: SizedBox(
          width: width,
          child: DataTable2(
            columns: columns,
            rows: rows,
          ),
        ),
      ),
    );
  }
}
