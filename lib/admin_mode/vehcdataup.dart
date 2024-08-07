import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routepayapp/ui/utils/utils.dart';

class MyAppvehcData extends StatefulWidget {
  MyAppvehcData({super.key});

  @override
  _MyAppvehcDataState createState() => _MyAppvehcDataState();
}

class _MyAppvehcDataState extends State<MyAppvehcData> {
  final SearchController = TextEditingController();
  final NameController = TextEditingController();
  final emailController = TextEditingController();
  final phonoController = TextEditingController();
  final addressController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> userData = [];

  @override
  void initState() {
    super.initState();
    fetchAllUserData();
  }

  Future<void> fetchAllUserData() async {
    List<Map<String, dynamic>> fetchedData = [];
    try {
      QuerySnapshot userSnapshot = await firestore.collection('user').get();
      for (var userDoc in userSnapshot.docs) {
        QuerySnapshot userregSnapshot = await firestore
            .collection('user')
            .doc(userDoc.id)
            .collection('driverreg')
            .get();
        for (var regDoc in userregSnapshot.docs) {
          fetchedData.add({
            'userId': userDoc.id,
            'docId': regDoc.id,
            ...regDoc.data() as Map<String, dynamic>,
          });
        }
      }
      setState(() {
        userData = fetchedData;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Driver Data',
            style: TextStyle(
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: SearchController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Search Record ID',
                  prefixIcon: Icon(Icons.search_off_outlined),
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> doc = userData[index];
                    final tittle = doc['docId'];

                    if (SearchController.text.isEmpty ||
                        tittle
                            .toLowerCase()
                            .contains(SearchController.text.toLowerCase())) {
                      return ListTile(
                        title: Text(doc['Name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${doc['docId']}'),
                            Text('Home Address: ${doc['Homeaddr']}'),
                            Text('Business Address: ${doc['Bussaddr']}'),
                            Text('Other Address: ${doc['Otheraddr']}'),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  update(
                                    doc['Name'],
                                    doc['Homeaddr'],
                                    doc['Bussaddr'],
                                    doc['Otheraddr'],
                                    doc['userId'],
                                    doc['docId'],
                                  );
                                },
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                                onTap: () {
                                  firestore
                                      .collection('user')
                                      .doc(doc['userId'])
                                      .collection('driverreg')
                                      .doc(doc['docId'])
                                      .delete();
                                  setState(() {
                                    userData.removeAt(index);
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> update(
    String name,
    String email,
    String phno,
    String Addr,
    String userId,
    String docId,
  ) async {
    NameController.text = name;
    emailController.text = email;
    phonoController.text = phno;
    addressController.text = Addr;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: Column(
              children: [
                TextFormField(
                  controller: NameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    prefixIcon: Icon(Icons.person_2_outlined),
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Home Address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                TextFormField(
                  controller: phonoController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Business Address',
                    prefixIcon: Icon(Icons.phone_android_outlined),
                  ),
                ),
                TextFormField(
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Other Address',
                    prefixIcon: Icon(Icons.local_activity_outlined),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                firestore
                    .collection('user')
                    .doc(userId)
                    .collection('driverreg')
                    .doc(docId)
                    .update({
                  'Name': NameController.text,
                  'Homeaddr': emailController.text,
                  'Bussaddr': phonoController.text,
                  'Otheraddr': addressController.text,
                }).then((value) {
                  Utils().toastMessage('Updated Successfully');
                  fetchAllUserData();
                  Navigator.pop(context);
                }).catchError((error) {
                  Utils().toastMessage(error.toString());
                });
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
