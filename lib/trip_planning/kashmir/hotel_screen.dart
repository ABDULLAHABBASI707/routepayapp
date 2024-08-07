import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routepayapp/trip_planning/kashmir/trip_fare_details.dart';

void main() {
  runApp(MyAppKashmir());
}

class MyAppKashmir extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // ignore: unused_field
  late GoogleMapController _controller;
  final LatLng _initialPosition = LatLng(34.6299, 73.8977);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    final List<Map<String, dynamic>> tripPoints = [
      {'name': 'Neelum Valley', 'position': LatLng(34.6299, 73.8977)},
      {'name': 'Ratti Gali Lake', 'position': LatLng(34.8263, 74.1568)},
      {'name': 'Pir Chinasi', 'position': LatLng(34.3933, 73.5693)},
      {'name': 'Banjosa Lake', 'position': LatLng(33.8723, 73.8396)},
      {'name': 'Rawalakot', 'position': LatLng(33.8570, 73.7604)},
      {'name': 'Toli Pir', 'position': LatLng(33.9174, 73.8925)},
      {'name': 'Ramkot Fort', 'position': LatLng(33.5183, 73.7603)},
      {'name': 'Shounter Lake', 'position': LatLng(34.8181, 74.3524)},
      {'name': 'Red Fort', 'position': LatLng(34.3700, 73.4730)},
      {'name': 'Arang Kel', 'position': LatLng(34.7916, 74.3934)},
    ];

    final List<Map<String, dynamic>> hotels = [
      {'name': 'Neelum Star Hotel', 'position': LatLng(34.6300, 73.8980)},
      {
        'name': 'Shangrila Resort Neelum Valley',
        'position': LatLng(34.6315, 73.9000)
      },
      {'name': 'Mir Continental Hotel', 'position': LatLng(34.3940, 73.5700)},
      {'name': 'Banjosa Lake Resort', 'position': LatLng(33.8730, 73.8400)},
      {
        'name': 'Rawalakot Continental Hotel',
        'position': LatLng(33.8580, 73.7610)
      },
    ];

    for (int i = 0; i < tripPoints.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('trip_point_$i'),
          position: tripPoints[i]['position'],
          infoWindow: InfoWindow(title: tripPoints[i]['name']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    for (int i = 0; i < hotels.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('hotel_$i'),
          position: hotels[i]['position'],
          infoWindow: InfoWindow(title: hotels[i]['name']),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _controller = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 10,
            ),
            markers: _markers,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: AppBarClipper(),
              child: Container(
                color: Colors.purple,
                height: 150,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Kashmir Trip Points',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Near by Hotels',
                        style: TextStyle(
                          letterSpacing: 2,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 10,
            right: 10,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KashmirTripFareScreen()));
              },
              icon: Icon(Icons.directions_car, color: Colors.white),
              label:
                  Text('Start Journey', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
