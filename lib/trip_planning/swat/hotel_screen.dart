import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routepayapp/trip_planning/swat/trip_fare_details.dart';

void main() {
  runApp(MyAppSawat());
}

class MyAppSawat extends StatelessWidget {
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
  final LatLng _initialPosition = LatLng(34.7751, 72.3623);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    final List<Map<String, dynamic>> tripPoints = [
      {'name': 'Mingora', 'position': LatLng(34.7751, 72.3623)},
      {'name': 'Malam Jabba', 'position': LatLng(34.7973, 72.5718)},
      {'name': 'Kalam', 'position': LatLng(35.4921, 72.5861)},
      {'name': 'Madyan', 'position': LatLng(35.0980, 72.5694)},
      {'name': 'Bahrain', 'position': LatLng(35.2078, 72.5408)},
      {'name': 'Marghazar', 'position': LatLng(34.7933, 72.3622)},
      {'name': 'Fizagat Park', 'position': LatLng(34.7908, 72.3640)},
      {'name': 'Ushu Forest', 'position': LatLng(35.5432, 72.5910)},
      {'name': 'Gabral', 'position': LatLng(35.6581, 72.4775)},
      {'name': 'Kandol Lake', 'position': LatLng(35.4443, 72.6449)},
    ];

    final List<Map<String, dynamic>> hotels = [
      {'name': 'Swat Serena Hotel', 'position': LatLng(34.7774, 72.3615)},
      {'name': 'PTDC Motel Malam Jabba', 'position': LatLng(34.7980, 72.5705)},
      {
        'name': 'Green Palace Hotel Kalam',
        'position': LatLng(35.4927, 72.5854)
      },
      {'name': 'Rock City Resort', 'position': LatLng(34.7900, 72.3637)},
      {
        'name': 'Pearl Continental Hotel Malam Jabba',
        'position': LatLng(34.7975, 72.5721)
      },
      {
        'name': 'Hotel White Palace Marghazar',
        'position': LatLng(34.7929, 72.3619)
      },
      {'name': 'Pine Park Hotel', 'position': LatLng(35.4910, 72.5860)},
      {'name': 'Hotel Diamond City Swat', 'position': LatLng(34.7772, 72.3624)},
      {
        'name': 'Dewanekhas Hotel Mingora',
        'position': LatLng(34.7753, 72.3630)
      },
      {'name': 'Burj Al Swat Hotel', 'position': LatLng(34.7758, 72.3627)},
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
                        'Swat Trip Points',
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
                        builder: (context) => SwatTripFareScreen()));
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
