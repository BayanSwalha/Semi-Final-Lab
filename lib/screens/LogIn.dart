import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../crud/CRUD.dart';
import 'googlelogin.dart';
import 'homepageuser.dart';
import 'resetpassword.dart';
import 'signup.dart';

class Login_screen extends StatefulWidget {
  const Login_screen({Key? key}) : super(key: key);

  @override
  State<Login_screen> createState() => _Login_screenState();
}

class _Login_screenState extends State<Login_screen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: _title()),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                        fontSize: 30,
                        color: Color(0xffe46b10),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  )),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("images/1.png"))),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return forgotPassword();
                    },
                  ));
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(
                      color: Color(0xffe46b10), fontStyle: FontStyle.italic),
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffe46b10)),
                      child: const Text('Login'),
                      onPressed: () async {
                        try {
                          var authobject = FirebaseAuth.instance;
                          if (nameController.text.contains("@admin")) {
                            UserCredential myUser =
                                await authobject.signInWithEmailAndPassword(
                                    email: nameController.text,
                                    password: passwordController.text);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return CrudComponent();
                              },
                            ));
                          } else {
                            UserCredential myUser =
                                await authobject.signInWithEmailAndPassword(
                                    email: nameController.text,
                                    password: passwordController.text);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return HomePageUser();
                              },
                            ));
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("$e")));
                        }
                      })),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffe46b10)),
                    onPressed: () {
                      AuthService().signInWithGoogle();
                    },
                    label: Text("Sign in with your Google account"),
                    icon: Icon(Icons.mail)),
              ),
              Row(
                children: <Widget>[
                  const Text('Does not have account?'),
                  TextButton(
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SignUpPage();
                        },
                      ));
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          )),
    );
  }
}

Widget _title() {
  return RichText(
    softWrap: false,
    text: TextSpan(
        onEnter: ((event) {
          print("123");
        }),
        text: 'Lt',
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10)),
        children: [
          TextSpan(
            text: 'uc Stu',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          TextSpan(
            text: 'dents',
            style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
          ),
        ]),
  );
}
