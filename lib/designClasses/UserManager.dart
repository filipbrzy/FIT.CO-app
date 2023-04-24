import 'package:flutter/material.dart';
import 'package:fit_co/designClasses/User.dart';

class UserManager with ChangeNotifier {
  static UserManager? _instance;
  static List<User> _users = [];
  static UserManager get instance {
    _instance ??= UserManager._();
    return _instance!;
  }
  UserManager._(){}

  User? findUser(String email) {
    try {
      return _users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  User? createUser(String email, String password) {
    if (findUser(email) != null) {
      return null;
    }
    final User user = User(email, password);
    _users.add(user);
    return user;
  }

  List<User> getTrainers() {
    return _users.where((user) => user.isTrainer).toList();
  }

  User? findTrainer(String email) {
    try{
      return _users.firstWhere((user) => user.email == email && user.isTrainer);
    }catch (e){
      return null;
    }
  }
}