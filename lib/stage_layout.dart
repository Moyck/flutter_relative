import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class StageLayout extends MultiChildRenderObjectWidget {
  StageLayout({Key key, List<Widget> children = const <Widget>[]})
      : super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return StageRender();
  }
}

const PARENT = "parent";

class StageRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, StageParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, StageParentData> {
  List<RenderBox> prepareRenderBoxes;
  List<RenderBox> readiedRenderBoxes;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! StageParentData)
      child.parentData = StageParentData();
  }

  @override
  void performLayout() {
    prepareRenderBoxes = List();
    readiedRenderBoxes = List();
    prepareRenderBoxes = getChildrenAsList();
    BoxConstraints nonPositionedConstraints;
    nonPositionedConstraints = constraints.loosen();
    bool hasNonRelativeChildren = false;
    size = constraints.biggest;

    prepareRenderBoxes.forEach((child) {
      final StageParentData childParentData = child.parentData;
      if (!childParentData.isRelative()) {
        hasNonRelativeChildren = true;
      }
      if (!hasNonRelativeChildren) {
        layoutForRelativeChild(child);
      }
      child.layout(nonPositionedConstraints, parentUsesSize: true);
      readiedRenderBoxes.add(child);
    });
  }

  double measureDx(RenderBox child, StageParentData childParentData) {
    double xStartPoint;
    double xEndPoint;
    double dx;

    var beLeftPoint = measurePoint(childParentData.beLeft, child, childParentData, false, true, false);
    var toLeftPoint = measurePoint(childParentData.toLeft, child, childParentData, false, true, true);
    var beRightPoint = measurePoint(childParentData.beRight, child, childParentData, false, false, false);
    var toRightPoint = measurePoint(childParentData.toRight, child, childParentData, false, false, true);

    print('$beLeftPoint $toLeftPoint $beRightPoint $toRightPoint');

    [beLeftPoint,toLeftPoint,beRightPoint,toRightPoint].forEach((element) {
      if(element != null){
        if(xStartPoint == null)
          xStartPoint = element;
        else
          xEndPoint = element;
      }
    });

    print("$xStartPoint  $xEndPoint");

    if (xStartPoint == null && xEndPoint == null) {
      dx = 0.0;
    } else if (xStartPoint == null) {
      dx = xEndPoint - child.getMaxIntrinsicWidth(0);
    } else if (xEndPoint == null) {
      dx = xStartPoint;
    } else {
      dx = (xEndPoint - xStartPoint).abs() / 2 +
          math.min(xStartPoint, xEndPoint) -
          child.getMaxIntrinsicWidth(0) / 2;
    }

    return dx;
  }

  double measureDy(RenderBox child, StageParentData childParentData) {
    double yStartPoint;
    double yEndPoint;
    double dy;

    var beTopPoint = measurePoint(childParentData.beTop, child, childParentData, true, true, false);
    var toTopPoint = measurePoint(childParentData.toTop, child, childParentData, true, true, true);
    var beBottomPoint = measurePoint(childParentData.beBottom, child, childParentData, true, false, false);
    var toBottomPoint = measurePoint(childParentData.toBottom, child, childParentData, true, false, true);

    [beTopPoint,toTopPoint,beBottomPoint,toBottomPoint].forEach((element) {
      if(element != null){
        if(yStartPoint == null)
          yStartPoint = element;
        else
          yEndPoint = element;
      }
    });

    if (yStartPoint == null && yEndPoint == null) {
      dy = 0.0;
    } else if (yStartPoint == null) {
      dy = yEndPoint - child.getMaxIntrinsicHeight(0);
    } else if (yEndPoint == null) {
      dy = yStartPoint;
    } else {
      dy = (yEndPoint - yStartPoint) / 2 +
          yStartPoint -
          child.getMaxIntrinsicHeight(0) / 2;
    }

    return dy;
  }

  double measurePoint(
      String align,
      RenderBox child,
      StageParentData childParentData,
      bool isVertical,
      bool isStartPoint,
      bool isOutSide) {
    double point;
    if (align != null) {
      if (align == PARENT) {
        point = 0;
        if (!isStartPoint) {
          if (isVertical) {
            point = size.height;
            if (isOutSide) {
              point += child.getMaxIntrinsicHeight(0);
            }
          } else {
            point = size.width;
            if (isOutSide) {
              point += child.getMaxIntrinsicWidth(0);
            }
          }
        }
      } else {
        var targetRenderBox = getRenderBoxByTag(align);
        assert(targetRenderBox != null, 'Tag is wrong!');
        var targetParentData = targetRenderBox.parentData as StageParentData;
        if (isVertical) {
          point = targetParentData.offset.dy;
          if (isStartPoint) {
            if (isOutSide) {
              point -= child.getMaxIntrinsicHeight(0);
            }
          } else {
            point += targetRenderBox.getMaxIntrinsicHeight(0);
            if(isOutSide){
              point += child.getMaxIntrinsicHeight(0);
            }
          }
        } else {
          point = targetParentData.offset.dx;
          if (isStartPoint) {
            if (isOutSide) {
              point -= child.getMaxIntrinsicWidth(0);
            }
          } else {
            point += targetRenderBox.getMaxIntrinsicWidth(0);
            if(isOutSide){
              point += child.getMaxIntrinsicWidth(0);
            }
          }
        }
      }
    }
    return point;
  }

  void layoutForRelativeChild(RenderBox child) {
    final StageParentData childParentData = child.parentData;
    var needLayout = true;
    var tags = childParentData.getRelyChildrenTags();
    tags.forEach((tag) {
      if (tag != PARENT && getRenderBoxByTag(tag) == null) {
        needLayout = false;
      }
    });
    if (needLayout) {
      assert(childParentData.isMeasureAble(),
          'There can only be two or less constraints in the same direction');
      childParentData.offset = Offset(
          measureDx(child, childParentData), measureDy(child, childParentData));
    }
  }

  RenderBox getRenderBoxByTag(String tag) {
    for (RenderBox child in readiedRenderBoxes) {
      final StageParentData childParentData = child.parentData;
      if (childParentData.tag == tag) {
        return child;
      }
    }
    return null;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

class Relative extends ParentDataWidget<StageParentData> {
  final Widget child;
  final Key key;
  final String tag;
  final String toTop;
  final String toBottom;
  final String toLeft;
  final String toRight;
  final String beTop;
  final String beBottom;
  final String beLeft;
  final String beRight;
  final EdgeInsets margin;

  const Relative(this.tag,
      {this.toTop,
      this.toBottom,
      this.toLeft,
      this.toRight,
      this.beTop,
      this.beBottom,
      this.beLeft,
      this.beRight,
      this.margin,
      this.child,
      this.key})
      : super(key: key, child: child);

  @override
  void applyParentData(RenderObject renderObject) {
    final StageParentData parentData =
        renderObject.parentData as StageParentData;
    parentData.tag = tag;
    parentData.toTop = toTop;
    parentData.toBottom = toBottom;
    parentData.toLeft = toLeft;
    parentData.toRight = toRight;
    parentData.beTop = beTop;
    parentData.beBottom = beBottom;
    parentData.beLeft = beLeft;
    parentData.beRight = beRight;
  }

  @override
  Type get debugTypicalAncestorWidgetClass => StageLayout;
}

class StageParentData extends ContainerBoxParentData<RenderBox> {
  String tag;
  String toTop;
  String toBottom;
  String toLeft;
  String toRight;
  String beTop;
  String beBottom;
  String beLeft;
  String beRight;
  EdgeInsets margin;

  bool isMeasureAble() {
    List<String> horizontal = List();
    List<String> vertical = List();
    if (toTop != null) {
      vertical.add(toTop);
    }
    if (beTop != null) {
      vertical.add(beTop);
    }
    if (toBottom != null) {
      vertical.add(toBottom);
    }
    if (beBottom != null) {
      vertical.add(beBottom);
    }

    if (toLeft != null) {
      horizontal.add(toLeft);
    }
    if (toRight != null) {
      horizontal.add(toRight);
    }
    if (beLeft != null) {
      horizontal.add(beLeft);
    }
    if (beRight != null) {
      horizontal.add(beRight);
    }

    return vertical.length < 3 && horizontal.length < 3;
  }

  bool isRelative() {
    return tag != null;
  }

  List<String> getRelyChildrenTags() {
    List<String> tags = List();
    if (toTop != null) {
      tags.add(toTop);
    }
    if (toBottom != null) {
      tags.add(toBottom);
    }
    if (toLeft != null) {
      tags.add(toLeft);
    }
    if (toRight != null) {
      tags.add(toRight);
    }
    if (beTop != null) {
      tags.add(beTop);
    }
    if (beBottom != null) {
      tags.add(beBottom);
    }
    if (beLeft != null) {
      tags.add(beLeft);
    }
    if (beRight != null) {
      tags.add(beRight);
    }
    return tags;
  }
}
