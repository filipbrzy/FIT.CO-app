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

class ClientDayScreen extends StatefulWidget {
  const ClientDayScreen({Key? key}) : super(key: key);
  static const routeName = '/client-day-screen';

  @override
  State<ClientDayScreen> createState() => _ClientDayScreen();
}

class _ClientDayScreen extends State<ClientDayScreen> {
  _ClientDayScreen();
  String? planName;
  String? weekName;
  String? dayName;
  String? trainerUsername;
  User? user;
  User? trainer;
  Plan? plan;
  Week? week;
  Day? day;
  List<Exercise>? exercises;

  Future<void> init(String dayId) async {
    day = Day.empty();
    user = User.empty();
    plan = Plan.empty();
    trainer = User.empty();
    week = Week.empty();
    await day!.fromFirebase(dayId);
    await week!.fromFirebase(day!.getWeekId());
    await plan!.fromFirebase(week!.getPlanId());
    await trainer!.fromFirebase(await plan!.getTrainerId());
    await user!.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
    exercises = await day!.getExercises();
    planName = plan!.getName;
    trainerUsername = trainer!.getEmail;
    weekName = week!.getName;
  }


  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => print(value.data()!['name']);
    final dayId = ModalRoute.of(context)!.settings.arguments as String;

    return FutureBuilder(
      future: init(dayId),
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
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.27,
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
                        ],
                      )
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: Utils.boxDecoration,
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                        exercises!.map((exercise) => ElevatedButton(
                          style: Utils.buttonStyle1,
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/client-exercise-screen',
                              arguments: exercise.getId,
                            );
                          },
                          child: Text(exercise.getName),
                        )
                        ).toList(),
                      ),
                    ),
                  ),
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