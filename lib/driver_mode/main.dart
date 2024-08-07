import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:routepayapp/driver_mode/driver_registration.dart';
import 'package:routepayapp/driver_mode/driver_setting/setting_page.dart';
import 'package:routepayapp/driver_mode/vehicle_registration.dart';
import 'package:routepayapp/ui/appbar_style.dart';
import 'package:routepayapp/ui/auth/notificationservices.dart';
import 'package:routepayapp/ui/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyAppdriversc());
}

class MyAppdriversc extends StatelessWidget {
  const MyAppdriversc({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom NavBar Demo',
      theme: ThemeData(
        primaryColor: const Color(0xff2F8D46),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  String? userName;
  String? userImageUrl;

  Future<void> fetchUserData() async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the 'userreg' subcollection
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('driverreg')
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userDoc = userSnapshot.docs.first;
        setState(() {
          userImageUrl = userDoc['image'];
          userName = userDoc['Name'];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Handle error fetching user data
    }
  }

  final pages = [
    const Page1(),
    Page2(),
    Page3(),
    DriverTransactionHistoryPage(),
    RatingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: Customshape(),
          child: Container(
            height: 210,
            width: MediaQuery.of(context).size.width,
            color: Colors.purple,
            child: const Center(
              child: Text(
                "Driver mode",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              currentAccountPicture: CircleAvatar(
                radius: 25,
                backgroundImage:
                    userImageUrl != null ? NetworkImage(userImageUrl!) : null,
                child:
                    userImageUrl == null ? Icon(Icons.person, size: 50) : null,
              ),
              accountName: Text(
                userName ?? 'Powered by AJZ Group',
                style: TextStyle(
                  fontSize: 19,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 81, 0),
                ),
              ),
              accountEmail: Text(
                'Copyright ©2024, All Rights Reserved',
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.verified_user_rounded,
                color: Colors.purple,
              ),
              title: const Text(
                'Driver Registration',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyAppdriver()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.car_rental_rounded,
                color: Colors.purple,
              ),
              title: const Text(
                'Vehical Registration',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyAppvehc()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.bus_alert_rounded,
                color: Colors.purple,
              ),
              title: const Text(
                'Setting',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DriverSettingPage()));
              },
            ),
            Center(
              child: ListTile(
                title: const Text(
                  'Choose User Mode',
                  style: TextStyle(
                    letterSpacing: 2,
                    color: Colors.green,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                },
              ),
            ),
          ],
        ),
      ),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 0;
                  });
                },
                icon: pageIndex == 0
                    ? const Icon(
                        Icons.home_filled,
                        color: Colors.white,
                        size: 35,
                      )
                    : const Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
              ),
              Text(
                'Home',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 1;
                  });
                },
                icon: pageIndex == 1
                    ? const Icon(
                        Icons.work_rounded,
                        color: Colors.white,
                        size: 35,
                      )
                    : const Icon(
                        Icons.work_outline_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
              ),
              Text(
                'Ride Request',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 2;
                  });
                },
                icon: pageIndex == 2
                    ? const Icon(
                        Icons.work_rounded,
                        color: Colors.white,
                        size: 35,
                      )
                    : const Icon(
                        Icons.work_outline_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
              ),
              Text(
                'Trip Request',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 3;
                  });
                },
                icon: pageIndex == 3
                    ? const Icon(
                        Icons.widgets_outlined,
                        color: Colors.white,
                        size: 35,
                      )
                    : const Icon(
                        Icons.widgets_outlined,
                        color: Colors.white,
                        size: 35,
                      ),
              ),
              Text(
                'History',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 4;
                  });
                },
                icon: pageIndex == 4
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 35,
                      )
                    : const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 35,
                      ),
              ),
              Text(
                'Ratings',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  final String? pickupLocation;

  const Page1({Key? key, this.pickupLocation}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(37.77483, -122.41942);
  Set<Marker> _markers = {};
  LatLng? _driverLocation;
  LatLng? _pickupLatLng;
  // ignore: unused_field
  bool _journeyStarted = false;
  Polyline _polyline = Polyline(
    polylineId: PolylineId('route'),
    color: Colors.blue,
    width: 5,
  );

  @override
  void initState() {
    super.initState();
    _getDriverLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (widget.pickupLocation != null) {
      _convertAddressToCoordinates(widget.pickupLocation!);
    }
  }

  void _addMarkers(LatLng pickup, LatLng driver) {
    _markers.clear();

    _markers.add(
      Marker(
        markerId: MarkerId('pickup'),
        position: pickup,
        infoWindow: InfoWindow(
          title: 'Pickup Location',
          snippet: 'Your pickup location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('driver'),
        position: driver,
        infoWindow: InfoWindow(
          title: 'Driver Location',
          snippet: 'Your driver\'s current location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    setState(() {});

    _moveCameraToFitMarkers(pickup, driver);
  }

  void _moveCameraToFitMarkers(LatLng pickup, LatLng driver) {
    LatLngBounds bounds;
    if (pickup.latitude > driver.latitude &&
        pickup.longitude > driver.longitude) {
      bounds = LatLngBounds(southwest: driver, northeast: pickup);
    } else if (pickup.longitude > driver.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickup.latitude, driver.longitude),
          northeast: LatLng(driver.latitude, pickup.longitude));
    } else if (pickup.latitude > driver.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(driver.latitude, pickup.longitude),
          northeast: LatLng(pickup.latitude, driver.longitude));
    } else {
      bounds = LatLngBounds(southwest: pickup, northeast: driver);
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  Future<void> _convertAddressToCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        _pickupLatLng =
            LatLng(locations.first.latitude, locations.first.longitude);
        if (_driverLocation != null) {
          _addMarkers(_pickupLatLng!, _driverLocation!);
        } else {
          _addMarkers(_pickupLatLng!, _center);
        }
      } else {
        print('No results found for the given address.');
      }
    } catch (e) {
      print('Failed to load coordinates for the address. Error: $e');
    }
  }

  Future<void> _getDriverLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      _driverLocation = LatLng(position.latitude, position.longitude);

      if (widget.pickupLocation != null) {
        _convertAddressToCoordinates(widget.pickupLocation!);
      } else {
        _addMarkers(_center, _driverLocation!);
      }
    } catch (e) {
      print('Error getting the driver location: $e');
    }
  }

  void _startJourney() {
    if (_pickupLatLng != null && _driverLocation != null) {
      setState(() {
        _journeyStarted = true;
        _polyline = Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: [_driverLocation!, _pickupLatLng!],
        );
      });

      Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        setState(() {
          _driverLocation = LatLng(position.latitude, position.longitude);
          _markers.removeWhere((marker) => marker.markerId.value == 'driver');
          _markers.add(
            Marker(
              markerId: MarkerId('driver'),
              position: _driverLocation!,
              infoWindow: InfoWindow(
                title: 'Driver Location',
                snippet: 'Your driver\'s current location',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ),
          );
          _polyline = Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: [_driverLocation!, _pickupLatLng!],
          );
        });

        mapController.animateCamera(
          CameraUpdate.newLatLng(_driverLocation!),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Goggle Map ',
          style: TextStyle(
              fontSize: 25,
              color: Colors.red,
              letterSpacing: 2,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _markers,
            polylines: {_polyline},
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _startJourney,
              child: Icon(Icons.directions),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> rideData = []; // List to store ride data
  late Timer _timer;
  // Define a timer variable
  notificationservices notifiser = notificationservices();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    notifiser.requestnotificationpermission();
    notifiser.setupinterectmsg(context);
    notifiser.Firebaseinit();
    notifiser.getToken().then((value) {
      print('token');
      print(value);
      fetchRideData();
      // Start a timer to show ride request button after 20 seconds
      _timer = Timer(Duration(seconds: 20), () {
        setState(() {
          // Show ride request button
          // Perform any other actions you need after 20 seconds
        });
      });

      // Call the method to fetch user data
      fetchuserDataFromFirestore();
    });

    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<bool> sendFcmMessageToToken(String deviceToken) async {
    try {
      var request = {
        "priority": "high",
        "to": deviceToken,
        "notification": {
          "title": 'Ride Accepted',
          "body": 'your ride request is accepted',
        },
      };
      var uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
      var response = await http.post(uri, body: jsonEncode(request), headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAnhRLVVg:APA91bE4IQGTqG3RBB_5CrY7hhjrI2qE6GRNNAZKQ_WRQJ4Tfnl9OoyNPw-ncFWEOGEIdcxnNW-wCi4dvigezF53H1O6j49g1mPzKDhxyy7MA_MUYfkSptJX6OF5EF9X45NcRFH7OtaI",
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  void showLocalNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: "High_Important_channel",
      importance: Importance.high,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification title
      body, // Notification body
      platformChannelSpecifics, // Notification details
    );
  }

  // Handle receiving notification message while app is in foreground
  void handleForegroundMessage(RemoteMessage message) {
    // Extract title and body from the message
    String title = message.notification!.title ?? '';
    String body = message.notification!.body ?? '';

    // Show local notification
    showLocalNotification(title, body);

    // Print additional details if needed
    print('Ride Accepted');
    print('your ride request is accepted');
    print('message is $message');
  }

  void saverideinfo(Map<String, dynamic> rideData, int index) async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      // Add ride information to Myrides sub-collection
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('Myrides')
          .doc(id)
          .set({
        'id': id,
        'pickupLocation': rideData['pickupLocation'],
        'dropOffLocation': rideData['dropOffLocation'],

        'Name': userData[index]['Name'], // Assuming userData is accessible here
        // Add other relevant ride information here
        'timestamp':
            DateTime.now(), // Add timestamp for sorting or tracking purposes
      });

      print('Ride information saved to Myrides sub-collection');
    } catch (e) {
      print('Error saving ride information: $e');
      // Handle error saving ride information
    }
  }

  void fetchuserDataFromFirestore() {
    FirebaseFirestore.instance.collection('user').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(doc.id)
            .collection('userreg')
            .get()
            .then((subCollectionSnapshot) {
          subCollectionSnapshot.docs.forEach((subDoc) {
            setState(() {
              userData.add(subDoc.data());
            });
          });
        }).catchError((error) {
          print('Error fetching subcollection: $error');
        });
      });
    }).catchError((error) {
      print('Error fetching collection: $error');
    });
  }

  // Method to fetch ride data from Firestore
  // Method to fetch ride data from Firestore
  void fetchRideData() async {
    try {
      QuerySnapshot rideSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .get(); // Fetching all users

      // List to store all ride data from all users
      List<Map<String, dynamic>> allRideData = [];

      // Iterate through each user document
      for (QueryDocumentSnapshot userDoc in rideSnapshot.docs) {
        // Fetch ride booking data for each user
        QuerySnapshot userRideSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(userDoc.id) // User document ID
            .collection('rideRequests')
            .get();

        // Extract and add ride booking data to the list
        allRideData.addAll(userRideSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display ride data
            Text(
              'Ride Requests:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: rideData.length,
                itemBuilder: (context, index) {
                  // Get the current ride request data
                  Map<String, dynamic> currentRideData = rideData[index];

                  // Customize how each ride request is displayed
                  return ListTile(
                    title: Text('Pickup: ${currentRideData['pickupLocation']}'),
                    subtitle: Column(
                      children: [
                        Text('Drop-off: ${currentRideData['dropOffLocation']}'),
                        //Text('Devicetoken: ${currentRideData['deviceToken']}'),
                        if (index <
                            userData.length) // Check if index is within bounds
                          Text('Name: ${userData[index]['Name']}')
                        else
                          Text('Name: N/A'),
                      ],
                    ),
                    // Add more details if needed
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Action to perform when "Cancel" button is pressed
                            setState(() {
                              // Remove data from frontend
                              rideData.removeAt(index);
                            });
                          },
                          child: Text('Cancel'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            // Action to perform when "Accept" button is pressed
                            // Remove data from frontend and backend
                            setState(() {
                              rideData.removeAt(index);
                            });
                            String? deviceToken =
                                currentRideData['deviceToken'];
                            if (deviceToken != null) {
                              sendFcmMessageToToken(deviceToken);
                            } else {
                              print('Device token is null');
                            }

                            String? pickupl = currentRideData['pickupLocation'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Page1(pickupLocation: pickupl)),
                            );

                            // Save ride information to Myrides sub-collection
                            saverideinfo(currentRideData, index);
                            // sendFcmMessageToToken(
                            //     currentRideData['deviceToken']);

                            // Remove ride request data from backend
                            try {
                              await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('rideRequests')
                                  .doc(currentRideData[
                                      'id']) // Assuming 'id' is the document ID of the ride request
                                  .delete();
                              // Data removed successfully from backend
                            } catch (e) {
                              // Handle error removing data from backend
                              print('Error removing data from backend: $e');
                            }
                          },
                          child: Text('Accept'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),
            // Add your ride request button here, it will appear after 20 seconds
            ElevatedButton(
              onPressed: () {
                // Action to perform when ride request button is pressed
              },
              child: Text('Request a Ride'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> rideData = []; // List to store ride data
  late Timer _timer;
  // Define a timer variable
  notificationservices notifiser = notificationservices();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    notifiser.requestnotificationpermission();
    notifiser.setupinterectmsg(context);
    notifiser.Firebaseinit();
    notifiser.getToken().then((value) {
      print('token');
      print(value);
      fetchRideData();
      // Start a timer to show ride request button after 20 seconds
      _timer = Timer(Duration(seconds: 20), () {
        setState(() {
          // Show ride request button
          // Perform any other actions you need after 20 seconds
        });
      });

      // Call the method to fetch user data
      fetchuserDataFromFirestore();
    });

    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<bool> sendFcmMessageToToken(String deviceToken) async {
    try {
      var request = {
        "priority": "high",
        "to": deviceToken,
        "notification": {
          "title": 'Ride Accepted',
          "body": 'your ride request is accepted',
        },
      };
      var uri = Uri.parse('https://fcm.googleapis.com/fcm/send');
      var response = await http.post(uri, body: jsonEncode(request), headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAnhRLVVg:APA91bE4IQGTqG3RBB_5CrY7hhjrI2qE6GRNNAZKQ_WRQJ4Tfnl9OoyNPw-ncFWEOGEIdcxnNW-wCi4dvigezF53H1O6j49g1mPzKDhxyy7MA_MUYfkSptJX6OF5EF9X45NcRFH7OtaI",
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  void showLocalNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: "High_Important_channel",
      importance: Importance.high,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification title
      body, // Notification body
      platformChannelSpecifics, // Notification details
    );
  }

  // Handle receiving notification message while app is in foreground
  void handleForegroundMessage(RemoteMessage message) {
    // Extract title and body from the message
    String title = message.notification!.title ?? '';
    String body = message.notification!.body ?? '';

    // Show local notification
    showLocalNotification(title, body);

    // Print additional details if needed
    print('Ride Accepted');
    print('your ride request is accepted');
    print('message is $message');
  }

  void saverideinfo(Map<String, dynamic> rideData, int index) async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      // Add ride information to Myrides sub-collection
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('Triprides')
          .doc(id)
          .set({
        'id': id,
        'pickupLocation': rideData['pickupLocation'],
        'dropOffLocation': rideData['dropOffLocation'],

        'Name': userData[index]['Name'], // Assuming userData is accessible here
        // Add other relevant ride information here
        'timestamp':
            DateTime.now(), // Add timestamp for sorting or tracking purposes
      });

      print('Ride information saved to Myrides sub-collection');
    } catch (e) {
      print('Error saving ride information: $e');
      // Handle error saving ride information
    }
  }

  void fetchuserDataFromFirestore() {
    FirebaseFirestore.instance.collection('user').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(doc.id)
            .collection('userreg')
            .get()
            .then((subCollectionSnapshot) {
          subCollectionSnapshot.docs.forEach((subDoc) {
            setState(() {
              userData.add(subDoc.data());
            });
          });
        }).catchError((error) {
          print('Error fetching subcollection: $error');
        });
      });
    }).catchError((error) {
      print('Error fetching collection: $error');
    });
  }

  // Method to fetch ride data from Firestore
  // Method to fetch ride data from Firestore
  void fetchRideData() async {
    try {
      QuerySnapshot rideSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .get(); // Fetching all users

      // List to store all ride data from all users
      List<Map<String, dynamic>> allRideData = [];

      // Iterate through each user document
      for (QueryDocumentSnapshot userDoc in rideSnapshot.docs) {
        // Fetch ride booking data for each user
        QuerySnapshot userRideSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(userDoc.id) // User document ID
            .collection('TripBooking')
            .get();

        // Extract and add ride booking data to the list
        allRideData.addAll(userRideSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
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
    return Scaffold(
      appBar: AppBar(
        title: Text(' Trip Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display ride data
            Text(
              ' Trip Requests:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: rideData.length,
                itemBuilder: (context, index) {
                  // Get the current ride request data
                  Map<String, dynamic> currentRideData = rideData[index];

                  // Customize how each ride request is displayed
                  return ListTile(
                    title: Text('Pickup: ${currentRideData['Pickup']}'),
                    subtitle: Column(
                      children: [
                        Text('AreaName: ${currentRideData['AreaName']}'),
                        Text('Fare: ${currentRideData['Fare']}'),
                        Text('Duration: ${currentRideData['Duration']}'),
                        Text('Time: ${currentRideData['Time']}'),
                        // Text('Devicetoken: ${currentRideData['deviceToken']}'),
                        if (index <
                            userData.length) // Check if index is within bounds
                          Text('Name: ${userData[index]['Name']}')
                        else
                          Text('Name: N/A'),
                      ],
                    ),
                    // Add more details if needed
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Action to perform when "Cancel" button is pressed
                            setState(() {
                              // Remove data from frontend
                              rideData.removeAt(index);
                            });
                          },
                          child: Text('Cancel'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            // Action to perform when "Accept" button is pressed
                            // Remove data from frontend and backend
                            setState(() {
                              rideData.removeAt(index);
                            });
                            String? deviceToken =
                                currentRideData['deviceToken'];
                            // Save ride information to Myrides sub-collection
                            saverideinfo(currentRideData, index);
                            // sendFcmMessageToToken(
                            //     currentRideData['deviceToken']);
                            if (deviceToken != null) {
                              sendFcmMessageToToken(deviceToken);
                            } else {
                              print('Device token is null');
                            }

                            // Remove ride request data from backend
                            try {
                              await FirebaseFirestore.instance
                                  .collection('user')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('rideRequests')
                                  .doc(currentRideData[
                                      'id']) // Assuming 'id' is the document ID of the ride request
                                  .delete();
                              // Data removed successfully from backend
                            } catch (e) {
                              // Handle error removing data from backend
                              print('Error removing data from backend: $e');
                            }
                          },
                          child: Text('Accept'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),
            // Add your ride request button here, it will appear after 20 seconds
            ElevatedButton(
              onPressed: () {
                // Action to perform when ride request button is pressed
              },
              child: Text('Request a Ride'),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverTransactionHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  // The rating value
  double? _ratingValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("User Rating",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the rating bar
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.green,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _ratingValue = rating;
                });
              },
            ),
            const SizedBox(height: 25),
            // Display the rating value
            Text(
              _ratingValue != null ? _ratingValue.toString() : 'Rate it!',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
