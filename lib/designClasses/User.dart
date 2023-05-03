import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_co/designClasses/Plan.dart';
import 'package:fit_co/designClasses/RequestManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide User;

class User{
  String id;
  String email;
  bool isTrainer = false;
  // Map<UserId, PlanId>
  Map<String, String> _traineesPlan = {};

  User.empty({this.id = '', this.email = '', this.isTrainer = false});

  Future<void> toFirebase({required String password}) async {
    if(email == '') throw Exception('User id or email is empty in toFirebase method of User.dart');

    final user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.user!.uid)
        .set({'email': email});

    id = user.user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(id).set({
      'email': email,
      'isTrainer': isTrainer,
      'traineesPlan': _traineesPlan,
    });
  }

  Future<void> fromFirebase(String id) async {
    final value = await FirebaseFirestore.instance.collection('users').doc(
        id
    ).get();
    this.id = id;
    email = value.data()!['email'] as String;
    isTrainer = value.data()!['isTrainer'];
    for(String traineeId in value.data()!['traineesPlan'].keys){
      _traineesPlan[traineeId] = value.data()!['traineesPlan'][traineeId] as String;
    }
  }

  Future<void> setEmail(String email) async{
    this.email = email;
    await uploadToFirebase();
  }
  Future<void> setPassword(String password) async {
    //this._password = password;
    //TODO: update password in firebase
  }

  Future<void> setIsTrainer(bool isTrainer) async {
    this.isTrainer = isTrainer;
    await uploadToFirebase();
  }

  get getEmail{
    return email;
  }


  get getIsTrainer{
    return isTrainer;
  }

  Future<Map<String, String>> getTraineesPlan() async{
    //await downloadFromFirebase();
    return _traineesPlan;
  }

  //Trainer functions
  Future<void> _removePlan(String planId) async{
    if(!isTrainer) throw Exception('Only trainers can remove plans');
    Plan plan = Plan.empty();
    await plan.fromFirebase(planId);
    await FirebaseFirestore.instance.collection('Plans').doc(planId).delete();
    _traineesPlan.remove(plan.getTraineeId());
    await uploadToFirebase();
  }


  Future<void> createPlan(String traineeId) async{
    if (!isTrainer) throw Exception('Only trainers can accept requests');
    Plan plan = Plan.empty(traineeId: traineeId, trainerId: id);
    await plan.toFirebase();
    _traineesPlan[traineeId] = plan.getId;
    uploadToFirebase();
  }


  Future<void> removeTrainee(String traineeId) async {
    if (!isTrainer) throw Exception('Only trainers can remove trainees');
    _removePlan(_traineesPlan[traineeId]!);
    await uploadToFirebase();
  }

  //Firebase functions
  Future<void> uploadToFirebase() async {
    await FirebaseFirestore.instance.collection('users').doc(
        id
    ).update({
      'email': email,
      'isTrainer': isTrainer,
      'traineesPlan': _traineesPlan
    });
  }

  Future<void> downloadFromFirebase() async {
    var traineesPlan = {};
    await FirebaseFirestore.instance.collection('users').doc(
        id
    ).get().then((value) => {
      email = value.data()!['email'],
      isTrainer = value.data()!['isTrainer'],
      _traineesPlan = {},
      traineesPlan = value.data()!['traineesPlan'],
      for (String traineeId in traineesPlan.keys) {
        _traineesPlan[traineeId] = traineesPlan[traineeId] as String,
      }
    });
  }
}
