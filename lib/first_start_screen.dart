import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_co/utils.dart';
import 'package:flutter/material.dart';
import 'package:fit_co/client_menu_screen.dart';
import 'create_account_screen.dart';

class FirstStartScreen extends StatefulWidget {
  static const String routeName = '/first-start-screen';

  const FirstStartScreen({super.key});

  @override
  State<FirstStartScreen> createState() => _FirstStartScreenState();
}

class _FirstStartScreenState extends State<FirstStartScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pushNamed(ClientMenuScreen.routeName);
      print('email: $email, password: $password');
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } catch (e) {}

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: Utils.gradient,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: const EdgeInsets.all(40),
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
              children: [
                Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(height: 100,),
                    Text('Wellcome to', style: TextStyle(fontSize: 30)),
                    SizedBox(height: 20),
                    Text('FIT.CO', style: TextStyle(fontSize: 50),),
                    SizedBox(height: 100,),
                  ],
                  ),
                ),
                Form(
                   key: _formKey,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       const Text('Let\'s start', style: TextStyle(fontSize: 30),),
                       TextFormField(
                         validator: (value) {
                              if (value == null || value.isEmpty) {
                                 return 'Please enter some text';
                              }
                              return null;
                            },
                         onSaved: (value) => email = value!,
                         decoration: const InputDecoration(
                           label: Text('email'),
                         ),
                       ),
                       TextFormField(
                         obscureText: true,
                         validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                         onSaved: (value) => password = value!,
                         decoration: const InputDecoration(
                           label: Text('password'),
                         ),
                       ),
                       const SizedBox(height: 20,),
                     ],
                   ),
                 ),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),
                          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        onPressed: submitForm,
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 20,),
                      const Text("Or"),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        style: Utils.buttonStyle1,
                        onPressed: () => Navigator.of(context).pushNamed(CreateAccountScreen.routeName),
                        child: const Text('Create Account'),
                      )],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}