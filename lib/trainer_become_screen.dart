import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/custom_app_bar.dart';
import 'package:fit_co/trainer_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/utils.dart';
import 'designClasses/User.dart';

class TrainerBecomeScreen extends StatefulWidget {
  const TrainerBecomeScreen({Key? key}) : super(key: key);
  static const routeName = '/trainer-become-screen';

  @override
  State<TrainerBecomeScreen> createState() => _TrainerBecomeScreen();
}

class _TrainerBecomeScreen extends State<TrainerBecomeScreen> {
  _TrainerBecomeScreen();

  User? user;

  Future<void> init() async {
    user = User.empty();
    await user!.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: init(),
      builder: (ctx, _) {
        if (_.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: CustomAppBar(startValue: 'Trainer', eMail: user!.getEmail),
          body: Container(
            decoration: Utils.gradient,
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(35),
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Do you want to",
                                  style: TextStyle(fontSize: 26)),
                              const SizedBox(height: 10),
                              const Text("become a trainer?",
                                  style: TextStyle(fontSize: 40)),
                              const SizedBox(height: 50),
                              const Text("""
Other people will see you in the 
trainer search and can send you 
training requests. You will be 
able to create training plans 
for your Clients.""",
                                  style: TextStyle(fontSize: 20)),
                              const SizedBox(height: 50),
                              ElevatedButton(
                                onPressed: () {
                                  user!.setIsTrainer(true);
                                  Navigator.of(context).pop();
                                },
                                style: Utils.buttonStyle1,
                                child: const Text('Yes'),
                              ),
                            ],
                          )
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
