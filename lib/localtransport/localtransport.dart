import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geodesy/geodesy.dart' as geodesy;

void main() {
  runApp(MyAppplocaltransport());
}

class MyAppplocaltransport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Picker',
      home: LocationPicker(),
    );
  }
}

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropOffController = TextEditingController();
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  late LatLngBounds bounds;
  double fare = 0;
  double totalDistance = 0;
  String selectedVehicle = '';
  // ignore: unused_field
  Timer? _timer;

  @override
  Future<void> dispose() async {
    pickupController.dispose();
    dropOffController.dispose();
    super.dispose();
    // _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 10,
            ),
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            markers: markers,
            polylines: polylines,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: pickupController,
                    decoration: InputDecoration(
                      labelText: 'Pickup Location',
                      prefixIcon: Icon(Icons.location_on, color: Colors.red),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: dropOffController,
                    decoration: InputDecoration(
                      labelText: 'Drop-off Location',
                      prefixIcon: Icon(Icons.location_off, color: Colors.red),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (fare != 0)
                    Card(
                      margin: EdgeInsets.all(16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Distance: ${totalDistance.toStringAsFixed(2)} meters'),
                            SizedBox(height: 8),
                            Text('Fare: \pkr${fare.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          onPressed: _bookRide,
          child: Icon(
            Icons.directions_car,
          ),
        ),
      ),
    );
  }

  Future<void> _bookRide() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Device is not connected to the internet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No internet connection'),
        ),
      );
      return;
    }

    try {
      List<Location> pickupLocations =
          await locationFromAddress(pickupController.text);
      List<Location> dropOffLocations =
          await locationFromAddress(dropOffController.text);

      if (pickupLocations.isNotEmpty && dropOffLocations.isNotEmpty) {
        LatLng pickupLatLng = LatLng(
            pickupLocations.first.latitude, pickupLocations.first.longitude);
        LatLng dropOffLatLng = LatLng(
            dropOffLocations.first.latitude, dropOffLocations.first.longitude);

        // Calculate distance
        final geodesy.LatLng pickupGeoLatLng =
            geodesy.LatLng(pickupLatLng.latitude, pickupLatLng.longitude);
        final geodesy.LatLng dropOffGeoLatLng =
            geodesy.LatLng(dropOffLatLng.latitude, dropOffLatLng.longitude);
        final geodesy.Distance distanceCalculator = geodesy.Distance();
        double calculatedTotalDistance =
            distanceCalculator.distance(pickupGeoLatLng, dropOffGeoLatLng);

        setState(() {
          // Update the state variable with the calculated distance
          totalDistance = calculatedTotalDistance;

          // Clear previous markers and polylines
          markers.clear();
          polylines.clear();

          // Add markers for pickup and drop-off locations
          markers.add(
            Marker(
              markerId: MarkerId('pickup'),
              position: pickupLatLng,
              infoWindow: InfoWindow(title: 'Pickup Location'),
            ),
          );
          markers.add(
            Marker(
              markerId: MarkerId('dropOff'),
              position: dropOffLatLng,
              infoWindow: InfoWindow(title: 'Drop-off Location'),
            ),
          );

          // Add polyline between pickup and drop-off locations
          polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              color: Colors.blue,
              width: 5,
              points: [pickupLatLng, dropOffLatLng],
            ),
          );

          // Calculate fare
          // double farePerMeter = 0.018;
          double incfarePerMeter = 2;
          double incfarePerMeterbike = 3;
          double incfarePerMeterhighs = 1.5;
          double incfarePerMeterbr = 1.5; // Adjust this value as needed
          // double calculatedFare = totalDistance * farePerMeter;
          double farePerkiloMeter = 0; // Adjust this value as needed
          double fuelprice = 268;
          double bikemilage = 20;
          double carmilage = 6;
          double highsmilage = 10;
          double busmilage = 25;
          double rikshawmilage = 25;

          // Calculate fare for bike (30% lower than car)
          // double bikeFare = calculatedFare * 0.7;

          // Show card with fare options
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Select Vehicle Type'),
                    RadioListTile<String>(
                      title: Text('Texi'),
                      value: 'Texi',
                      groupValue: selectedVehicle,
                      onChanged: (String? value) {
                        setState(() {
                          selectedVehicle = value!;
                          double fuelcons = 1 / carmilage;
                          farePerkiloMeter =
                              fuelcons * fuelprice * incfarePerMeter;
                          double distancekilometer = totalDistance / 1000;
                          double calculatedFare =
                              distancekilometer * farePerkiloMeter;

                          fare = calculatedFare;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('High-S'),
                      value: 'High-S',
                      groupValue: selectedVehicle,
                      onChanged: (String? value) {
                        setState(() {
                          selectedVehicle = value!;
                          double fuelcons = 1 / highsmilage;
                          farePerkiloMeter =
                              fuelcons * fuelprice * incfarePerMeterhighs;
                          double distancekilometer = totalDistance / 1000;
                          double calculatedFare =
                              distancekilometer * farePerkiloMeter;

                          fare = calculatedFare;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Rikshaw'),
                      value: 'Rikshaw',
                      groupValue: selectedVehicle,
                      onChanged: (String? value) {
                        setState(() {
                          selectedVehicle = value!;
                          double fuelcons = 1 / rikshawmilage;
                          farePerkiloMeter =
                              fuelcons * fuelprice * incfarePerMeterbr;
                          double distancekilometer = totalDistance / 1000;
                          double calculatedFare =
                              distancekilometer * farePerkiloMeter;

                          fare = calculatedFare;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Local-Bus'),
                      value: 'Local-Bus',
                      groupValue: selectedVehicle,
                      onChanged: (String? value) {
                        setState(() {
                          selectedVehicle = value!;
                          double fuelcons = 1 / busmilage;
                          farePerkiloMeter =
                              fuelcons * fuelprice * incfarePerMeterbr;
                          double distancekilometer = totalDistance / 1000;
                          double calculatedFare =
                              distancekilometer * farePerkiloMeter;

                          fare = calculatedFare;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Bike'),
                      value: 'Bike',
                      groupValue: selectedVehicle,
                      onChanged: (String? value) {
                        setState(() {
                          selectedVehicle = value!;
                          double fuelcons = 1 / bikemilage;
                          farePerkiloMeter =
                              fuelcons * fuelprice * incfarePerMeterbike;
                          double distancekilometer = totalDistance / 1000;
                          double calculatedFare =
                              distancekilometer * farePerkiloMeter;
                          fare = calculatedFare;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Make request and store information in Firestore
                        // _makeRequest(
                        //     pickupLatLng, dropOffLatLng, totalDistance, fare);
                        // _startTimer();
                        ;
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          );

          // Move camera to fit both markers
          mapController.animateCamera(
            CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: LatLng(
                  pickupLatLng.latitude < dropOffLatLng.latitude
                      ? pickupLatLng.latitude
                      : dropOffLatLng.latitude,
                  pickupLatLng.longitude < dropOffLatLng.longitude
                      ? pickupLatLng.longitude
                      : dropOffLatLng.longitude,
                ),
                northeast: LatLng(
                  pickupLatLng.latitude > dropOffLatLng.latitude
                      ? pickupLatLng.latitude
                      : dropOffLatLng.latitude,
                  pickupLatLng.longitude > dropOffLatLng.longitude
                      ? pickupLatLng.longitude
                      : dropOffLatLng.longitude,
                ),
              ),
              100,
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location not found'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error booking ride'),
        ),
      );
    }
  }
}
