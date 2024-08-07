import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:routepayapp/trip_planning/islamabad/trip_page.dart';
import 'package:routepayapp/trip_planning/kalarkhar/trip_page.dart';
import 'package:routepayapp/trip_planning/kashmir/trip_page.dart';
import 'package:routepayapp/trip_planning/murree/trip_page.dart';
import 'package:routepayapp/trip_planning/swat/trip_page.dart';
import 'package:routepayapp/ui/appbar_style.dart';

class TripPointScreen extends StatefulWidget {
  const TripPointScreen({super.key});

  @override
  State<TripPointScreen> createState() => _TripPointScreenState();
}

class _TripPointScreenState extends State<TripPointScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              "Select the Trip Point",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TripPage()));
                },
                child: const Text(
                  "MURREE",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    wordSpacing: 3,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SwatTripPage()));
                },
                child: const Text(
                  "SWAT",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    wordSpacing: 3,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KashmirTripPage()));
                },
                child: const Text(
                  "KASHMIR",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    wordSpacing: 3,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IslamabadTripPage()));
                },
                child: const Text(
                  "ISLAMABAD",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    wordSpacing: 3,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TripPageKalarKhar()));
                },
                child: const Text(
                  "KalarKhar",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    wordSpacing: 3,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const SpinKitChasingDots(
                color: Colors.teal,
                size: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
