import 'package:flutter/material.dart';
import 'package:fit_co/designClasses/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManager with ChangeNotifier {
  static UserManager? _instance;

  static UserManager get instance {
    _instance ??= UserManager._();
    return _instance!;
  }
  UserManager._(){}

  Future<String?> findUser(String email) async{
    String? userId;
    try {
      await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get().then((value) => {
        userId = value.docs.first.id,
      });
      return userId;
    } catch (e) {
      return userId;
    }
  }

  Future<List<String>> getTrainers() async{
    List<String> trainers = [];
    await FirebaseFirestore.instance.collection('users').where('isTrainer', isEqualTo: true).get().then((value) => {
      for (DocumentSnapshot user in value.docs){
        trainers.add(user.id)
      }
    });
    return trainers;
  }

  Future<List<String>> getTrainersEmails(String email) async{
    List<String> trainersEmails = [];
    User userInstance = User.empty();
    await FirebaseFirestore.instance.collection('users').where('isTrainer', isEqualTo: true).get().then((value) => {
      for (DocumentSnapshot user in value.docs){
        userInstance = User.empty(),
        userInstance.fromFirebase(user.id),
        trainersEmails.add(
          userInstance.getEmail(),
        )
      }
    });
    return trainersEmails;
  }


  Future<String?> findTrainer(String email) async {
    String? trainer;
    try {
      await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).where('isTrainer', isEqualTo: true).get().then((value) => {
        trainer = value.docs.first.id,
      });
      return trainer;
    } catch (e) {
      return trainer;
    }
  }
}