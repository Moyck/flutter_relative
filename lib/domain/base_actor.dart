import 'package:flutter/material.dart';
import 'package:interactive/relative_layout.dart';
import 'package:interactive/relative_movavle_widget.dart';

import 'base_temp.dart';

class BaseActor {
  String tag;
  BaseTemp child;
  String toTop;
  String toBottom;
  String toLeft;
  String toRight;
  String beTop;
  String beBottom;
  String beLeft;
  String beRight;
  double marginLeft;
  double marginTop;
  bool isSelected = false;

  BaseActor(this.tag,
      {this.child,
      this.toTop,
      this.toBottom,
      this.toLeft,
      this.toRight,
      this.beTop,
      this.beLeft,
      this.beRight,
      this.beBottom,
      this.marginLeft = 0,
      this.marginTop = 0});

  Widget buildRelativeWidget() {
    return RelativeMovableWidget(this);
  }
}
