import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_webservice/places.dart';
import 'package:routepayapp/driver_mode/main.dart';
import 'package:routepayapp/localtransport/localtransport.dart';
import 'package:routepayapp/pages/logout_page.dart';
import 'package:routepayapp/pages/settingpage/setting_page.dart';
import 'package:routepayapp/pages/support_page.dart';
import 'package:routepayapp/profile_setting/userprofile.dart';
import 'package:routepayapp/setting_gogglemap/location_picker.dart';
import 'package:routepayapp/trip_planning/trip_point.dart';
import 'package:routepayapp/ui/appbar_style.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _mapStyle;
  String? userImageUrl;
  String? userName;
  @override
  void initState() {
    super.initState();
    fetchUserData();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  Future<void> fetchUserData() async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the 'userreg' subcollection
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('userreg')
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

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(33.9077736, 73.3914997),
    zoom: 14.4746,
  );

  GoogleMapController? myMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 110,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: Customshape(),
          child: Container(
            height: 210,
            width: MediaQuery.of(context).size.width,
            color: Colors.purple,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(children: [
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
                initialCameraPosition: _kGooglePlex,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  myMapController = controller;
                  myMapController!.setMapStyle(_mapStyle);
                }),
          ),
          buildProfileTile(),
          buildTextField(),
          Positioned(
            bottom: 300,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 1)
                  ],
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: TextFormField(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TripPointScreen()));
                  },
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffA7A7A7)),
                  decoration: const InputDecoration(
                    hintText: "Go for Trip",
                    hintStyle: TextStyle(
                      letterSpacing: 2,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.travel_explore_sharp,
                        color: Colors.blue,
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 1)
                  ],
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: TextFormField(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyAppplocaltransport()));
                  },
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffA7A7A7)),
                  decoration:const InputDecoration(
                    hintText: "Go for local Transport",
                    hintStyle: TextStyle(
                      letterSpacing: 2,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.train_sharp,
                        color: Colors.blue,
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          showSourceField ? buildTextFieldForSource() : Container(),
        ]),
      ),
    );
  }

  Widget buildProfileTile() {
    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Container(
        child: Row(children: [
          Container(
            child: CircleAvatar(
              radius: 25,
              backgroundImage:
                  userImageUrl != null ? NetworkImage(userImageUrl!) : null,
              child: userImageUrl == null ? Icon(Icons.person, size: 50) : null,
            ),
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,

              // image: DecorationImage(
              //     image: AssetImage('assets/person.png'), fit: BoxFit.fill),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RichText(
              text: const TextSpan(children: [
                TextSpan(
                  text: "GOOD MORNING,  ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ]),
            ),
            Text(
              userName ?? 'Powered by AJZ Group',
              style: const TextStyle(
                fontSize: 19,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 81, 0),
              ),
            ),
            const Text(
              "Where are you going?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          ]),
        ]),
      ),
    );
  }

  Future<String> showGoggleAutoComplete() async {
    const kGoogleApiKey = "AIzaSyC46NG2a_C1eNYLMF7EKhRAlx_yEouZXI0";

    Prediction? p = await PlacesAutocomplete.show(
      offset: 0,
      radius: 1000,
      strictbounds: false,
      region: "us",
      language: "en",
      context: context,
      mode: Mode.overlay,
      apiKey: kGoogleApiKey,
      components: [new Component(Component.country, "us")],
      types: ["(cities)"],
      hint: "Search City",
    );

    return p?.description ?? "";
  }

  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  bool showSourceField = false;

  Widget buildTextField() {
    return Positioned(
      top: 170,
      left: 20,
      right: 20,
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 1)
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: destinationController,
          readOnly: true,
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApppoly()));
          },
          // onTap: () async {
          //   String selectedPlace = await showGoggleAutoComplete();
          //   destinationController.text = selectedPlace;

          //   setState(() {
          //     showSourceField = true;
          //   });
          // },
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xffA7A7A7)),
          decoration: const InputDecoration(
            hintText: 'Search for a destination',
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
                color: Colors.blue,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldForSource() {
    return Positioned(
      top: 230,
      left: 20,
      right: 20,
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            controller: sourceController,
            readOnly: true,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xffA7A7A7)),
            decoration: const InputDecoration(
              hintText: 'Trip Planing',
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.search,
                  color: Colors.blue,
                ),
              ),
              border: InputBorder.none,
            ),
          )),
    );
  }

  buildDrawerItem(
      {required String title,
      required Function onPressed,
      Color color = Colors.black,
      double fontSize = 20,
      FontWeight fontWeight = FontWeight.w700,
      double height = 45,
      bool isVisible = false}) {
    return SizedBox(
      height: height,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        // minVerticalPadding: 0,
        dense: true,
        onTap: () => onPressed(),
        title: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: fontWeight, color: color),
            ),
            const SizedBox(
              width: 5,
            ),
            isVisible
                ? CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 15,
                    child: Text(
                      '1',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  buildDrawer() {
    return Drawer(
        child: Column(children: [
      Container(
        height: 150,
        child: DrawerHeader(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: CircleAvatar(
                radius: 25,
                backgroundImage:
                    userImageUrl != null ? NetworkImage(userImageUrl!) : null,
                child:
                    userImageUrl == null ? Icon(Icons.person, size: 50) : null,
              ),
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Good Morning, ',
                    style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.28), fontSize: 14)),
                Text(
                  userName ?? 'Powered by AJZ Group',
                  style: TextStyle(
                    fontSize: 19,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 81, 0),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            buildDrawerItem(
                title: 'User Registration',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyAppfrontup()));
                }),
            buildDrawerItem(
                title: 'Settings',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingPage()));
                }),
            buildDrawerItem(
                title: 'Support',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SupportPage()));
                }),
            buildDrawerItem(
                title: 'Log Out',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogoutScreen()));
                }),
          ],
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyAppdriversc()));
        },
        child: Text(
          "Choose Driver Mode",
          style: TextStyle(
            letterSpacing: 2,
            color: Colors.green,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Spacer(),
      Divider(),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            buildDrawerItem(
                title: 'Do more',
                onPressed: () {},
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.15),
                height: 20),
            const SizedBox(
              height: 20,
            ),
            buildDrawerItem(
                title: 'Get food delivery',
                onPressed: () {},
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.15),
                height: 20),
            buildDrawerItem(
                title: 'Make money driving',
                onPressed: () {},
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.15),
                height: 20),
            buildDrawerItem(
              title: 'Rate us on store',
              onPressed: () {},
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.15),
              height: 20,
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ]));
  }
}
