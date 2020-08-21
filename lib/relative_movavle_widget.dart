import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interactive/stage_layout.dart';

class RelativeMovableWidget extends StatelessWidget {
  final ReOffset margin;

  const RelativeMovableWidget(this.margin);

  @override
  Widget build(BuildContext context) {
    print('build  ' + margin.left.toString() + "  " + margin.top.toString());

    var marginLeft = margin.left;
    var marginTop = margin.top;
    return Relative('tags',
        margin: EdgeInsets.fromLTRB(marginLeft, marginTop, 0, 0),
        child: Listener(
            onPointerMove: (ev) {

            },
            child: Container(
              color: Colors.yellow,
              width: 100,
              height: 100,
            )));
  }
}


class ReOffset {
  double left;
  double top;

  ReOffset(this.left,this.top);
}
