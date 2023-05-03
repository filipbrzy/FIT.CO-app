import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/utils.dart';
import 'designClasses/Week.dart';
import 'designClasses/Plan.dart';
import 'designClasses/User.dart';
import 'designClasses/Day.dart';
import 'designClasses/Exercise.dart';

class ClientExerciseScreen extends StatefulWidget {
  const ClientExerciseScreen({Key? key}) : super(key: key);
  static const routeName = '/client-exercise-screen';

  @override
  State<ClientExerciseScreen> createState() => _ClientExerciseScreen();
}

class _ClientExerciseScreen extends State<ClientExerciseScreen> {
  _ClientExerciseScreen();
  String? planName;
  String? weekName;
  String? dayName;
  String? trainerUsername;
  User? user;
  User? trainer;
  Plan? plan;
  Week? week;
  Day? day;
  Exercise? exercise;
  bool exerciseIsDone = false;

  Future<void> init(String exerciseId) async {
    day = Day.empty();
    user = User.empty();
    plan = Plan.empty();
    trainer = User.empty();
    week = Week.empty();
    exercise = Exercise.empty();
    await exercise!.fromFirebase(exerciseId);
    await day!.fromFirebase(exercise!.getDayId());
    await week!.fromFirebase(day!.getWeekId());
    await plan!.fromFirebase(week!.getPlanId());
    await trainer!.fromFirebase(await plan!.getTrainerId());
    await user!.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
    exerciseIsDone = await exercise!.getIsDone();
    planName = plan!.getName;
    trainerUsername = trainer!.getEmail;
    weekName = week!.getName;
  }


  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => print(value.data()!['name']);
    final exerciseId = ModalRoute.of(context)!.settings.arguments as String;

    return FutureBuilder(
      future: init(exerciseId),
      builder:(ctx, _) {
        if (_.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: CustomAppBar(startValue: 'Client', eMail: user!.getEmail),
          body: Container(
            decoration: Utils.gradient,
            child: ListView(
              children: [Container(
                margin: const EdgeInsets.all(40),
                height: MediaQuery.of(context).size.height * 0.95,
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Plan: $planName", style: const TextStyle(fontSize: 40)),
                            const SizedBox(height: 10),
                            Text("from: $trainerUsername", style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 10),
                            Text("Week: $weekName", style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 10),
                            Text("Day: $dayName", style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 10),
                            Text("Exercise: ${exercise!.getName}", style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Text("Done: ", style: const TextStyle(fontSize: 20)),
                                Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all(Colors.black),
                                    value: exerciseIsDone,
                                    onChanged: (value) async{
                                        value! ? await exercise!.setProgress(1.0) : await exercise!.setProgress(0.0);
                                        setState(() {
                                          exerciseIsDone = value;
                                        });
                                   }),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text("Sets: ${exercise!.getSetCount()}", style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 10),
                            Text("Reps: ${exercise!.getRepCount()}", style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 20),
                            const Text("Description: ", style: const TextStyle(fontSize: 20),),
                            SizedBox(height: 10),
                            Text(exercise!.getDescription(), style: const TextStyle(fontSize: 16)),
                          ],
                        )
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              ],
            ),
          ),
        );
      },
    );
  }
}