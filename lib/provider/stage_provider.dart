import 'package:flutter/material.dart';
import 'package:interactive/domain/base_actor.dart';
import 'package:interactive/domain/container_temp.dart';
import 'package:provider/provider.dart';

import '../relative_layout.dart';

const LEFT_POINT = 0;
const TOP_POINT = 1;
const RIGHT_POINT = 2;
const BOTTOM_POINT = 3;

class StageProvider with ChangeNotifier {
  BaseActor currentActor;
  int currentPoint; // l t r b

  List<BaseActor> actors = [
    BaseActor('tag',
        beLeft: PARENT,
        beRight: PARENT,
        beTop: PARENT,
        beBottom: PARENT,
        child: ContainerTemp(height: 100, width: 100, color: 0xffFFD341)),
//    BaseActor('tag',
//        beLeft: PARENT,
//        beRight: PARENT,
//        beTop: PARENT,
//        child: ContainerTemp(height: 100, width: 100, color: 0xff399555))
  ];

  void changeCurrentActor(BaseActor baseActor) {
    currentPoint = null;
    currentActor?.isSelected = false;
    currentActor = baseActor;
    currentActor.isSelected = true;
    notifyListeners();
  }

  void changeCurrentPoint(int point){
    currentPoint = point;
    notifyListeners();
  }

  void refresh(){
    notifyListeners();
  }

}
