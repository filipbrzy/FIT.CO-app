import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_co/designClasses/PlanItem.dart';
import 'package:fit_co/designClasses/Week.dart';


class Plan extends PlanItem{
  late String trainerId;
  late String traineeId;
  List<String> weeks = [];

  Plan.empty({this.traineeId = '', this.trainerId = ''});

  Future<void> toFirebase() async{
    if (traineeId == '' || trainerId == ''){
      throw Exception('traineeId or trainerId is empty in toFirebase method of Plan.dart');
    }
    name = "Plan1";
    final value = await FirebaseFirestore.instance.collection('Plans').add({
      'name': name,
      'trainer': trainerId,
      'trainee': traineeId,
      'progress': progress,
    });
    id = value.id;
  }

  Future<void> fromFirebase(String id) async{
    this.id = id;
    print("id is $id");
    await FirebaseFirestore.instance.collection('Plans').doc(id).get().then((value) => {
      name = value.data()!['name'],
      trainerId = value.data()!['trainer'],
      traineeId = value.data()!['trainee'],
      progress = value.data()!['progress'],
      FirebaseFirestore.instance.collection('week').where('planId', isEqualTo: id).get().then((value) => {
        for (DocumentSnapshot week in value.docs){
          weeks.add(week.id)
        }
      })
    });
  }

  Future<String> getTrainerId() async {
    await downloadFromFirebase();
    return trainerId;
  }

  Future<String> getTraineeId() async{
    await downloadFromFirebase();
    return traineeId;
  }

  Future<List<Week>> getWeeks() async{
    await downloadFromFirebase();
    List<Week> weeks = [];
    for (String weekId in this.weeks){
      Week week = Week.empty();
      await week.fromFirebase(weekId);
      weeks.add(week);
    }
    return weeks;
  }


  Future<void> addWeek() async {
    Week week = Week.empty(planId: id);
    await week.toFirebase();
    weeks.add(week.id);
    await uploadToFirebase();
  }

  Future<void> delete() async{
    for (Week week in await getWeeks()){
      await week.delete();
    }
    await FirebaseFirestore.instance.collection('Plans').doc(id).delete();
  }
  Future<void> deleteWeek(Week week) async{
    weeks.remove(week.getId);
    await week.delete();
    await uploadToFirebase();
  }

  @override
  Future<void> downloadFromFirebase() async {
    final value = await FirebaseFirestore.instance.collection('Plans').doc(
        id
    ).get();
    name = value.data()!['name'];
    trainerId = value.data()!['trainer'];
    traineeId = value.data()!['trainee'];
    progress = value.data()!['progress'];
    weeks = [];
    for (var week in value.data()!['weeks']){
      weeks.add(week as String);
    }
    //await FirebaseFirestore.instance.collection('week').where('planId', isEqualTo: id).get().then((value) => {
    //  for (DocumentSnapshot week in value.docs){
    //    weeks.add(week.id)
    //  }
    ;
  }

  @override
  Future<void> uploadToFirebase() async {
    await FirebaseFirestore.instance.collection('Plans').doc(
        id
    ).update({
      'name': name,
      'trainer': trainerId,
      'trainee': traineeId,
      'progress': progress,
      'weeks': weeks,
    });
  }

  @override
  Future<void> calculateProgress() async {
    int done = 0;
    for (String weekId in weeks) {
      Week week = Week.empty();
      await week.fromFirebase(weekId);
      if (await week.getIsDone()) {
        done++;
      }
    }
    progress = done / weeks.length;
    await uploadToFirebase();
  }
}