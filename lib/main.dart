// Flutter code sample for InteractiveViewer

// This example shows a simple Container that can be panned and zoomed.

import 'package:flutter/material.dart';
import 'package:interactive/domain/base_actor.dart';
import 'package:interactive/domain/base_temp.dart';
import 'package:interactive/domain/container_temp.dart';
import 'package:interactive/relative_layout.dart';
import 'package:provider/provider.dart';

import 'provider/stage_provider.dart';
import 'relative_movavle_widget.dart';

void main() => runApp(MultiProvider(
    providers: [ChangeNotifierProvider.value(value:StageProvider())],
    child: MyApp()));

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
          body: Container(
              color: Colors.black12,
              child: Consumer<StageProvider>(builder: (context, provider, _) {
                return RelativeLayout(children: provider.actors.map((e) => e.buildRelativeWidget()).toList());
              }))),
    );
  }


}
