import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routepayapp/trip_planning/islamabad/trip_fare_details.dart';

void main() {
  runApp(MyAppIsl());
}

class MyAppIsl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreenIsl(),
    );
  }
}

class MapScreenIsl extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreenIsl> {
  // ignore: unused_field
  late GoogleMapController _controller;
  final LatLng _initialPosition = LatLng(33.6844, 73.0479);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    final List<Map<String, dynamic>> tripPoints = [
      {'name': 'Faisal Mosque', 'position': LatLng(33.7299, 73.0379)},
      {'name': 'Daman-e-Koh', 'position': LatLng(33.7461, 73.0486)},
      {'name': 'Pakistan Monument', 'position': LatLng(33.6938, 73.0685)},
      {'name': 'Lok Virsa Museum', 'position': LatLng(33.6844, 73.0479)},
      {'name': 'Rawal Lake', 'position': LatLng(33.6938, 73.1197)},
      {'name': 'Margalla Hills', 'position': LatLng(33.7530, 73.0631)},
      {'name': 'Centaurus Mall', 'position': LatLng(33.7075, 73.0551)},
      {'name': 'Shakarparian', 'position': LatLng(33.6938, 73.0709)},
      {'name': 'Saidpur Village', 'position': LatLng(33.7415, 73.0737)},
      {'name': 'Fatima Jinnah Park', 'position': LatLng(33.6993, 73.0153)},
    ];

    final List<Map<String, dynamic>> hotels = [
      {'name': 'Islamabad Serena Hotel', 'position': LatLng(33.6938, 73.0605)},
      {
        'name': 'Marriott Hotel Islamabad',
        'position': LatLng(33.7341, 73.0871)
      },
      {
        'name': 'Pearl Continental Rawalpindi',
        'position': LatLng(33.6007, 73.0515)
      },
      {'name': 'Hotel One Super', 'position': LatLng(33.7150, 73.0491)},
      {
        'name': 'Ramada by Wyndham Islamabad',
        'position': LatLng(33.6975, 73.0537)
      },
      {'name': 'Envoy Continental Hotel', 'position': LatLng(33.7101, 73.0500)},
      {'name': 'Islamabad Hotel', 'position': LatLng(33.7153, 73.0651)},
      {'name': 'Best Western Islamabad', 'position': LatLng(33.6667, 73.0658)},
      {'name': 'Hotel Crown Plaza', 'position': LatLng(33.7076, 73.0574)},
      {'name': 'Hotel Margala', 'position': LatLng(33.6842, 73.0736)},
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
              zoom: 12,
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
                        'Islamabad Trip Points',
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
                        builder: (context) => IslamabadTripFareScreen()));
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
