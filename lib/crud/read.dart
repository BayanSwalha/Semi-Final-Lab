import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudComponent extends StatefulWidget {
  const CrudComponent({super.key});

  @override
  State<CrudComponent> createState() => _CrudComponentState();
}

class _CrudComponentState extends State<CrudComponent> {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<QuerySnapshot>(
        builder: (context, snapshot) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xffe46b10),
              onPressed: () => _createOrUpdate(),
              child: const Icon(Icons.add),
            ),
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
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () =>
                                        _createOrUpdate(snapshot.data!.docs[i]),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    )),
                                IconButton(
                                    onPressed: () =>
                                        _deleteuser(snapshot.data!.docs[i].id),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
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

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _emailController.text = documentSnapshot['email'];
      _nameController.text = documentSnapshot['name'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'name',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffe46b10)),
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? email = _emailController.text;
                    final String? name = _nameController.text;
                    if (email != null && name != null) {
                      if (action == 'create') {
                        await usersRef.add({"email": email, "name": name});
                      }

                      if (action == 'update') {
                        await usersRef
                            .doc(documentSnapshot!.id)
                            .update({"email": email, "name": name});
                      }

                      _emailController.text = '';
                      _nameController.text = '';

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _deleteuser(String userId) async {
    await usersRef.doc(userId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }
}
