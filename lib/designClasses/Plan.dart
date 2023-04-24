import 'package:fit_co/designClasses/PlanItem.dart';
import 'package:fit_co/designClasses/Week.dart';
import 'package:fit_co/designClasses/User.dart';


class Plan extends PlanItem{
  User trainer;
  User trainee;
  List<Week> weeks = [];

  Plan({required this.trainer, required this.trainee});

  void addWeek(){
    weeks.add(Week());
  }

  void deleteWeek(int id){
    weeks.removeWhere((week) => week.id == id);
  }
}