import "package:fit_co/designClasses/PlanItem.dart";
import "package:fit_co/designClasses/Exercise.dart";
import "package:fit_co/designClasses/day_type.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class Day extends PlanItem {
  late DayType type;
  late String weekId;
  List<String> exercises = [];

  Day.empty({this.type = DayType.monday, this.weekId = ""});

  Future<void> toFirebase() async {
    await FirebaseFirestore.instance.collection('Days').add({
      'name': name,
      'weekId': weekId,
      'progress': progress,
      'type': type.index,
    }).then((value) => id = value.id);
  }

  Future<void> fromFirebase(String id) async {
    await FirebaseFirestore.instance.collection('Days').doc(id).get().then((value) => {
      if (!value.exists){
        toFirebase(),
      } else {
        name = value.data()!['name'],
        weekId = value.data()!['weekId'],
        progress = value.data()!['progress'],
        type = DayType.values[value.data()!['type']],
        FirebaseFirestore.instance.collection('exercises').where('dayId', isEqualTo: id).get().then((value) => {
         for (DocumentSnapshot exercise in value.docs){
            exercises.add(exercise.id)
         }
       })
      }
    });
  }

  Future<String> getWeekId() async {
    await downloadFromFirebase();
    return weekId;
  }

  Future<DayType> getType() async{
    await downloadFromFirebase();
    return type;
  }

  Future<List<String>> getExercises() async{
    await downloadFromFirebase();
    return exercises;
  }

  Future<void> addExercise() async {
    Exercise exercise = Exercise.empty(dayId: id);
    await exercise.toFirebase();
    exercises.add(exercise.id);
    await uploadToFirebase();
  }

  Future<void> deleteExercise(String id) async {
    FirebaseFirestore.instance.collection('exercises').doc(id).delete();
    exercises.removeWhere((exercise) => exercise == id);
    await uploadToFirebase();
  }

  @override
  Future<void> downloadFromFirebase() async {
    final value = await FirebaseFirestore.instance.collection('Days').doc(id).get();

    name = value.data()!['name'];
    weekId = value.data()!['weekId'];
    progress = value.data()!['progress'];
    type = DayType.values[value.data()!['type']];
    exercises = [];
    await FirebaseFirestore.instance.collection('exercises').where('dayId', isEqualTo: id).get().then((value) => {
      for (DocumentSnapshot exercise in value.docs){
        exercises.add(exercise.id)
      }
    });
  }

  @override
  Future<void> uploadToFirebase() async {
    await FirebaseFirestore.instance.collection('Days').doc(id).update({
      'name': name,
      'weekId': weekId,
      'progress': progress,
      'type': type.index,
    });

    for (String exerciseId in exercises) {
      Exercise exercise = Exercise.empty();
      await exercise.fromFirebase(exerciseId);
    }
  }

  @override
  Future<void> calculateProgress() async{
    int done = 0;
    for (String exerciseId in exercises) {
      Exercise exercise = Exercise.empty();
      await exercise.fromFirebase(exerciseId);
      if (exercise.getIsDone) {
        done++;
      }
    }
    progress = done / exercises.length;
    await uploadToFirebase();
  }

  @override
  String toString() {
    String day = type.toString();
    return "$day: $name";
  }
}