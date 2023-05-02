import 'package:fit_co/designClasses/PlanItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Exercise extends PlanItem{
  int setCount = 0;
  int repCount = 0;
  String description = "";
  late String dayId;

  Exercise.empty({this.dayId = ""});

  Future<void> toFirebase() async{
    await FirebaseFirestore.instance.collection('exercises').add({
      'name': name,
      'dayId': dayId,
      'progress': progress,
      'setCount': setCount,
      'repCount': repCount,
      'description': description,
    }).then((value) => id = value.id);
  }

  Future<void> fromFirebase(String id) async{
    await FirebaseFirestore.instance.collection('exercises').doc(id).get()
        .then((value) => {
          if(!value.exists){
            toFirebase(),
          } else {
            name = value.data()!['name'],
            dayId = value.data()!['dayId'],
            progress = value.data()!['progress'],
            setCount = value.data()!['setCount'],
            repCount = value.data()!['repCount'],
            description = value.data()!['description'],
          }
        });
  }

  Future<String> getDayId() async{
    await downloadFromFirebase();
    return dayId;
  }

  Future<int> getSetCount() async{
    await downloadFromFirebase();
    return setCount;
  }

  Future<int> getRepCount() async{
    await downloadFromFirebase();
    return repCount;
  }

  Future<String> getDescription() async{
    await downloadFromFirebase();
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
}