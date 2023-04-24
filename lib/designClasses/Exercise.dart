import 'package:fit_co/designClasses/PlanItem.dart';

class Exercise extends PlanItem{
  int setCount = 0;
  int repCount = 0;
  String Description = "";
  Exercise(){
    progress = 0;
  }

  set setProgress(double progress) => this.progress = progress;
  set setSetCount(int setCount) => this.setCount = setCount;
  set setRepCount(int repCount) => this.repCount = repCount;
}