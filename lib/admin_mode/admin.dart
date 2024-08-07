import 'package:flutter/material.dart';
import 'package:routepayapp/admin_mode/driverdata.dart';
import 'package:routepayapp/admin_mode/rideinfo.dart';
import 'package:routepayapp/admin_mode/ridetransictioninfo.dart';
import 'package:routepayapp/admin_mode/tripinfo.dart';
import 'package:routepayapp/admin_mode/triptransiction.dart';
import 'package:routepayapp/admin_mode/userfirestore.dart';
import 'package:routepayapp/admin_mode/vehcdataup.dart';
import 'package:routepayapp/widgets/round_button.dart';

class MyAppadmin extends StatefulWidget {
  MyAppadmin({super.key});

  @override
  _MyAppadmin createState() => _MyAppadmin();
}

class _MyAppadmin extends State<MyAppadmin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Admin Pannel',
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ),
          body: SafeArea(
              child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: RoundButton(
                    title: 'User Info',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => MyAppUserdataa())));
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: RoundButton(
                    title: 'Driver Info',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => MyAppDriverData())));
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: RoundButton(
                    title: 'Vehical Info',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => MyAppvehcData())));
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: RoundButton(
                    title: 'Ride Info',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => RideRequestsScreen())));
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: RoundButton(
                    title: 'Trip Info',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TripDataScreen()));
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: RoundButton(
                    title: 'Ride Transaction Info',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RideTransactionHistoryPage()));
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: RoundButton(
                    title: 'Trip Transaction Info',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TripTransactionHistoryPage()));
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 40),
              //   child: RoundButton(
              //       title: 'Get Apis Data',
              //       onTap: () {
              //         // Navigator.push(context,
              //         //MaterialPageRoute(builder: (context) => MyAppUsers()));
              //       }),
              // ),
            ],
          )),
        ));
  }
}
