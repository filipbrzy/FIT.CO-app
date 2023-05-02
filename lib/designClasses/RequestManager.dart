
import 'package:fit_co/designClasses/Request.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestManager with ChangeNotifier {
  static RequestManager? _instance;
  //static final List<String> _requests = [];

  static RequestManager get instance {
    _instance ??= RequestManager._();
    return _instance!;
  }
  RequestManager._(){}

  Future<void> sendRequest({required String fromId, required String toId}) async {
    await FirebaseFirestore.instance.collection('requests').add({
      'from': fromId,
      'to': toId,
    });
    notifyListeners();
  }

  Future<void> removeRequest(String requestId) async{
    await FirebaseFirestore.instance.collection('requests').doc(requestId).delete();
    notifyListeners();
  }

  Future<void> acceptRequest(Request request) async{
    await request.accept();
    await FirebaseFirestore.instance.collection('requests').doc(request.id).delete();
    notifyListeners();
  }

  Future<void> rejectRequest(Request request) async{
    await FirebaseFirestore.instance.collection('requests').doc(request.id).delete();
    notifyListeners();
  }

  Future<List<String>> getRequests() async{
    List<String> requests = [];
    await FirebaseFirestore.instance.collection('requests').get().then((value) => {
      for (DocumentSnapshot user in value.docs){
        requests.add(user.id)
      }
    });
    return requests;
  }

  Future<List<Request>> getRequestsTo(String trainerId) async{
    List<Request> requests = [];
    Request request;
    final value = await FirebaseFirestore.instance.collection('requests').where('to', isEqualTo: trainerId).get();

    for (DocumentSnapshot requestData in value.docs){
      request = Request.empty();
      await request.fromFirebase(id: requestData.id );
      requests.add(request);
    }

    return requests;
  }

  Future<String?> getRequest(String fromId, String toId) async{
    String? requestId;
    await FirebaseFirestore.instance.collection('requests').where('from', isEqualTo: fromId).where('to', isEqualTo: toId).get().then((value) => {
      requestId = value.docs.first.id,
    });
    return requestId;
  }

  Future<List<String>> getRequestsFrom(String traineeId) async{
    List<String> requests = [];
    await FirebaseFirestore.instance.collection('requests').where('from', isEqualTo: traineeId).get().then((value) => {
      for (DocumentSnapshot user in value.docs){
        requests.add(user.id)
      }
    });
    return requests;
  }
}