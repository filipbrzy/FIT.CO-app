import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/utils.dart';
import 'designClasses/User.dart';
import 'designClasses/Day.dart';
import 'designClasses/Exercise.dart';

class TrainerExerciseScreen extends StatefulWidget {
  const TrainerExerciseScreen({Key? key}) : super(key: key);
  static const routeName = '/trainer-exercise-screen';

  @override
  State<TrainerExerciseScreen> createState() => _TrainerExerciseScreen();
}

class _TrainerExerciseScreen extends State<TrainerExerciseScreen> {
  _TrainerExerciseScreen();

  final _formKey = GlobalKey<FormState>();
  User user = User.empty();
  Exercise exercise = Exercise.empty();
  String? exerciseName;
  String? exerciseDescription;
  int? exerciseSets;
  int? exerciseReps;
  bool? exerciseIsDone;

  Future<void> init(String exerciseId) async {
    user = User.empty();
    await user.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
    exercise = Exercise.empty();
    try{
      await exercise.fromFirebase(exerciseId);
    }
    catch(e){
      print(e);
    }
    exerciseName ??= await exercise.getName;
    exerciseDescription ??= exercise.getDescription();
    exerciseSets ??= exercise.getSetCount();
    exerciseReps ??= exercise.getRepCount();
    exerciseIsDone ??= await exercise.getIsDone();
  }

  Future<void> save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await exercise.setName(exerciseName!);
      await exercise.setDescription(exerciseDescription!);
      await exercise.setSetCount(exerciseSets!);
      await exercise.setRepCount(exerciseReps!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final exerciseId = ModalRoute.of(context)!.settings.arguments as String;
    return FutureBuilder(
      future: init(exerciseId),
      builder:(ctx, _) =>  Scaffold(
        appBar: CustomAppBar(startValue: 'Trainer', eMail: user.getEmail),
        body: Center(
          child: Container(
            decoration: Utils.gradient,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text("Exercise", style: TextStyle(fontSize: 40)),
                              SizedBox(height: 10),
                              Text("Done? ${exerciseIsDone! ? "Yes" : "No"}", style: TextStyle(fontSize: 20)),
                              SizedBox(height: 10),
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children:[
                                        Text("Name: ", style: TextStyle(fontSize: 20, color: Colors.black)),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.6,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter a day name';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) async {exerciseName = value!;},
                                            decoration: InputDecoration(
                                              hintText: exerciseName,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children:[
                                        Text("Sets: ", style: TextStyle(fontSize: 20, color: Colors.black)),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.6,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter a number of sets';
                                              }
                                              try{
                                                int.parse(value);
                                              }
                                              catch(e){
                                                return 'Please enter a number of sets';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) async {exerciseSets = int.parse(value!);},
                                            decoration: InputDecoration(
                                              hintText: exerciseSets.toString(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children:[
                                        Text("Reps: ", style: TextStyle(fontSize: 20, color: Colors.black)),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.6,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter a number of reps';
                                              }
                                              try{
                                                int.parse(value);
                                              }
                                              catch(e){
                                                return 'Please enter a number of reps';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) async {exerciseReps = int.parse(value!);},
                                            decoration: InputDecoration(
                                              hintText: exerciseReps.toString(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text("Description: ", style: TextStyle(fontSize: 20, color: Colors.black)),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a description';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) async {exerciseDescription = value!;},
                                        onChanged: (value) async {exerciseDescription = value!;},
                                        decoration: InputDecoration(
                                          hintText: exercise.getDescription(),
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLines: 6,
                                        minLines: 1,
                                        controller: TextEditingController(text: exerciseDescription),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {await save();},
                                          style: Utils.buttonStyleSmall,
                                          child: Text('apply'),
                                        ),
                                        ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}