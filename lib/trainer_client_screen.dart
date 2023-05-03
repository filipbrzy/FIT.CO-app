import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/utils.dart';
import 'designClasses/User.dart';

class TrainerClientScreen extends StatefulWidget {
  const TrainerClientScreen({Key? key}) : super(key: key);
  static const routeName = '/trainer-client-screen';

  @override
  State<TrainerClientScreen> createState() => _TrainerClientScreen();
}

class _TrainerClientScreen extends State<TrainerClientScreen> {
  _TrainerClientScreen();

  User user = User.empty();
  Map<User, String> traineesPlans = {};

  Future<void> init() async {
    await user.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
    User trainee;
    traineesPlans = {};
    Map<String, String> traineesPlansIds = await user.getTraineesPlan();
    for (String traineeId in traineesPlansIds.keys) {
      trainee = User.empty();
      await trainee.fromFirebase(traineeId);
      traineesPlans[trainee] = traineesPlansIds[traineeId]!;
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder:(ctx, _) =>  Scaffold(
        appBar: CustomAppBar(startValue: 'Trainer', eMail: user.getEmail),
        body: Center(
          child: Container(
            decoration: Utils.gradient,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 60),
                          Text("Clients ${traineesPlans.keys.length}", style: TextStyle(fontSize: 40)),
                        ],
                      )
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: Utils.boxDecoration,
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                        traineesPlans.keys.map((trainee) {
                          //TODO: fill values and make the box
                          return Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child:
                              ElevatedButton(
                                  style: Utils.buttonStyle1,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('/trainer-plan-screen', arguments: traineesPlans[trainee]);
                                  },
                                  child: Text(trainee.getEmail, style: const TextStyle(color: Colors.white))),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}