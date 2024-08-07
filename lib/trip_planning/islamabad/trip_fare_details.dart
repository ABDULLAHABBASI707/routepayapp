import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geodesy/geodesy.dart' as geodesy;
import 'package:routepayapp/trip_planning/islamabad/trip_pagemsg.dart';
import 'package:routepayapp/ui/utils/utils.dart';
import 'package:routepayapp/widgets/round_button.dart';

class IslamabadTripFareScreen extends StatefulWidget {
  const IslamabadTripFareScreen({Key? key}) : super(key: key);

  @override
  State<IslamabadTripFareScreen> createState() => _TripFareScreenState();
}

class _TripFareScreenState extends State<IslamabadTripFareScreen> {
  final firestore = FirebaseFirestore.instance;
  bool loading = false;
  final NameController = TextEditingController();
  final pickupController = TextEditingController();
  final vechController = TextEditingController();
  final durationController = TextEditingController();
  final timeController = TextEditingController();
  final fareController = TextEditingController();
  final authen = FirebaseAuth.instance;
  String dropdownvalue = 'Car';

  var items = [
    'Bus',
    'High-S',
    'Car',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            color: Colors.purple,
            height: 150,
            child: Center(
              child: Text(
                'Trip Registration',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: NameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Trip Area Name',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: pickupController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Pickup-Point',
                      ),
                    ),
                  ),
                  DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: fareController,
                decoration: const InputDecoration(
                  hintText: 'Enter Trip Fare',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter Duration',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: timeController,
                decoration: const InputDecoration(
                  hintText: 'Enter Pickup Time',
                ),
              ),
              const SizedBox(height: 20),
              RoundButton(
                loading: loading,
                title: 'Calculate Fare',
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  try {
                    // Geocode pickup point to get its coordinates
                    List<Location> pickupLocations =
                        await locationFromAddress(pickupController.text);
                    if (pickupLocations.isNotEmpty) {
                      Location pickupLocation = pickupLocations.first;

                      // Geocode trip area name to get its coordinates
                      List<Location> tripAreaLocations =
                          await locationFromAddress(NameController.text);
                      if (tripAreaLocations.isNotEmpty) {
                        Location tripAreaLocation = tripAreaLocations.first;

                        // Calculate distance between pickup point and trip area
                        final geodesy.LatLng pickupLatLng = geodesy.LatLng(
                          pickupLocation.latitude,
                          pickupLocation.longitude,
                        );
                        final geodesy.LatLng tripAreaLatLng = geodesy.LatLng(
                          tripAreaLocation.latitude,
                          tripAreaLocation.longitude,
                        );
                        final geodesy.Distance distanceCalculator =
                            geodesy.Distance();
                        double distanceInMeters = distanceCalculator.distance(
                            pickupLatLng, tripAreaLatLng);

                        double farePerKilometer = 0;
                        double fuelPrice = 293;
                        double carMileage = 10;
                        double busMileage = 6;
                        double highSMileage = 13;
                        double oneDayTripCost = 500;

                        // Determine the mileage based on selected vehicle
                        double vehicleMileage = 0;
                        switch (dropdownvalue) {
                          case 'Bus':
                            vehicleMileage = busMileage;
                            break;
                          case 'High-S':
                            vehicleMileage = highSMileage;
                            break;
                          case 'Car':
                            vehicleMileage = carMileage;
                            break;
                        }

                        double numOfDays =
                            double.tryParse(durationController.text) ?? 0;
                        double tripCost = oneDayTripCost * numOfDays;
                        double fuelConsumption = 1 / vehicleMileage;
                        farePerKilometer = fuelConsumption * fuelPrice;
                        double distanceInKilometers = distanceInMeters / 1000;
                        double fare =
                            (distanceInKilometers * farePerKilometer) +
                                tripCost;

                        fareController.text = fare.toStringAsFixed(2);
                      } else {
                        Utils()
                            .toastMessage('Could not find trip area location');
                        setState(() {
                          loading = false;
                          ;
                        });
                      }
                    } else {
                      Utils()
                          .toastMessage('Could not find pickup point location');
                      setState(() {
                        loading = false;
                        ;
                      });
                    }
                  } catch (e) {
                    Utils().toastMessage('Error calculating fare: $e');
                    setState(() {
                      loading = false;
                      ;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              RoundButton(
                title: 'Submit',
                loading: loading,
                onTap: () async {
                  // Store trip details in Firestore
                  try {
                    String? deviceToken =
                        await FirebaseMessaging.instance.getToken();
                    String userId = FirebaseAuth.instance.currentUser!.uid;
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    await firestore
                        .collection('user')
                        .doc(userId)
                        .collection('TripBooking')
                        .doc(id)
                        .set({
                      'id': id,
                      'AreaName': NameController.text.toString(),
                      'Pickup': pickupController.text.toString(),
                      'Vehicle': dropdownvalue,
                      'Duration': durationController.text.toString(),
                      'Time': timeController.text.toString(),
                      'Fare': fareController.text,
                      'deviceToken': deviceToken,
                    });

                    Utils().toastMessage('Trip Registered Successfully');
                    setState(() {
                      loading = true;
                      ;
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TripPagemsg()));
                  } catch (error) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                      ;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..lineTo(0, size.height - 30)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 30)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
