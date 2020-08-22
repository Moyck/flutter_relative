// Flutter code sample for InteractiveViewer

// This example shows a simple Container that can be panned and zoomed.

import 'package:flutter/material.dart';
import 'package:interactive/domain/base_actor.dart';
import 'package:interactive/domain/base_temp.dart';
import 'package:interactive/domain/container_temp.dart';
import 'package:interactive/relative_layout.dart';

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
  ReOffset margin = ReOffset(250, 50);
  Color color = Colors.blue;

  List<BaseActor> actors;

  @override
  void initState() {
    super.initState();
    actors = List();
    actors.add(BaseActor('tag',
        beLeft: PARENT,
        beRight: PARENT,
        child: ContainerTemp(height: 200, width: 200, color: 0xffFFD341)));
    actors.add(BaseActor('tag1',
        toBottom: PARENT,
        beRight: PARENT,
        child: ContainerTemp(height: 200, width: 200, color: 0xff33D341)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: Container(
            color: Colors.black12,
            child: RelativeLayout(
              children: [
                Relative(
                  'TAG1',
                  beLeft: PARENT,
                  beRight: PARENT,
                  child:
                      Container(color: Colors.yellow, width: 100, height: 100),
                ),
                actors[0].buildRelativeWidget(),
                Relative( 'TAG2',
                    beLeft: PARENT,
                    beRight: PARENT,
                    beBottom: PARENT,
                    beTop: PARENT,
                    child: actors[0].child.buildWidget()),
              ],
            )),
      ),
    );
  }

  List<Widget> getActors() {
    return actors.map((e) => e.buildRelativeWidget()).toList();
  }
}
