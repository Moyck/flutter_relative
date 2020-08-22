import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:interactive/domain/base_temp.dart';

class ContainerTemp extends BaseTemp {
  double width;
  double height;
  int color;

  ContainerTemp({this.width,this.height,this.color});

  @override
  Widget buildWidget() {
    return Container(color: Color(color), height: height, width: width);
  }
}
