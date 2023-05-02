import 'package:fit_co/utils.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/custom_app_bar.dart';
import 'designClasses/UserManager.dart';
import 'designClasses/RequestManager.dart';
import 'designClasses/User.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

class SearchTrainerScreen extends StatefulWidget {
  const SearchTrainerScreen({Key? key}) : super(key: key);

  static const routeName = '/search-trainer-screen';

  @override
  State<SearchTrainerScreen> createState() => _SearchTrainerScreenState();
}

class _SearchTrainerScreenState extends State<SearchTrainerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? searchedTrainerId;
  User user = User.empty();

  Future<void> init() async{
    await user.fromFirebase(FirebaseAuth.instance.currentUser!.uid);
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: init(),
      builder:(ctx, _) => Scaffold(
        appBar: CustomAppBar(startValue: 'Client', eMail: user.getEmail!),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Search Trainer',
                            style: TextStyle(fontSize: 50),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => _searchController.clear(),
                              ),
                              // Add a search icon or button to the search bar
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () async {
                                  // Perform the search here
                                  searchedTrainerId = await UserManager.instance.findTrainer(_searchController.text);
                                  if (searchedTrainerId == null){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('No such trainer found'),
                                      ),
                                    );
                                  } else {
                                    RequestManager.instance.sendRequest(fromId: user.id, toId: searchedTrainerId!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Request sent'),
                                      ),
                                    );
                                  }
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 200,
                          ),
                          Text('Find your preffered trainer and send him training request'),
                          const SizedBox(height: 20,),
                          ElevatedButton(
                            style: Utils.buttonStyle1,
                            onPressed: () {
                              //Navigator.of(context).pushNamed(SearchTrainerScreen.routeName);
                            },
                            child: const Text('Send Request'),
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
      ),
    );
  }
}
