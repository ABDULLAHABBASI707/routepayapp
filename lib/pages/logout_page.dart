import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:routepayapp/ui/appbar_style.dart';
import 'package:routepayapp/ui/auth/login_screen.dart';
import 'package:routepayapp/ui/utils/utils.dart';
import 'package:routepayapp/widgets/round_button.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  bool loading = false;
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
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: const Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            RoundButton(
              title: 'Logout',
              loading: loading,
              onTap: () {
                Utils().toastMessage("Logout Successful");
                // Navigate to the Logout Screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => (LoginScreen())));
              },
            ),
          ],
        ),
      ),
    );
  }
}
