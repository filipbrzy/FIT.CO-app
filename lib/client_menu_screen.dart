import 'package:fit_co/search_trainer_screen.dart';
import 'package:fit_co/utils.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/custom_app_bar.dart';
import 'client_plan_screen.dart';

class ClientMenuScreen extends StatelessWidget {
  const ClientMenuScreen({Key? key}) : super(key: key);

  static const routeName = '/client-menu-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(startValue: 'Client', eMail: "User1@gmail.com"),
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
                            Navigator.of(context).pushNamed(ClientPlanScreen.routeName);
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
    );
  }
}
