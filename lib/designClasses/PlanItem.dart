
import 'package:cloud_firestore/cloud_firestore.dart';

class PlanItem{
  late String id;
  String name = "";
  double progress = 0.0;

  PlanItem();

  PlanItem.fromFirebase({required this.id});

  get getName{
    downloadFromFirebase();
    return name;
  }

  get getProgress{
    downloadFromFirebase();
    return progress;
  }

  get getId{
    downloadFromFirebase();
    return id;
  }

  get getIsDone{
    downloadFromFirebase();
    calculateProgress();
    return progress > 0.99;
  }

  set setProgress(double progress){
    this.progress = progress;
    uploadToFirebase();
  }
  set setName(String name){
    this.name = name;
    uploadToFirebase();
  }

  void uploadToFirebase(){}
  void downloadFromFirebase(){}
  void calculateProgress(){}
}