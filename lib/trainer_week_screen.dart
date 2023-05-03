import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/utils.dart';
import 'designClasses/User.dart';
import 'designClasses/Day.dart';
import 'designClasses/Week.dart';

class TrainerWeekScreen extends StatefulWidget {
  const TrainerWeekScreen({Key? key}) : super(key: key);
  static const routeName = '/trainer-week-screen';

  @override
  State<TrainerWeekScreen> createState() => _TrainerWeekScreen();
}

class _TrainerWeekScreen extends State<TrainerWeekScreen> {
  _TrainerWeekScreen();

  final _formKey = GlobalKey<FormState>();
  User user = User.empty();
  Week week = Week.empty();
  List<Day> days = [];

  Future<void> init(String weekId) async {

    user = User.empty();
    await user.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
    week = Week.empty();
    await week.fromFirebase(weekId);
    days = await week.getDays();
    days.sort();
  }


  @override
  Widget build(BuildContext context) {
    final weekId = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder(
      future: init(weekId),
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
                            Text("Week", style: TextStyle(fontSize: 40)),
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
                                      onSaved: (value) async {await week.setName(value!);},
                                      decoration: InputDecoration(
                                        hintText: week.getName,
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
                          days.map((day) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: ElevatedButton(
                                  style: Utils.buttonStyleBoxedSmall,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('/trainer-day-screen', arguments: day.getId);
                                  },
                                  child: Text(day.toString(), style: const TextStyle(color: Colors.white))),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 90),
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