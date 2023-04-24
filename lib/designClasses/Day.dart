import "package:fit_co/designClasses/PlanItem.dart";
import "package:fit_co/designClasses/Exercise.dart";
import "package:fit_co/designClasses/day_type.dart";

class Day extends PlanItem {
  List<Exercise> exercises = [];
  DayType type;

  Day({required this.type});

  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }

  void deleteExercise(int id) {
    exercises.removeWhere((exercise) => exercise.id == id);
  }

  Exercise? getExercise(int id) {
    return exercises.firstWhere((exercise) => exercise.id == id);
  }

  @override
  void calculateProgress() {
    int done = 0;
    for (Exercise exercise in exercises) {
      if (exercise.isDone()) {
        done++;
      }
    }
    progress = done / exercises.length;
  }

  @override
  String toString() {
    String day = type.toString();
    return "$day: $name";
  }
}