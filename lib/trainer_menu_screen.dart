import 'package:fit_co/utils.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/custom_app_bar.dart';
import 'package:fit_co/designClasses/User.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/trainer_request_screen.dart';

class TrainerMenuScreen extends StatelessWidget {
  TrainerMenuScreen({Key? key}) : super(key: key);

  static const routeName = '/trainer-menu-screen';

  User user = User.empty();

  Future<void> init() async{
    await user.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (ctx, _) => Scaffold(
        appBar: CustomAppBar(startValue: 'Trainer', eMail: user.getEmail),
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
                          const SizedBox(height: 20),
                          const Text(
                            'Menu',
                            style: TextStyle(fontSize: 50),
                          ),
                          const SizedBox(
                            height: 150,
                          ),
                          ElevatedButton(
                            style: Utils.buttonStyle1,
                            onPressed: () {
                              //Navigator.of(context).pushNamed(TrainerClientsScreen.routeName);
                            },
                            child: const Text('Clients'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: Utils.buttonStyle1,
                            onPressed: () {
                              Navigator.of(context).pushNamed(TrainerRequestScreen.routeName);
                            },
                            child: const Text('Requests'),
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
