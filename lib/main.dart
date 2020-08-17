// Flutter code sample for InteractiveViewer

// This example shows a simple Container that can be panned and zoomed.

import 'package:flutter/material.dart';
import 'package:interactive/stage_layout.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: Container(
            color: Colors.black12,
            child: StageLayout(
              children: [
                Relative("no1",
                    beTop: PARENT,
                    beLeft: PARENT,
                    beBottom: PARENT,
                    beRight: PARENT,
                    child: Container(
                      width: 300,
                      height: 300,
                      color: Colors.blue,
                    )),
                Relative("no2",
                    beTop: "no1",
                    beLeft: "no1",
                    beRight: "no1",
                    beBottom: "no1",
                    child: Container(
                      width: 120,
                      height: 120,
                      color: Colors.amber,
                    )),
                Relative("no3",
                    beTop: "no2",
                    beRight: "no2",
                    beLeft: "no1",
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.green,
                    )),
              ],
            )),
      ),
    );
  }
}
