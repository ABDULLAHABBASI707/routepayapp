import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RideRequestsScreen extends StatefulWidget {
  @override
  _RideRequestsScreenState createState() => _RideRequestsScreenState();
}

class _RideRequestsScreenState extends State<RideRequestsScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> rideRequests = [];

  @override
  void initState() {
    super.initState();
    fetchAllRideRequests();
  }

  Future<void> fetchAllRideRequests() async {
    List<Map<String, dynamic>> fetchedData = [];
    try {
      QuerySnapshot userSnapshot = await firestore.collection('user').get();
      for (var userDoc in userSnapshot.docs) {
        QuerySnapshot rideRequestSnapshot = await firestore
            .collection('user')
            .doc(userDoc.id)
            .collection('rideRequests')
            .get();
        for (var rideRequestDoc in rideRequestSnapshot.docs) {
          fetchedData.add({
            'userId': userDoc.id,
            'docId': rideRequestDoc.id,
            ...rideRequestDoc.data() as Map<String, dynamic>,
          });
        }
      }
      setState(() {
        rideRequests = fetchedData;
      });
    } catch (error) {
      print('Error fetching ride requests: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All Ride Requests',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: rideRequests.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: rideRequests.length,
              itemBuilder: (context, index) {
                var request = rideRequests[index];
                return ListTile(
                  title: Text('Pickup: ${request['pickupLocation']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Drop Off: ${request['dropOffLocation']}'),
                      Text('Vehicle: ${request['vehicleType']}'),
                      Text('Distance: ${request['distance']} km'),
                      Text('Fare: \$${request['fare']}'),
                      Text('Status: ${request['status']}'),
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
                            updateRideRequest(
                              request['pickupLocation'],
                              request['dropOffLocation'],
                              request['vehicleType'],
                              request['distance'].toString(),
                              request['fare'].toString(),
                              request['status'],
                              request['userId'],
                              request['docId'],
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
                                .doc(request['userId'])
                                .collection('rideRequests')
                                .doc(request['docId'])
                                .delete();
                            setState(() {
                              rideRequests.removeAt(index);
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

  Future<void> updateRideRequest(
    String pickupLocation,
    String dropOffLocation,
    String vehicleType,
    String distance,
    String fare,
    String status,
    String userId,
    String docId,
  ) async {
    final pickupController = TextEditingController(text: pickupLocation);
    final dropOffController = TextEditingController(text: dropOffLocation);
    final vehicleTypeController = TextEditingController(text: vehicleType);
    final distanceController = TextEditingController(text: distance);
    final fareController = TextEditingController(text: fare);
    final statusController = TextEditingController(text: status);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Ride Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: pickupController,
                decoration: InputDecoration(
                  hintText: 'Pickup Location',
                ),
              ),
              TextFormField(
                controller: dropOffController,
                decoration: InputDecoration(
                  hintText: 'Drop Off Location',
                ),
              ),
              TextFormField(
                controller: vehicleTypeController,
                decoration: InputDecoration(
                  hintText: 'Vehicle Type',
                ),
              ),
              TextFormField(
                controller: distanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Distance (km)',
                ),
              ),
              TextFormField(
                controller: fareController,
                decoration: InputDecoration(
                  hintText: 'Fare (\$)',
                ),
              ),
              TextFormField(
                controller: statusController,
                decoration: InputDecoration(
                  hintText: 'Status',
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
                    .collection('rideRequests')
                    .doc(docId)
                    .update({
                  'pickupLocation': pickupController.text,
                  'dropOffLocation': dropOffController.text,
                  'vehicleType': vehicleTypeController.text,
                  'distance': double.parse(distanceController.text),
                  'fare': double.parse(fareController.text),
                  'status': statusController.text,
                }).then((value) {
                  setState(() {
                    int index = rideRequests
                        .indexWhere((request) => request['docId'] == docId);
                    if (index != -1) {
                      rideRequests[index] = {
                        'userId': userId,
                        'docId': docId,
                        'pickupLocation': pickupController.text,
                        'dropOffLocation': dropOffController.text,
                        'vehicleType': vehicleTypeController.text,
                        'distance': double.parse(distanceController.text),
                        'fare': double.parse(fareController.text),
                        'status': statusController.text,
                      };
                    }
                  });
                  Navigator.pop(context);
                }).catchError((error) {
                  print('Error updating ride request: $error');
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
