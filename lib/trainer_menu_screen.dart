import 'package:fit_co/utils.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/custom_app_bar.dart';

class TrainerMenuScreen extends StatelessWidget {
  const TrainerMenuScreen({Key? key}) : super(key: key);

  static const routeName = '/trainer-menu-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(startValue: 'Trainer', eMail: "User1@gmail.com"),
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
                            //Navigator.of(context).pushNamed(ClientPlanScreen.routeName);
                          },
                          child: const Text('Clients'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: Utils.buttonStyle1,
                          onPressed: () {
                            //Navigator.of(context).pushNamed(SearchTrainerScreen.routeName);
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
    );
  }
}
