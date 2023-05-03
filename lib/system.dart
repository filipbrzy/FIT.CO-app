import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_co/client_day_screen.dart';
import 'package:fit_co/client_week_screen.dart';
import 'package:fit_co/create_account_screen.dart';
import 'package:fit_co/search_trainer_screen.dart';
import 'package:fit_co/trainer_become_screen.dart';
import 'package:fit_co/trainer_client_screen.dart';
import 'package:fit_co/trainer_day_screen.dart';
import 'package:fit_co/trainer_exercise_screen.dart';
import 'package:fit_co/trainer_plan_screen.dart';
import 'package:fit_co/trainer_request_screen.dart';
import 'package:fit_co/trainer_week_screen.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/first_start_screen.dart';
import 'package:fit_co/client_menu_screen.dart';
import 'package:fit_co/trainer_menu_screen.dart';
import 'package:fit_co/client_plan_screen.dart';
import 'package:fit_co/client_exercise_screen.dart';
import 'package:fit_co/trainer_become_screen.dart';
import 'package:fit_co/trainer_client_screen.dart';
import 'package:fit_co/trainer_request_screen.dart';
import 'package:fit_co/trainer_day_screen.dart';
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
          TrainerBecomeScreen.routeName: (context) => const TrainerBecomeScreen(),
          TrainerMenuScreen.routeName: (context) => TrainerMenuScreen(),
          SearchTrainerScreen.routeName: (context) => const SearchTrainerScreen(),
          ClientPlanScreen.routeName: (context) => const ClientPlanScreen(),
          ClientWeekScreen.routeName: (context) => const ClientWeekScreen(),
          ClientDayScreen.routeName: (context) => const ClientDayScreen(),
          ClientExerciseScreen.routeName: (context) => const ClientExerciseScreen(),
          TrainerRequestScreen.routeName: (context) => const TrainerRequestScreen(),
          TrainerClientScreen.routeName: (context) => const TrainerClientScreen(),
          TrainerPlanScreen.routeName: (context) => const TrainerPlanScreen(),
          TrainerWeekScreen.routeName: (context) => const TrainerWeekScreen(),
          TrainerDayScreen.routeName: (context) => const TrainerDayScreen(),
          TrainerExerciseScreen.routeName: (context) => const TrainerExerciseScreen(),
        }
    );
  }
}