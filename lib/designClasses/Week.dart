import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_co/designClasses/PlanItem.dart';
import 'package:fit_co/designClasses/Day.dart';
import 'package:fit_co/designClasses/day_type.dart';


class Week extends PlanItem {
  late String planId;

  late List<String> days = [];

  Week.empty({this.planId = ''});

  Future<void> toFirebase()async{
    if (planId == ''){
      throw Exception("planId is empty");
    }
    name = "Week1";
    final value = await FirebaseFirestore.instance.collection('weeks').add({
      'name': name,
      'planId': planId,
      'progress': progress,
    });
    id = value.id;
    if (id == "") throw Exception("id is empty");
    List<Day> daysInstances = List.of({
      Day.empty(weekId: id, type: DayType.monday),
      Day.empty(weekId: id, type: DayType.tuesday),
      Day.empty(weekId: id, type: DayType.wednesday),
      Day.empty(weekId: id, type: DayType.thursday),
      Day.empty(weekId: id, type: DayType.friday),
      Day.empty(weekId: id, type: DayType.saturday),
      Day.empty(weekId: id, type: DayType.sunday)
    }).toList();
    for (Day day in daysInstances){
      await day.toFirebase();
      days.add(day.id);
    }
    await uploadToFirebase();
  }

  Future<void> fromFirebase(String id) async{
    this.id = id;
    var daysIds;
    await FirebaseFirestore.instance.collection('weeks').doc(id).get().then((value) => {
      if (!value.exists){
        throw Exception('Week does not exist in fromFirebase method of Week.dart'),
      },
      name = value.data()!['name'],
      planId = value.data()!['planId'],
      progress = value.data()!['progress'],
      days = [],
      daysIds = value.data()!['days'],
      for (String dayId in daysIds){
        days.add(dayId),
      }
    });
  }

  String getPlanId() {
    return planId;
  }

  Future<List<Day>> getDays() async{
    await downloadFromFirebase();
    final List<Day> daysInstances = [];
    for (String dayId in days){
      Day day = Day.empty();
      await day.fromFirebase(dayId);
      daysInstances.add(day);
    }
    return daysInstances;
  }

  Future<void> delete() async{
    for (String dayId in days){
      Day day = Day.empty();
      await day.fromFirebase(dayId);
      await day.delete();
    }
    await FirebaseFirestore.instance.collection('weeks').doc(id).delete();
  }

  @override
  Future<void> uploadToFirebase() async {
    await FirebaseFirestore.instance.collection('weeks').doc(id).update({
      'name': name,
      'planId': planId,
      'progress': progress,
      'days': days,
    });
  }

  @override
  Future<void> downloadFromFirebase() async {

    final value = await FirebaseFirestore.instance.collection('weeks').doc(id).get();
    name = value.data()!['name'];
    planId = value.data()!['planId'];
    progress = value.data()!['progress'];
    days = [];
    for (String dayId in value.data()!['days']){
      days.add(dayId);
    }
  }

  @override
  Future<void> calculateProgress() async{
    int done = 0;
    for (String dayId in days){
      Day day = Day.empty();
      await day.fromFirebase(dayId);
      if (await day.getIsDone()){
        done++;
      }
    }
    progress = done / days.length;
    await uploadToFirebase();
  }
}