import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/utils.dart';
import 'designClasses/User.dart';
import 'designClasses/Plan.dart';
import 'designClasses/Week.dart';

class TrainerPlanScreen extends StatefulWidget {
  const TrainerPlanScreen({Key? key}) : super(key: key);
  static const routeName = '/trainer-plan-screen';

  @override
  State<TrainerPlanScreen> createState() => _TrainerPlanScreen();
}

class _TrainerPlanScreen extends State<TrainerPlanScreen> {
  _TrainerPlanScreen();

  final _formKey = GlobalKey<FormState>();
  User user = User.empty();
  Plan plan = Plan.empty();
  List<Week> weeks = [];

  Future<void> init(String planId) async {
    print(planId);
    print(planId);
    print(planId);
    print("WEEKS DLZKA:");
    try {
      user = User.empty();
      await user.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
      plan = Plan.empty();
      await plan.fromFirebase(planId);
      weeks = await plan.getWeeks();
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    final planId = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder(
      future: init(planId),
      builder:(ctx, _) =>  Scaffold(
        appBar: CustomAppBar(startValue: 'Trainer', eMail: user.getEmail),
        body: Center(
          child: Container(
            decoration: Utils.gradient,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text("Plan", style: TextStyle(fontSize: 40)),
                            Form(
                              key: _formKey,
                              child: Row(
                                children:[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a plan name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) async {await plan.setName(value!);},
                                      decoration: InputDecoration(
                                        hintText: plan.getName,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: Utils.buttonStyleSmall,
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          setState(() {});
                                        }
                                      },
                                      child: Text('Update', style: const TextStyle(color: Colors.white))),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(top: 20),
                      decoration: Utils.boxDecoration,
                      child: SingleChildScrollView(
                        child: Column(
                          children:
                          weeks.map((week) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child:
                              Row(
                                children: [
                                  ElevatedButton(
                                      style: Utils.buttonStyleBoxedSmall,
                                      onPressed: () {
                                        Navigator.of(context).pushNamed('/trainer-week-screen', arguments: week.getId);
                                      },
                                      child: Text(week.getName, style: const TextStyle(color: Colors.white))),
                                  SizedBox(width: 10),
                                  Column(
                                    children: [
                                      IconButton(
                                          onPressed: () async{
                                            await plan.deleteWeek(week);
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.delete, color: Colors.black, size: 50)
                                      ),
                                      SizedBox.fromSize(size: const Size(10, 20)),
                                    ],
                                  )],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.4,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(const Size(100, 50)),
                                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
                                ),
                                onPressed: () async {
                                  await plan.addWeek();
                                  setState(() {});
                                },
                                child: Text('Add', style: const TextStyle(color: Colors.white))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}