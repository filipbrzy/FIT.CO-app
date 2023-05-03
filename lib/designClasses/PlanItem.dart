
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PlanItem{
  late String id = "";
  String name = "";
  double progress = 0.0;

  PlanItem();

  get getName{
    return name;
  }

  get getProgress{
    return progress;
  }

  get getId{
    return id;
  }

  Future<bool> getIsDone() async{
    await calculateProgress();
    return progress > 0.99;
  }

  Future<void> setProgress(double progress) async{
    this.progress = progress;
    await uploadToFirebase();
  }
  Future<void> setName(String name) async{
    this.name = name;
    await uploadToFirebase();
  }

  Future<void> uploadToFirebase();
  Future<void> downloadFromFirebase();
  Future<void> calculateProgress();
}