import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/utils.dart';
import 'designClasses/Week.dart';
import 'designClasses/Request.dart';
import 'designClasses/RequestManager.dart';
import 'designClasses/User.dart';

class TrainerRequestScreen extends StatefulWidget {
  const TrainerRequestScreen({Key? key}) : super(key: key);
  static const routeName = '/trainer-request-screen';

  @override
  State<TrainerRequestScreen> createState() => _TrainerRequestScreen();
}

class _TrainerRequestScreen extends State<TrainerRequestScreen> {
  _TrainerRequestScreen();

  User user = User.empty();
  List<Request> requests = [];
  Map<Request, User> requestsTrainees = {};

  Future<void> init() async {
    await user.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
    requests = await RequestManager.instance
        .getRequestsTo(FirebaseAuth.instance.currentUser!.uid);
    print("${requests.length} requests");
    for (Request request in requests) {
      User trainee = User.empty();
      await trainee.fromFirebase(request.from);
      requestsTrainees[request] = trainee;
    }
  }

  Future<void> acceptRequest(Request request) async {
    await RequestManager.instance.acceptRequest(request);
    setState(() {
      requests.remove(request);
    });
  }

  Future<void> rejectRequest(Request request) async {
    await RequestManager.instance.rejectRequest(request);
    setState(() {
      requests.remove(request);
    });
  }


  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => print(value.data()!['name']);

    return FutureBuilder(
      future: init(),
      builder:(ctx, _) =>  Scaffold(
        appBar: CustomAppBar(startValue: 'Trainer', eMail: user.getEmail),
        body: Center(
          child: Container(
            decoration: Utils.gradient,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 60),
                          Text("Requests ${requests.length}", style: TextStyle(fontSize: 40)),
                        ],
                      )
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: Utils.boxDecoration,
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                        requests.map((request) {
                          //TODO: fill values and make the box
                          String traineeName = requestsTrainees[request]!.getEmail;

                          return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: Utils.boxDecoration,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            children: [
                              Text(traineeName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                      style: Utils.buttonStyleSmall,
                                      onPressed: () async { await acceptRequest(request); },
                                      child: const Text("Accept", style: TextStyle(color: Colors.green))),
                                  SizedBox(width: 60,),
                                  ElevatedButton(
                                      style: Utils.buttonStyleSmall,
                                      onPressed: () async {
                                        await rejectRequest(request);
                                      },
                                      child: Text("Reject", style: TextStyle(color: Colors.red))),
                                ],
                              ),
                            ],
                          ),
                        );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}