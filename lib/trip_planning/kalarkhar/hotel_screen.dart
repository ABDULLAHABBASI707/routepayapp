import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routepayapp/trip_planning/kalarkhar/trip_fare_details.dart';

void main() {
  runApp(MyAppKalarKahr());
}

class MyAppKalarKahr extends StatelessWidget {
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
  final LatLng _initialPosition = LatLng(32.7794, 72.6975);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    final List<Map<String, dynamic>> tripPoints = [
      {'name': 'Kallar Kahar Lake', 'position': LatLng(32.7794, 72.6975)},
      {'name': 'Takht-e-Babri', 'position': LatLng(32.7797, 72.7000)},
      {'name': 'Kallar Kahar Museum', 'position': LatLng(32.7800, 72.6958)},
      {'name': 'Kallar Kahar Garden', 'position': LatLng(32.7789, 72.6981)},
      {'name': 'Peacock Valley', 'position': LatLng(32.7775, 72.6965)},
      {
        'name': 'Shrine of Syed Ghulam Haider Ali Shah',
        'position': LatLng(32.7754, 72.6947)
      },
      {'name': 'TDCP Resort', 'position': LatLng(32.7780, 72.6970)},
      {'name': 'Salt Range Mountains', 'position': LatLng(32.7733, 72.6911)},
      {'name': 'Pine Track Park', 'position': LatLng(32.7761, 72.6944)},
      {'name': 'Jinnah Park', 'position': LatLng(32.7812, 72.6999)},
    ];

    final List<Map<String, dynamic>> hotels = [
      {
        'name': 'Kallar Kahar Guest House',
        'position': LatLng(32.7800, 72.6951)
      },
      {
        'name': 'Hotel Paradise Kallar Kahar',
        'position': LatLng(32.7796, 72.6984)
      },
      {
        'name': 'Kallar Kahar Tourist Inn',
        'position': LatLng(32.7792, 72.6962)
      },
      {
        'name': 'Midway Hotel Kallar Kahar',
        'position': LatLng(32.7787, 72.7001)
      },
      {'name': 'Kallar Kahar Rest House', 'position': LatLng(32.7785, 72.6949)},
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
              zoom: 14,
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
                        'Kallar Kahar Trip Points',
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
                        builder: (context) => KalarKahrTripFareScreen()));
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
