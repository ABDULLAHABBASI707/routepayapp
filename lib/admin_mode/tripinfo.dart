import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripDataScreen extends StatefulWidget {
  @override
  _TripDataScreenState createState() => _TripDataScreenState();
}

class _TripDataScreenState extends State<TripDataScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> tripData = [];

  @override
  void initState() {
    super.initState();
    fetchAllTripData();
  }

  Future<void> fetchAllTripData() async {
    List<Map<String, dynamic>> fetchedData = [];
    try {
      QuerySnapshot userSnapshot = await firestore.collection('user').get();
      for (var userDoc in userSnapshot.docs) {
        QuerySnapshot tripSnapshot = await firestore
            .collection('user')
            .doc(userDoc.id)
            .collection('TripBooking')
            .get();
        for (var tripDoc in tripSnapshot.docs) {
          fetchedData.add({
            'userId': userDoc.id,
            'docId': tripDoc.id,
            ...tripDoc.data() as Map<String, dynamic>,
          });
        }
      }
      setState(() {
        tripData = fetchedData;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All Trip Data',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: tripData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tripData.length,
              itemBuilder: (context, index) {
                var trip = tripData[index];
                return ListTile(
                  title: Text('Area Name: ${trip['AreaName']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pickup Point: ${trip['Pickup']}'),
                      Text('Vehicle: ${trip['Vehicle']}'),
                      Text('Duration: ${trip['Duration']}'),
                      Text('Pickup Time: ${trip['Time']}'),
                      Text('Fare: \$${trip['Fare']}'),
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
                            updateTrip(
                              trip['AreaName'],
                              trip['Pickup'],
                              trip['Vehicle'],
                              trip['Duration'],
                              trip['Time'],
                              trip['Fare'],
                              trip['userId'],
                              trip['docId'],
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
                                .doc(trip['userId'])
                                .collection('TripBooking')
                                .doc(trip['docId'])
                                .delete();
                            setState(() {
                              tripData.removeAt(index);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> updateTrip(
    String areaName,
    String pickup,
    String vehicle,
    String duration,
    String time,
    String fare,
    String userId,
    String docId,
  ) async {
    final NameController = TextEditingController(text: areaName);
    final pickupController = TextEditingController(text: pickup);
    final durationController = TextEditingController(text: duration);
    final timeController = TextEditingController(text: time);
    final fareController = TextEditingController(text: fare);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Trip'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: NameController,
                decoration: InputDecoration(
                  hintText: 'Area Name',
                ),
              ),
              TextFormField(
                controller: pickupController,
                decoration: InputDecoration(
                  hintText: 'Pickup Point',
                ),
              ),
              TextFormField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Duration',
                ),
              ),
              TextFormField(
                controller: timeController,
                decoration: InputDecoration(
                  hintText: 'Pickup Time',
                ),
              ),
              TextFormField(
                controller: fareController,
                decoration: InputDecoration(
                  hintText: 'Fare',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await firestore
                    .collection('user')
                    .doc(userId)
                    .collection('TripBooking')
                    .doc(docId)
                    .update({
                  'AreaName': NameController.text,
                  'Pickup': pickupController.text,
                  'Vehicle': vehicle,
                  'Duration': durationController.text,
                  'Time': timeController.text,
                  'Fare': fareController.text,
                }).then((value) {
                  setState(() {
                    int index =
                        tripData.indexWhere((trip) => trip['docId'] == docId);
                    if (index != -1) {
                      tripData[index] = {
                        'userId': userId,
                        'docId': docId,
                        'AreaName': NameController.text,
                        'Pickup': pickupController.text,
                        'Vehicle': vehicle,
                        'Duration': durationController.text,
                        'Time': timeController.text,
                        'Fare': fareController.text,
                      };
                    }
                  });
                  Navigator.pop(context);
                }).catchError((error) {
                  print('Error updating trip: $error');
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
