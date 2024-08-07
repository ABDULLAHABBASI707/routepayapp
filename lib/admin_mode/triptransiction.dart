import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TripTransactionHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History (Driver)'),
      ),
      body: RideDataList(),
    );
  }
}

class RideDataList extends StatefulWidget {
  @override
  _RideDataListState createState() => _RideDataListState();
}

class _RideDataListState extends State<RideDataList> {
  List<Map<String, dynamic>> rideData = [];

  @override
  void initState() {
    super.initState();
    fetchRideData();
  }

  void fetchRideData() async {
    try {
      // Fetch all users
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('user').get();

      List<Map<String, dynamic>> allRideData = [];

      // Fetch ride booking data for each user
      for (var userDoc in userSnapshot.docs) {
        QuerySnapshot rideSnapshot =
            await userDoc.reference.collection('Triprides').get();

        for (var rideDoc in rideSnapshot.docs) {
          allRideData.add({
            'userId': userDoc.id,
            'id': rideDoc['id'],
            'pickupLocation': rideDoc['pickupLocation'],
            'dropOffLocation': rideDoc['dropOffLocation'],
            'Name': rideDoc['Name'],
            'timestamp': rideDoc['timestamp'],
          });
        }
      }

      setState(() {
        // Update the state with the fetched ride data for all users
        rideData = allRideData;
      });
    } catch (e) {
      print('Error fetching ride data: $e');
      // Handle error fetching ride data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction List:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          // Display ride data in a ListView
          Expanded(
            child: ListView.builder(
              itemCount: rideData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> ride = rideData[index];
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Pickup: ${ride['pickupLocation']}'),
                      Text('Drop-off: ${ride['dropOffLocation']}'),
                      Text('Name: ${ride['Name']}'),
                      Text('User ID: ${ride['userId']}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
