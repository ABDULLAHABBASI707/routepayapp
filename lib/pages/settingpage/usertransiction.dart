import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserTransactionHistoryPage extends StatelessWidget {
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
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Fetch ride booking data for the current user
      QuerySnapshot userRideSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('Myrides')
          .get();

      // List to store ride data for the current user
      List<Map<String, dynamic>> userRideData = userRideSnapshot.docs
          .map((doc) => {
                'id': doc['id'],
                'pickupLocation': doc['pickupLocation'],
                'dropOffLocation': doc['dropOffLocation'],
                'Name': doc['Name'],
                'timestamp': doc['timestamp'],
              })
          .toList();

      setState(() {
        // Update the state with the fetched ride data for the current user
        rideData = userRideData;
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          // Display ride data in a ListView
          Expanded(
            child: ListView.builder(
              itemCount: rideData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> ride = rideData[index];
                return ListTile(
                  title: Text('Pickup: ${ride['pickupLocation']}'),
                  subtitle: Text('Drop-off: ${ride['dropOffLocation']}'),
                  trailing: Text('Name: ${ride['Name']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
