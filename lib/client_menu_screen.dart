import 'package:fit_co/search_trainer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_co/utils.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/custom_app_bar.dart';
import 'client_plan_screen.dart';
import 'designClasses/User.dart';
import 'designClasses/Plan.dart';
import 'screen_arguments.dart';

class ClientMenuScreen extends StatelessWidget {
  ClientMenuScreen({Key? key}) : super(key: key);

  String? planId;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  User user = User.empty();

  static const routeName = '/client-menu-screen';

  Future<void> init() async{
    user = User.empty();
    await user.fromFirebase(userId);

    final value = await FirebaseFirestore.instance.collection('Plans').where('trainee', isEqualTo: userId).get();
    planId = value.docs.first.id;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: init(),
      builder:(ctx, _) => Scaffold(
        appBar: CustomAppBar(startValue: 'Client', eMail: this.user.getEmail),
        body: Container(
          decoration: Utils.gradient,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Menu',
                            style: TextStyle(fontSize: 50),
                          ),
                          SizedBox(
                            height: 150,
                          ),
                          ElevatedButton(
                            style: Utils.buttonStyle1,
                            onPressed: () {
                              if (planId == null){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('You have no plan yet! Search for a trainer to get a plan.'),
                                  ),
                                );
                              }
                              else{
                                Navigator.of(context).pushNamed(ClientPlanScreen.routeName, arguments: planId);
                              }
                            },

                            child: const Text('Plan'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: Utils.buttonStyle1,
                            onPressed: () {
                              Navigator.of(context).pushNamed(SearchTrainerScreen.routeName);
                            },
                            child: const Text('Search Trainer'),
                          ),
                        ],
                      ),
                    ),
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
