import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:routepayapp/trip_planning/kalarkhar/hotel_screen.dart';

class TripPageKalarKhar extends StatefulWidget {
  @override
  _TripPageKalarKharState createState() => _TripPageKalarKharState();
}

class _TripPageKalarKharState extends State<TripPageKalarKhar> {
  String? _weatherInfo;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final apiKey =
        '7717cdb1860d4668a55174137241905'; // Replace with your WeatherAPI key

    final url =
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=Kallar Kahar';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherInfo = '''
          Temperature: ${data['current']['temp_c']} °C
          Weather: ${data['current']['condition']['text']}
          ''';
        });
      } else {
        setState(() {
          _weatherInfo = 'Error: Could not fetch weather data';
        });
      }
    } catch (e) {
      setState(() {
        _weatherInfo = 'Error: Could not fetch weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            color: Colors.purple,
            height: 150,
            child: Center(
              child: Text(
                ' Trip Point',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Center(
              child: Text(
                'KalarKhar',
                style: TextStyle(
                  color: Colors.blue,
                  letterSpacing: 2,
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              height: 200,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: List.generate(
                  7,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/kalarkhar/image${index + 1}.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _weatherInfo != null
                ? Card(
                    elevation: 7,
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 28, left: 15, bottom: 35),
                          child: Text(
                            _weatherInfo!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                letterSpacing: 1,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                : CircularProgressIndicator(),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyAppKalarKahr()));
                  // Handle button press
                  print('Book Trip Now button pressed');
                },
                child: Text(
                  'Book Trip Now',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..lineTo(0, size.height - 30)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 30)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

void main() async {
  // await dotenv.load();
  runApp(MaterialApp(
    home: TripPageKalarKhar(),
  ));
}
