import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double width_90 = width * 0.95;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "Customer Support",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          buildContainerItem(width_90),
        ],
      ),
    );
  }

  Container buildContainerItem(double width_90) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            width: width_90,
            height: 160,
            margin: const EdgeInsets.only(top: 10, bottom: 24),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(200, 144, 251, 1),
                Color.fromRGBO(241, 68, 128, 1)
              ], begin: Alignment.bottomLeft, end: Alignment.topRight),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "I'd like to know",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Details about \nmy Ride",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(right: 34, bottom: 32),
                        icon: const Icon(
                          Icons.navigate_next,
                          size: 60.0,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: width_90,
            height: 160,
            margin: const EdgeInsets.only(top: 8, bottom: 24),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(243, 191, 136, 1),
                Color.fromRGBO(251, 143, 152, 1)
              ], begin: Alignment.bottomLeft, end: Alignment.topRight),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "Unfortunately",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "I have payment \nissues",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(right: 34, bottom: 32),
                        icon: const Icon(
                          Icons.navigate_next,
                          size: 60.0,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: width_90,
            height: 160,
            margin: const EdgeInsets.only(top: 8, bottom: 12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(149, 72, 176, 1),
                Color.fromRGBO(104, 133, 240, 1)
              ], begin: Alignment.bottomLeft, end: Alignment.topRight),
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "More answers in",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "frequently\nasked questions",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(right: 34, bottom: 32),
                        icon: const Icon(
                          Icons.navigate_next,
                          size: 60.0,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
