import 'package:flutter/material.dart';
import 'package:routepayapp/trip_planning/trip_point.dart';

class TripPagemsg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          // clipper: Customshape(),
          child: Container(
            height: 210,
            width: MediaQuery.of(context).size.width,
            color: Colors.purple,
            child: const Center(
                child: Text(
              "",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Container(
              height: 400,
              width: 350,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 230, 232, 235),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      ' Your Request was made\n            Successfully \n   ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '  You will Get Notification \n     When Driver Accept It \n          Enjoy Trip With\n           RoutePay App \n\n   -------------------------------------',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),

            Spacer(),
            // SizedBox(height: -30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TripPointScreen()));
                  // Handle button press
                },
                child: Text('Go Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TripPagemsg(),
  ));
}
