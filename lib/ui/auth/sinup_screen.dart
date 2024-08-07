import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routepayapp/ui/appbar_style.dart';
import 'package:routepayapp/ui/auth/login_screen.dart';
import 'package:routepayapp/ui/utils/utils.dart';
import '../../widgets/round_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ValueNotifier<bool> toggle = ValueNotifier<bool>(false);
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> _register() async {
    setState(() {
      loading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text.toString());

      // After successful registration, link Firebase Auth UID with Firestore
      linkUserWithFirestore(userCredential.user!.uid, {
        'email': emailController.text,

        // You can add more user data here...
      });
      Utils().toastMessage("User Registered Successfully");
      setState(() {
        loading = false;
      });

      // Navigate to the next screen or do something else...
    } catch (e) {
      print('Failed to register: $e');
      Utils().toastMessage("Failed to register");
      setState(() {
        loading = false;
      });
      // Handle registration errors...
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
          clipper: Customshape(),
          child: Container(
            height: 210,
            width: MediaQuery.of(context).size.width,
            color: Colors.purple,
            child: const Center(
                child: Text(
              "SignUp",
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/Applogo.png'),
                  height: 280,
                  width: 200,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.purple,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: 'Name',
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.purple,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: 'Phone',
                          prefixIcon: const Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.purple,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),

                          labelText: 'Email',
                          // helperText: 'enter email e.g json@gmail.com',
                          prefixIcon: const Icon(Icons.email_rounded),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ValueListenableBuilder(
                          valueListenable: toggle,
                          builder: (context, value, child) {
                            return TextFormField(
                              obscureText: toggle.value,
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.purple,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock),
                                suffix: InkWell(
                                    onTap: () {
                                      toggle.value = !toggle.value;
                                    },
                                    child: Icon(toggle.value
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Password';
                                }
                                return null;
                              },
                            );
                          }),
                      const SizedBox(
                        height: 50,
                      ),
                      RoundButton(
                          title: "SignUp",
                          loading: loading,
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              _register();
                            }
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have any account"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Function to link Firebase Auth UID with Firestore document
void linkUserWithFirestore(String uid, Map<String, dynamic> userData) {
  CollectionReference user = FirebaseFirestore.instance.collection('user');
  user.doc(uid).set(userData);
}
