import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/utils.dart';
import 'designClasses/Week.dart';
import 'designClasses/Plan.dart';
import 'designClasses/User.dart';

class ClientPlanScreen extends StatefulWidget {
  const ClientPlanScreen({Key? key}) : super(key: key);
  static const routeName = '/client-plan-screen';

  @override
  _ClientPlanScreenState createState() => _ClientPlanScreenState();
}

class _ClientPlanScreenState extends State<ClientPlanScreen> {
  _ClientPlanScreenState();
  final _formKey = GlobalKey<FormState>();
  String planName = 'plan name';
  String trainerUsername = 'trainer name';
  User user = User.empty();
  User trainer = User.empty();
  Plan plan = Plan.empty();
  List<Week> weeks = [];

  Future<void> init(String planId) async {
    await plan.fromFirebase(planId);
    await trainer.fromFirebase(await plan.getTrainerId());
    await user.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
    List<Week> weeks = await plan.getWeeks();
    planName = plan.getName;
    trainerUsername = trainer.getEmail;
  }


  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => print(value.data()!['name']);
    final planId = ModalRoute.of(context)!.settings.arguments as String;

    return FutureBuilder(
      future: init(planId),
      builder:(ctx, _) =>  Scaffold(
        appBar: CustomAppBar(startValue: 'Client', eMail: user.getEmail),
        body: Container(
          decoration: Utils.gradient,
          child: Container(
            margin: const EdgeInsets.all(40),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Plan $planName", style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 10),
                      Text("from $trainerUsername", style: const TextStyle(fontSize: 20)),
                    ],
                  )
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: Utils.boxDecoration,
                  child: SingleChildScrollView(
                    child: Column(
                      children:
                        weeks.map((week) => ElevatedButton(
                            style: Utils.buttonStyle1,
                            onPressed: () {},
                            child: Text("$week.name")),
                        ).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}