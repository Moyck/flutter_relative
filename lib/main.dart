// Flutter code sample for InteractiveViewer

// This example shows a simple Container that can be panned and zoomed.

import 'package:flutter/material.dart';
import 'package:interactive/stage_layout.dart';

import 'relative_movavle_widget.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';
  double left = 0;
  double top = 0;
  double right = 0;
  double bottom = 0;

  @override
  Widget build(BuildContext context) {
    return Page();
  }
}

class Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageState();
  }
}


class PageState extends State<Page> {
  static const String _title = 'Flutter Code Sample';
  double left = 0;
  double top = 0;
  double right = 0;
  double bottom = 0;
  ReOffset margin = ReOffset(250,50);
  Color color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: Container(
            color: Colors.black12,
            child: StageLayout(
              children: [
                Relative("no2",
                    beRight: "no1",
                    beLeft: "no1",
                    beTop: "no1",
                    beBottom: "no1",
                    margin: EdgeInsets.fromLTRB(left, top, right, bottom),
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.amber,
                    )),
                Relative("no1",
                    beRight: PARENT,
                    beLeft: PARENT,
                    beTop: PARENT,
                    beBottom: PARENT,
                    child: Listener(
                        onPointerDown: (det) {
                          print("inwwwww");
                          setState(() {
                            margin = ReOffset(0, 50);
                          });
                        },
                        child: Container(
                          width: 300,
                          height: 300,
                          color: color.withAlpha(150),
                        ))),
                Relative("no3",
                    beRight: "no2",
                    beLeft: "no2",
                    toTop: "no2",
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.green,
                    )),
                Relative("no4",
                    beRight: "no2",
                    beLeft: "no2",
                    toBottom: "no2",
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.green,
                    )),
                Relative("no5",
                    toLeft: "no2",
                    beTop: "no2",
                    beBottom: "no2",
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.green,
                    )),
                Relative("no6",
                    toRight: "no2",
                    beTop: "no2",
                    beBottom: "no2",
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.green,
                    )),
                Relative("no6",
                    beTop: "no2",
                    beLeft: "no2",
                    beRight: "no2",
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.white70,
                    )),
                Relative("no7",
                    beBottom: "no2",
                    beLeft: "no2",
                    beRight: "no2",
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.white70,
                    )),
                Relative("no8",
                    beBottom: "no2",
                    beRight: "no2",
                    beTop: "no2",
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.white70,
                    )),
                Relative("no9",
                    beBottom: "no2",
                    beLeft: "no2",
                    beTop: "no2",
                    child: Container(
                      width: 60,
                      height: 60,
                      color: color,
                    )),
                RelativeMovableWidget(margin),
              ],
            )),
      ),
    );
  }
}
