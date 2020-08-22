import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class RelativeLayout extends MultiChildRenderObjectWidget {

  MainAxisSize mainAxisSize;

 RelativeLayout({Key key, List<Widget> children = const <Widget>[],this.mainAxisSize})
      : super(key: key, children: children);


  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRelative(mainAxisSize: mainAxisSize);
  }

  @override
  void updateRenderObject(BuildContext context, RenderRelative stageRender) {
    print('updateRenderObject');
    super.updateRenderObject(context, stageRender);
    stageRender.update();
  }

}

const PARENT = "parent";

class RenderRelative extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, RelativeParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, RelativeParentData> {
  List<RenderBox> prepareRenderBoxes;
  List<RenderBox> readiedRenderBoxes;
  MainAxisSize mainAxisSize;

  RenderRelative({this.mainAxisSize});

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! RelativeParentData)
      child.parentData = RelativeParentData();
  }

  void update(){
    markNeedsLayout();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }


  @override
  void performLayout() {
    prepareRenderBoxes = List();
    readiedRenderBoxes = List();
    prepareRenderBoxes = getChildrenAsList();
    if(mainAxisSize != null){
      if(mainAxisSize == MainAxisSize.min){
        size = constraints.smallest;
      }
    }else{
      size = constraints.biggest;
    }
    layoutChildren();
  }

  void layoutChildren() {
    bool hasNonRelativeChildren = false;
    int hadLayoutChildCount = 0;
    for (int i = 0; i < prepareRenderBoxes.length; i++) {
      RenderBox child = prepareRenderBoxes[i];
      final RelativeParentData childParentData = child.parentData;
      if (!childParentData.isRelative()) {
        hasNonRelativeChildren = true;
      }
      if (!hasNonRelativeChildren) {
        if (!layoutForRelativeChild(child)) {
          continue;
        }
      }
      readiedRenderBoxes.add(child);
      prepareRenderBoxes.remove(child);
      i--;
      hadLayoutChildCount++;
      child.layout(constraints.loosen(), parentUsesSize: true);
    }
    if (prepareRenderBoxes.isNotEmpty) {
      if (hadLayoutChildCount != 0) {
        layoutChildren();
      } else {
        var unLayoutChildTag = "";
        prepareRenderBoxes.forEach((element) {
          unLayoutChildTag += (element.parentData as RelativeParentData).tag + " ";
        });
        assert(false, 'Tag $unLayoutChildTag can not sure layout.');
      }
    }
  }

  double measureDx(RenderBox child, RelativeParentData childParentData) {
    double xStartPoint;
    double xEndPoint;
    double dx;

    var beLeftPoint = measurePoint(
        childParentData.beLeft, child, childParentData, false, true, false);
    var toLeftPoint = measurePoint(
        childParentData.toLeft, child, childParentData, false, true, true);
    var beRightPoint = measurePoint(
        childParentData.beRight, child, childParentData, false, false, false);
    var toRightPoint = measurePoint(
        childParentData.toRight, child, childParentData, false, false, true);

    [beLeftPoint, toLeftPoint, beRightPoint, toRightPoint].forEach((element) {
      if (element != null) {
        if (xStartPoint == null)
          xStartPoint = element;
        else
          xEndPoint = element;
      }
    });

    if (xStartPoint == null && xEndPoint == null) {
      dx = 0.0;
    } else if (xEndPoint == null) {
      dx = xStartPoint - child.getMaxIntrinsicWidth(0) / 2;
    } else {
      dx = (xEndPoint - xStartPoint).abs() / 2 +
          math.min(xStartPoint, xEndPoint) -
          child.getMaxIntrinsicWidth(0) / 2;
    }

    return dx;
  }

  double measureDy(RenderBox child, RelativeParentData childParentData) {
    double yStartPoint;
    double yEndPoint;
    double dy;

    var beTopPoint = measurePoint(
        childParentData.beTop, child, childParentData, true, true, false);
    var toTopPoint = measurePoint(
        childParentData.toTop, child, childParentData, true, true, true);
    var beBottomPoint = measurePoint(
        childParentData.beBottom, child, childParentData, true, false, false);
    var toBottomPoint = measurePoint(
        childParentData.toBottom, child, childParentData, true, false, true);

    [beTopPoint, toTopPoint, beBottomPoint, toBottomPoint].forEach((element) {
      if (element != null) {
        if (yStartPoint == null)
          yStartPoint = element;
        else
          yEndPoint = element;
      }
    });

    if (yStartPoint == null && yEndPoint == null) {
      dy = 0.0;
    } else if (yEndPoint == null) {
      dy = yStartPoint - child.getMaxIntrinsicHeight(0) / 2;
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
      RelativeParentData childParentData,
      bool isVertical,
      bool isStartPoint,
      bool isOutSide) {
    double point;
    if (align != null) {
      if (align == PARENT) {
        point = 0;
        if (isStartPoint) {
          if (isVertical) {
            if (isOutSide) {
              point -= child.getMaxIntrinsicHeight(0) / 2;
            } else {
              point += child.getMaxIntrinsicHeight(0) / 2;
            }
          } else {
            if (isOutSide) {
              point -= child.getMaxIntrinsicWidth(0) / 2;
            } else {
              point += child.getMaxIntrinsicWidth(0) / 2;
            }
          }
        } else {
          if (isVertical) {
            point = size.height;
            if (isOutSide) {
              point += child.getMaxIntrinsicHeight(0) / 2;
            } else {
              point -= child.getMaxIntrinsicHeight(0) / 2;
            }
          } else {
            point = size.width;
            if (isOutSide) {
              point += child.getMaxIntrinsicWidth(0) / 2;
            } else {
              point -= child.getMaxIntrinsicWidth(0) / 2;
            }
          }
        }
      } else {
        var targetRenderBox = getRenderBoxByTag(align);
        assert(targetRenderBox != null, 'Tag is wrong!');
        var targetParentData = targetRenderBox.parentData as RelativeParentData;
        if (isVertical) {
          point = targetParentData.offset.dy;
          if (isStartPoint) {
            if (isOutSide) {
              point -= child.getMaxIntrinsicHeight(0) / 2;
            } else {
              point += child.getMaxIntrinsicHeight(0) / 2;
            }
          } else {
            point += targetRenderBox.getMaxIntrinsicHeight(0);
            if (isOutSide) {
              point += child.getMaxIntrinsicHeight(0) / 2;
            } else {
              point -= child.getMaxIntrinsicHeight(0) / 2;
            }
          }
        } else {
          point = targetParentData.offset.dx;
          if (isStartPoint) {
            if (isOutSide) {
              point -= child.getMaxIntrinsicWidth(0) / 2;
            } else {
              point += child.getMaxIntrinsicWidth(0) / 2;
            }
          } else {
            point += targetRenderBox.getMaxIntrinsicWidth(0);
            if (isOutSide) {
              point += child.getMaxIntrinsicWidth(0) / 2;
            } else {
              point -= child.getMaxIntrinsicWidth(0) / 2;
            }
          }
        }
      }
    }
    return point;
  }

  bool layoutForRelativeChild(RenderBox child) {
    final RelativeParentData childParentData = child.parentData;
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
          measureDx(child, childParentData) +
              getOffsetX(childParentData.margin),
          measureDy(child, childParentData) +
              getOffsetY(childParentData.margin));
      return true;
    }
    return false;
  }

  double getOffsetX(EdgeInsets margin) {
    var x = 0.0;
    if (margin != null) {
      x = margin.left - margin.right;
    }
    return x;
  }

  double getOffsetY(EdgeInsets margin) {
    var y = 0.0;
    if (margin != null) {
      y = margin.top - margin.bottom;
    }
    return y;
  }

  RenderBox getRenderBoxByTag(String tag) {
    for (RenderBox child in readiedRenderBoxes) {
      final RelativeParentData childParentData = child.parentData;
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

class RelativeWidget extends StatelessWidget {
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
  final EdgeInsets padding;

  const RelativeWidget(this.tag,
      {this.toTop,
      this.toBottom,
      this.toLeft,
      this.toRight,
      this.beTop,
      this.beBottom,
      this.beLeft,
      this.beRight,
      this.padding,
      this.child,
      this.key});

  @override
  Widget build(BuildContext context) {
    return Relative(tag,
        toTop: toTop,
        toBottom: toBottom,
        toLeft: toLeft,
        toRight: toRight,
        beTop: beTop,
        beBottom: beBottom,
        beLeft: beLeft,
        beRight: beRight,
        child: child,
        key: key);
  }
}

class Relative extends ParentDataWidget<RelativeParentData> {
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
    final RelativeParentData parentData =
        renderObject.parentData as RelativeParentData;
    var needLayout = false;
    if( parentData.tag != tag){
      parentData.tag = tag;
      needLayout = true;
    }
    if( parentData.margin != margin){
      parentData.margin = margin;
      needLayout = true;
    }
    if( parentData.toTop != toTop){
      parentData.toTop = toTop;
      needLayout = true;
    }
    if( parentData.toBottom != toBottom){
      parentData.toBottom = toBottom;
      needLayout = true;
    }
    if( parentData.toLeft != toLeft){
      parentData.toLeft = toLeft;
      needLayout = true;
    }
    if( parentData.toRight != toRight){
      parentData.toRight = toRight;
      needLayout = true;
    }
    if( parentData.beTop != beTop){
      parentData.beTop = beTop;
      needLayout = true;
    }
    if( parentData.beBottom != beBottom){
      parentData.beBottom = beBottom;
      needLayout = true;
    }
    if( parentData.beLeft != beLeft){
      parentData.beLeft = beLeft;
      needLayout = true;
    }
    if( parentData.beRight != beRight){
      parentData.beRight = beRight;
      needLayout = true;
    }

    if(needLayout){
      final AbstractNode targetParent = renderObject.parent;
      if (targetParent is RenderObject)
        targetParent.markNeedsLayout();
    }
  }


  @override
  Type get debugTypicalAncestorWidgetClass => RelativeLayout;
}

class RelativeParentData extends ContainerBoxParentData<RenderBox> {
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
