import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/utils.dart';
import 'designClasses/Week.dart';
import 'designClasses/Plan.dart';
import 'designClasses/User.dart';
import 'designClasses/Day.dart';

class ClientWeekScreen extends StatefulWidget {
  const ClientWeekScreen({Key? key}) : super(key: key);
  static const routeName = '/client-week-screen';

  @override
  State<ClientWeekScreen> createState() => _ClientWeekScreen();
}

class _ClientWeekScreen extends State<ClientWeekScreen> {
  _ClientWeekScreen();
  String? planName;
  String? weekName;
  String? trainerUsername;
  User? user;
  User? trainer;
  Plan? plan;
  Week? week;
  List<Day>? days;

  Future<void> init(String exerciseId) async {
    user = User.empty();
    plan = Plan.empty();
    trainer = User.empty();
    week = Week.empty();
    await week!.fromFirebase(exerciseId);
    await plan!.fromFirebase(week!.getPlanId());
    await trainer!.fromFirebase(await plan!.getTrainerId());
    await user!.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
    days = await week!.getDays();
    planName = plan!.getName;
    trainerUsername = trainer!.getEmail;
    weekName = week!.getName;
  }


  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => print(value.data()!['name']);
    final weekId = ModalRoute.of(context)!.settings.arguments as String;

    return FutureBuilder(
      future: init(weekId),
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
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Plan: $planName", style: const TextStyle(fontSize: 40)),
                          const SizedBox(height: 10),
                          Text("from: $trainerUsername", style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          Text("Week: $weekName", style: const TextStyle(fontSize: 20)),
                        ],
                      )
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: Utils.boxDecoration,
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                        days!.map((day) => ElevatedButton(
                          style: Utils.buttonStyle1,
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/client-day-screen',
                              arguments: day.getId,
                            );
                          },
                          child: Text(day.getName),
                        )
                        ).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
      },
    );
  }
}