import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static const BoxDecoration gradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(52, 255, 127, 6),
        Color.fromARGB(255, 59, 56, 53),
      ],
    ),
  );

  static ButtonStyle buttonStyle1 = ButtonStyle(
    minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),
    backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
  );

  static const TextStyle textStyle1 = TextStyle(
    color: Color.fromARGB(255, 255, 255, 255),
    fontSize: 18,
  );

  static AppBar appBarTemplate = AppBar(
    backgroundColor: Color.fromARGB(255, 49, 45, 40),
    actions: [
      DropdownButton<String>(
        dropdownColor: Color.fromARGB(255, 0, 0, 0),
        value: 'Client',
        items: <String>['Client', 'Trainer']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: Utils.textStyle1),
        );
      }).toList(),
      onChanged: (value) {
        if (value == 'Client') {
          //Navigator.of(context).pushNamed(ClientMenuScreen.routeName);
        } else {
          //Navigator.of(context).pushNamed(TrainerMenuScreen.routeName);
        }
      },
    ),],
  );

  static BoxDecoration boxDecoration = BoxDecoration(
    //color: Color.fromARGB(255, 0, 0, 0),
    border: Border.all(
      color: Color.fromARGB(255, 255, 255, 255),
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(70, 0, 0, 0),
        blurRadius: 10,
        spreadRadius: 5,
      ),
    ],
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
}