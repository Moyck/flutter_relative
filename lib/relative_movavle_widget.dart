import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interactive/domain/base_actor.dart';
import 'package:interactive/relative_layout.dart';

class RelativeMovableWidget extends StatefulWidget {
  final BaseActor _baseActor;

  const RelativeMovableWidget(this._baseActor);

  @override
  State<StatefulWidget> createState() {
    return RelativeMovableWidgetState();
  }

}

class RelativeMovableWidgetState extends State<RelativeMovableWidget> {

  @override
  Widget build(BuildContext context) {
    return  Relative(widget._baseActor.tag,
        beRight: widget._baseActor.beRight,
        beLeft: widget._baseActor.beLeft,
        beTop: widget._baseActor.beTop,
        beBottom: widget._baseActor.beBottom,
        toRight: widget._baseActor.toRight,
        toLeft: widget._baseActor.toLeft,
        toTop: widget._baseActor.toTop,
        toBottom: widget._baseActor.toBottom,
        margin: EdgeInsets.fromLTRB(
            widget._baseActor.marginLeft, widget._baseActor.marginTop, 0, 0),
        child: Listener(
            onPointerMove: (ev) {
              widget._baseActor.marginLeft += ev.delta.dx;
              widget._baseActor.marginTop += ev.delta.dy;
              setState(() {});
            },
            child: Container( child:  RelativeLayout(
              children: [
                Relative('re', child: widget._baseActor.child.buildWidget()),
                Relative('re1',
                    toTop: 're',
                    toLeft: 're',
                    toBottom: 're',
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Image.asset(
                      'assets/image/point.png',
                      width: 30,
                      height: 30,
                    )),
                Relative('re2',
                    toTop: 're',
                    toRight: 're',
                    toLeft: 're',
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Image.asset(
                      'assets/image/point.png',
                      width: 30,
                      height: 30,
                    )),
                Relative('re3',
                    toBottom: 're',
                    toRight: 're',
                    toTop: 're',
                    margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Image.asset(
                      'assets/image/point.png',
                      width: 30,
                      height: 30,
                    )),
                Relative('re4',
                    toBottom: 're',
                    toRight: 're',
                    toLeft: 're',
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Image.asset(
                      'assets/image/point.png',
                      width: 30,
                      height: 30,
                    )),
              ],
            ))));
  }
}

class ReOffset {
  double left;
  double top;

  ReOffset(this.left, this.top);
}
