import 'package:fit_co/designClasses/PlanItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Exercise extends PlanItem{
  int setCount = 0;
  int repCount = 0;
  String description = "";
  late String dayId;

  Exercise.empty({this.dayId = ""});

  Future<void> toFirebase() async{
    name = "Exercise1";
    final value = await FirebaseFirestore.instance.collection('exercises').add({
      'name': name,
      'dayId': dayId,
      'progress': progress,
      'setCount': setCount,
      'repCount': repCount,
      'description': description,
    });
    id = value.id;
  }

  Future<void> fromFirebase(String id) async{
    this.id = id;
    final value = await FirebaseFirestore.instance.collection('exercises').doc(id).get();
    if(!value.exists){
      throw Exception("Exercise with id $id does not exist");
    }
    name = value.data()!['name'];
    dayId = value.data()!['dayId'];
    progress = value.data()!['progress'];
    setCount = value.data()!['setCount'];
    repCount = value.data()!['repCount'];
    description = value.data()!['description'];
  }

  String getDayId() {
    return dayId;
  }

  int getSetCount() {
    return setCount;
  }

  int getRepCount() {
    return repCount;
  }

  String getDescription() {
    return description;
  }

  Future<void> setSetCount(int setCount) async{
    this.setCount = setCount;
    await uploadToFirebase();
  }

  Future<void> setRepCount(int repCount) async{
    this.repCount = repCount;
    await uploadToFirebase();
  }

  Future<void> setDescription(String description) async{
    this.description = description;
    await uploadToFirebase();
  }

  Future<void> delete() async{
    await FirebaseFirestore.instance.collection('exercises').doc(id).delete();
  }

  @override
  Future<void> uploadToFirebase() async {
    await FirebaseFirestore.instance.collection('exercises').doc(id).update({
      'name': name,
      'dayId': dayId,
      'progress': progress,
      'setCount': setCount,
      'repCount': repCount,
      'description': description,
    });
  }

  @override
  Future<void> downloadFromFirebase() async {
    await FirebaseFirestore.instance.collection('exercises').doc(id).get().then((value) => {
      name = value.data()!['name'],
      dayId = value.data()!['dayId'],
      progress = value.data()!['progress'],
      setCount = value.data()!['setCount'],
      repCount = value.data()!['repCount'],
      description = value.data()!['description'],
    });
  }

  @override
  Future<void> calculateProgress() async {
    await uploadToFirebase();
  }
}