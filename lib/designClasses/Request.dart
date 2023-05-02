import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_co/designClasses/User.dart';

class Request {
  String id;
  late String from;
  late String to;

  Request.empty({this.id = "", this.from = "", this.to = ""});

  Future<void> toFirebase() async {
    await FirebaseFirestore.instance.collection('requests').add({
      'from': from,
      'to': to,
    });
  }

  Future<void> fromFirebase({required String id}) async {
    this.id = id;
    await FirebaseFirestore.instance.collection('requests').doc(id).get().then((value) => {
      from = value.data()!['from'],
      to = value.data()!['to'],
    });
  }

  Future<void> accept() async{
    User toUser = User.empty();
    await toUser.fromFirebase(to);
    if (!toUser.isTrainer) throw Exception('Only trainers can accept requests');
    await toUser.createPlan(from);
  }
}