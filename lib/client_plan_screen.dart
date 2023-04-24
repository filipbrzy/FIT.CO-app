import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/utils.dart';
import 'designClasses/Week.dart';

class ClientPlanScreen extends StatefulWidget {
  const ClientPlanScreen({Key? key}) : super(key: key);

  static const routeName = '/client-plan-screen';

  @override
  _ClientPlanScreenState createState() => _ClientPlanScreenState();
}

class _ClientPlanScreenState extends State<ClientPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final String _planName = 'plan name';
  final String _trainer = 'trainer name';
  final List<Week> _weeks = [Week(), Week()];


  @override
  Widget build(BuildContext context) {
    _weeks[0].setName("Week 1");
    _weeks[1].setName("Week 2");
    // FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => print(value.data()!['name']);

    return Scaffold(
      appBar: CustomAppBar(startValue: 'Client', eMail: 'User1@gmail.com'),
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
                    Text("Plan $_planName", style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 10),
                    Text("from $_trainer", style: const TextStyle(fontSize: 20)),
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
                      _weeks.map((week) => ElevatedButton(
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
    );
  }
}