import 'package:fit_co/designClasses/User.dart';

class Request {
  User from;
  User to;

  Request(this.from, this.to);

  void accept(){
    if (!to.isTrainer) throw Exception('Only trainers can accept requests');
    to.createPlan(from);
  }
}