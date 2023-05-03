import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:fit_co/utils.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/client_menu_screen.dart';
import 'package:fit_co/trainer_menu_screen.dart';
import 'package:fit_co/designClasses/user.dart';
import 'package:fit_co/trainer_become_screen.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  const CustomAppBar({super.key, required this.startValue, required this.eMail});

  final String startValue;
  final String eMail;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState(chosenValue: startValue, eMail: eMail);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  _CustomAppBarState({required this.chosenValue, required this.eMail});

  String chosenValue;
  String eMail;
  User user = User.empty();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: user.fromFirebase(FirebaseAuth.instance.currentUser!.uid),
      builder: (ctx, _){
        if (_.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return AppBar(
        title: Text(widget.eMail, style: Utils.textStyle1),
        backgroundColor: const Color.fromARGB(255, 49, 45, 40),
        actions: [
          IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: Icon(Icons.logout)),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  dropdownColor: const Color.fromARGB(255, 0, 0, 0),

                  value: chosenValue,
                  items: <String>['Client', 'Trainer']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: Utils.textStyle1),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => chosenValue = value!);
                    if (value == 'Client') {
                      Navigator.of(context).pushReplacementNamed(ClientMenuScreen.routeName);
                    } else if (user.isTrainer) {
                      Navigator.of(context).pushReplacementNamed(TrainerMenuScreen.routeName);
                    } else {
                      Navigator.of(context).pushNamed(TrainerBecomeScreen.routeName);
                    }
                  },
                ),
              ],
            ),
          ),],
      );},
    );
  }
}
