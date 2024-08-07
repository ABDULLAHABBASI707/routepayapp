import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:routepayapp/ui/appbar_style.dart';
import 'package:routepayapp/ui/utils/utils.dart';
import 'package:routepayapp/widgets/round_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
              "Forget Password",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/Applogo.png'),
                height: 280,
                width: 200,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              RoundButton(
                  title: 'Forgot Password',
                  onTap: () {
                    auth
                        .sendPasswordResetEmail(
                            email: emailController.text.toString())
                        .then((value) {
                      Utils().toastMessage(
                          'We have send a email to recover your password,plz checkout your email');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
