
import 'package:fit_co/designClasses/Request.dart';
import 'package:fit_co/designClasses/User.dart';
import 'package:flutter/foundation.dart';

class RequestManager with ChangeNotifier {
  static RequestManager? _instance;
  static final List<Request> _requests = [];
  static RequestManager get instance {
    _instance ??= RequestManager._();
    return _instance!;
  }
  RequestManager._(){}

  void sendRequest(User from, User to){
    _requests.add(Request(from, to));
    notifyListeners();
  }

  void removeRequest(Request request){
    _requests.remove(request);
    notifyListeners();
  }

  void acceptRequest(User from, User to){
    _requests.where((request) => request.from == from && request.to == to).first.accept();
    _requests.removeWhere((request) => request.from == from && request.to == to);
    notifyListeners();
  }

  void rejectRequest(Request request){
    _requests.remove(request);
    notifyListeners();
  }

  List<Request> getRequests(){
    return _requests;
  }

  List<Request> getRequestsTo(User trainer){
    return _requests.where((request) => request.to == trainer).toList();
  }

  List<Request> getRequestsFrom(User trainee){
    return _requests.where((request) => request.from == trainee).toList();
  }
}