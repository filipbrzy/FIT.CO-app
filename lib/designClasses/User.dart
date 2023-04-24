import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_co/designClasses/Plan.dart';
import 'package:fit_co/designClasses/Request.dart';
import 'package:fit_co/designClasses/RequestManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide User;

class User{
String _password;
  String email;
  bool isTrainer = false;

  Map<User, Plan> _traineesPlans = {};

  User(this.email, this._password);

  set setEmail(String email) {
    this.email = email;
    FirebaseFirestore.instance.collection('users').doc(
        FirebaseAuth.instance.currentUser!.uid
    ).set({'email': email});
  }
  set setPassword(String password){
    this._password = password;
    //TODO: update password in firebase
  }

  set setIsTrainer(bool isTrainer){
    this.isTrainer = isTrainer;
    FirebaseFirestore.instance.collection('users').doc(
        FirebaseAuth.instance.currentUser!.uid
    ).set({'isTrainer': isTrainer});
  }

  get getEmail{
    FirebaseFirestore.instance.collection('users').doc(
        FirebaseAuth.instance.currentUser!.uid
    ).get().then((value) => email = value.data()!['email']);
    return email;
  }

  get getPassword{
    FirebaseFirestore.instance.collection('users').doc(
        FirebaseAuth.instance.currentUser!.uid
    ).get().then((value) => _password = value.data()!['password']);
    return _password;
  }

  //Accept
  void acceptRequest(User trainee){
    if (!isTrainer) throw Exception('Only trainers can accept requests');
    RequestManager.instance.acceptRequest(trainee, this);
  }
  void createPlan(User trainee){
    if (!isTrainer) throw Exception('Only trainers can accept requests');
    _traineesPlans[trainee] = Plan(trainer: this, trainee: trainee);
  }

  void rejectRequest(User trainee){
    if (!isTrainer) throw Exception('Only trainers can reject requests');
  }

  void removeTrainee(User trainee){
    if (!isTrainer) throw Exception('Only trainers can remove trainees');
    _traineesPlans.remove(trainee);
  }
}
