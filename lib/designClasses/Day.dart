import "package:fit_co/designClasses/PlanItem.dart";
import "package:fit_co/designClasses/Exercise.dart";
import "package:fit_co/designClasses/day_type.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class Day extends PlanItem implements Comparable<Day> {
  late DayType type;
  late String weekId;
  List<String> exercises = [];

  Day.empty({this.type = DayType.monday, this.weekId = ""});

  Future<void> toFirebase() async {
    name = "name";
    final value = await FirebaseFirestore.instance.collection('Days').add({
      'name': name,
      'weekId': weekId,
      'progress': progress,
      'type': type.index,
      'exercises': exercises,
    });
    id = value.id;
  }

  Future<void> fromFirebase(String id) async {
    this.id = id;
    var exercisesIds;
    await FirebaseFirestore.instance.collection('Days').doc(id).get().then((value) => {
      if (!value.exists){
        toFirebase(),
      } else {
        name = value.data()!['name'],
        weekId = value.data()!['weekId'],
        progress = value.data()!['progress'],
        type = DayType.values[value.data()!['type']],
        exercisesIds = value.data()!['exercises'],
        exercises = [],
        for (String exerciseId in exercisesIds){
          exercises.add(exerciseId),
        }
      }
    });
  }

  String getWeekId() {
    return weekId;
  }

  DayType getType() {
    return type;
  }

  Future<List<Exercise>> getExercises() async{
    await downloadFromFirebase();
    List<Exercise> exercisesInstances = [];
    for (String exerciseId in exercises){
      Exercise exercise = Exercise.empty();
      await exercise.fromFirebase(exerciseId);
      exercisesInstances.add(exercise);
    }
    return exercisesInstances;
  }

  Future<void> addExercise() async {
    Exercise exercise = Exercise.empty(dayId: id);
    await exercise.toFirebase();
    exercises.add(exercise.id);
    await uploadToFirebase();
  }

  Future<void> delete() async {
    for (String exerciseId in exercises) {
      Exercise exercise = Exercise.empty();
      await exercise.fromFirebase(exerciseId);
      await exercise.delete();
    }
    await FirebaseFirestore.instance.collection('Days').doc(id).delete();
  }

  Future<void> deleteExercise(Exercise exercise) async {
    FirebaseFirestore.instance.collection('exercises').doc(exercise.getId).delete();
    exercises.remove(exercise.getId);
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
    final value2 = await FirebaseFirestore.instance.collection('exercises').where('dayId', isEqualTo: id).get();
    for (DocumentSnapshot exercise in value2.docs){
      exercises.add(exercise.id);
    }
  }

  @override
  Future<void> uploadToFirebase() async {
    await FirebaseFirestore.instance.collection('Days').doc(id).update({
      'name': name,
      'weekId': weekId,
      'progress': progress,
      'type': type.index,
    });
  }

  @override
  Future<void> calculateProgress() async{
    int done = 0;
    for (String exerciseId in exercises) {
      Exercise exercise = Exercise.empty();
      await exercise.fromFirebase(exerciseId);
      if (await exercise.getIsDone()) {
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

  @override int compareTo(Day other) {
    return type.index - other.type.index;
  }
}