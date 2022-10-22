import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<QuerySnapshot>(
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xffe46b10),
            ),
            body: Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text("${snapshot.data!.docs[i]['email']}"),
                          subtitle: Text("${snapshot.data!.docs[i]['name']}"),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
        future: usersRef.get(),
      ),
    );
  }
}
