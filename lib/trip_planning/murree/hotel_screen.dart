import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routepayapp/trip_planning/murree/trip_fare_details.dart';

void main() {
  runApp(MyApphottel());
}

class MyApphottel extends StatelessWidget {
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
  final LatLng _initialPosition = LatLng(33.9070, 73.3936);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    final List<Map<String, dynamic>> tripPoints = [
      {'name': 'Mall Road', 'position': LatLng(33.9070, 73.3936)},
      {'name': 'Pindi Point', 'position': LatLng(33.8971, 73.3734)},
      {'name': 'Patriata (New Murree)', 'position': LatLng(33.8490, 73.4728)},
      {'name': 'Kashmir Point', 'position': LatLng(33.9066, 73.3867)},
      {'name': 'Murree Hills', 'position': LatLng(33.9084, 73.3915)},
      {'name': 'Ayubia National Park', 'position': LatLng(34.0748, 73.4018)},
      {'name': 'Bhurban', 'position': LatLng(33.9568, 73.4633)},
      {'name': 'Nathia Gali', 'position': LatLng(34.0666, 73.3908)},
      {'name': 'Changla Gali', 'position': LatLng(34.0338, 73.3509)},
      {'name': 'Dunga Gali', 'position': LatLng(34.0420, 73.4107)},
    ];

    final List<Map<String, dynamic>> hotels = [
      {
        'name': 'Hotel One Mall Road Murree',
        'position': LatLng(33.9061, 73.3937)
      },
      {
        'name': 'Shangrila Resort Hotel Murree',
        'position': LatLng(33.9074, 73.3949)
      },
      {'name': 'Hotel Metropole', 'position': LatLng(33.8965, 73.3750)},
      {'name': 'The Smart Hotel', 'position': LatLng(33.8982, 73.3739)},
      {
        'name': 'Pearl Continental Bhurban',
        'position': LatLng(33.9780, 73.4649)
      },
      {
        'name': 'Hotel Move n Pick Murree',
        'position': LatLng(33.8486, 73.4718)
      },
      {'name': 'Lockwood Hotel Murree', 'position': LatLng(33.9056, 73.3864)},
      {
        'name': 'Hotel One Kashmir Point Murree',
        'position': LatLng(33.9063, 73.3878)
      },
      {'name': 'Murree Hills Residency', 'position': LatLng(33.9080, 73.3913)},
      {
        'name': 'Holiday Grand Resort Bhurban',
        'position': LatLng(33.9102, 73.3891)
      },
      {
        'name': 'Green Retreat Hotel Ayubia',
        'position': LatLng(34.0762, 73.3998)
      },
      {'name': 'The Elites Hotel', 'position': LatLng(34.0751, 73.4035)},
      {
        'name': 'Pearl Continental Hotel Bhurban',
        'position': LatLng(33.9778, 73.4649)
      },
      {'name': 'Chinar Family Resort', 'position': LatLng(33.9540, 73.4676)},
      {'name': 'Hotel Elites', 'position': LatLng(34.0669, 73.3872)},
      {'name': 'Greenland Hotel', 'position': LatLng(34.0675, 73.3912)},
      {'name': 'Changla Gali Cottage', 'position': LatLng(34.0339, 73.3508)},
      {'name': 'Summer Retreat Hotel', 'position': LatLng(34.0342, 73.3510)},
      {
        'name': 'Dunga Gali Pine Track Resort',
        'position': LatLng(34.0418, 73.4111)
      },
      {'name': 'Hotel Al Azeem', 'position': LatLng(34.0423, 73.4122)},
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
                        'Murree Trip Points',
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TripFareScreen()));
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
