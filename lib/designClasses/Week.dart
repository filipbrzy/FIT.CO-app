import 'package:fit_co/designClasses/PlanItem.dart';
import 'package:fit_co/designClasses/Day.dart';
import 'package:fit_co/designClasses/day_type.dart';


class Week extends PlanItem {
  List<Day> days = List.of({
    Day(type: DayType.monday),
    Day(type: DayType.tuesday),
    Day(type: DayType.wednesday),
    Day(type: DayType.thursday),
    Day(type: DayType.friday),
    Day(type: DayType.saturday),
    Day(type: DayType.sunday)
  });

  Week();

  @override
  void calculateProgress(){
    int done = 0;
    for(Day day in days){
      if(day.isDone()){
        done++;
      }
    }
    progress = done / days.length;
  }
}