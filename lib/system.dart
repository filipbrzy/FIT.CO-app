import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_co/create_account_screen.dart';
import 'package:fit_co/search_trainer_screen.dart';
import 'package:fit_co/trainer_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/first_start_screen.dart';
import 'package:fit_co/client_menu_screen.dart';
import 'package:fit_co/trainer_menu_screen.dart';
import 'package:fit_co/client_plan_screen.dart';
import 'package:fit_co/trainer_request_screen.dart';
import 'screen_arguments.dart';

class System extends StatefulWidget {
  const System({Key? key}) : super(key: key);

  @override
  _SystemState createState() => _SystemState();
}

class _SystemState extends State<System> {
  var activeScreen = 'first-start-screen';

  void switchScreenToCreateAccount() {
    setState(() {
      activeScreen = 'create-account-screen';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "FIT.CO",
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return snapshot.hasData ? ClientMenuScreen() : const FirstStartScreen();
          },),
        routes: {
          FirstStartScreen.routeName: (context) => const FirstStartScreen(),
          CreateAccountScreen.routeName: (
              context) => const CreateAccountScreen(),
          ClientMenuScreen.routeName: (context) => ClientMenuScreen(),
          TrainerMenuScreen.routeName: (context) => TrainerMenuScreen(),
          SearchTrainerScreen.routeName: (context) => const SearchTrainerScreen(),
          ClientPlanScreen.routeName: (context) => const ClientPlanScreen(),
          TrainerRequestScreen.routeName: (context) => const TrainerRequestScreen(),
        }
    );
  }
}