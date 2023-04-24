import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_co/first_start_screen.dart';
import 'package:fit_co/utils.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  static const routeName = '/create_account_screen';

  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreen();
}

class _CreateAccountScreen extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String passwordAgain = '';

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('email: $email, password: $password');
      try {
        final user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user!.uid)
            .set({'email': email});
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        print(e.message);
      } catch (e) {
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have been registered, login now')),
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Try again')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 49, 45, 40),
        ),
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
                        children: const [
                          SizedBox(height: 50,),
                          Text('Wellcome to', style: TextStyle(fontSize: 30)),
                          SizedBox(height: 20),
                          Text('FIT.CO', style: TextStyle(fontSize: 50),),
                          SizedBox(height: 80,),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Create Account', style: TextStyle(fontSize: 30),),
                          TextFormField(
                            textInputAction: TextInputAction.next,
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
                            textInputAction: TextInputAction.next,
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
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onSaved: (value) => passwordAgain = value!,
                            decoration: const InputDecoration(
                              label: Text('password again'),
                            ),
                          ),
                          const SizedBox(height: 40,),
                          ElevatedButton(
                            style: Utils.buttonStyle1,
                            onPressed: () {
                              submitForm();
                             },
                            child: const Text('Confirm'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
