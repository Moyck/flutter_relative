import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interactive/domain/base_actor.dart';
import 'package:interactive/provider/stage_provider.dart';
import 'package:interactive/relative_layout.dart';
import 'package:provider/provider.dart';

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
    return Relative(widget._baseActor.tag,
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
            onPointerDown: (ev) {
              Provider.of<StageProvider>(context, listen: false)
                  .changeCurrentActor(widget._baseActor);
            },
            onPointerMove: (ev) {
              widget._baseActor.marginLeft += ev.delta.dx;
              widget._baseActor.marginTop += ev.delta.dy;
              Provider.of<StageProvider>(context, listen: false).refresh();
            },
            child: !widget._baseActor.isSelected
                ? widget._baseActor.child.buildWidget()
                : Container(
                    child: RelativeLayout(
                    children: [
                      Relative('re',
                          child: widget._baseActor.child.buildWidget()),
                      Relative('re1',
                          toTop: 're',
                          toLeft: 're',
                          toBottom: 're',
                          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: InkWell(
                              onTap: () {
                                Provider.of<StageProvider>(context,
                                        listen: false)
                                    .changeCurrentPoint(LEFT_POINT);
                              },
                              child: Image.asset(
                                'assets/image/point.png',
                                color: Provider.of<StageProvider>(context,
                                                listen: false)
                                            .currentPoint ==
                                        LEFT_POINT
                                    ? Colors.redAccent
                                    : Colors.blue,
                                width: 50,
                                height: 50,
                              ))),
                      Relative('re2',
                          toTop: 're',
                          toRight: 're',
                          toLeft: 're',
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: InkWell(
                              onTap: () {
                                Provider.of<StageProvider>(context,
                                        listen: false)
                                    .changeCurrentPoint(TOP_POINT);
                              },
                              child: Image.asset(
                                'assets/image/point.png',
                                color: Provider.of<StageProvider>(context,
                                                listen: false)
                                            .currentPoint ==
                                        TOP_POINT
                                    ? Colors.redAccent
                                    : Colors.blue,
                                width: 50,
                                height: 50,
                              ))),
                      Relative('re3',
                          toBottom: 're',
                          toRight: 're',
                          toTop: 're',
                          margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: InkWell(
                              onTap: () {
                                Provider.of<StageProvider>(context,
                                        listen: false)
                                    .changeCurrentPoint(RIGHT_POINT);
                              },
                              child: Image.asset(
                                'assets/image/point.png',
                                color: Provider.of<StageProvider>(context,
                                                listen: false)
                                            .currentPoint ==
                                        RIGHT_POINT
                                    ? Colors.redAccent
                                    : Colors.blue,
                                width: 50,
                                height: 50,
                              ))),
                      Relative('re4',
                          toBottom: 're',
                          toRight: 're',
                          toLeft: 're',
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: InkWell(
                              onTap: () {
                                Provider.of<StageProvider>(context,
                                        listen: false)
                                    .changeCurrentPoint(BOTTOM_POINT);
                              },
                              child: Image.asset(
                                'assets/image/point.png',
                                color: Provider.of<StageProvider>(context,
                                                listen: false)
                                            .currentPoint ==
                                        BOTTOM_POINT
                                    ? Colors.redAccent
                                    : Colors.blue,
                                width: 50,
                                height: 50,
                              ))),
                    ],
                  ))));
  }
}

class ReOffset {
  double left;
  double top;

  ReOffset(this.left, this.top);
}
