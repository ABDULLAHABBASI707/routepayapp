// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:routepayapp/ui/appbar_style.dart';
// import 'package:routepayapp/ui/auth/forgotpassword.dart';
// import 'package:routepayapp/ui/auth/sinup_screen.dart';
// import 'package:routepayapp/ui/onboarding_screen.dart';
// import 'package:routepayapp/ui/utils/utils.dart';
// import '../../widgets/round_button.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   ValueNotifier<bool> toggle = ValueNotifier<bool>(false);
//   bool passenable = true;
//   bool loading = false;
//   final _formkey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//   @override
//   void dispose() {
//     super.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//   }

//   void login() {
//     setState(() {
//       loading = true;
//     });

//     _auth
//         .signInWithEmailAndPassword(
//             email: emailController.text,
//             password: passwordController.text.toString())
//         .then((value) {
//       Utils().toastMessage(value.user!.email.toString());
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => OnboardingScreen()));

//       setState(() {
//         loading = false;
//       });
//     }).onError((error, stackTrace) {
//       debugPrint(error.toString());
//       Utils().toastMessage(error.toString());
//       setState(() {
//         loading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         SystemNavigator.pop();
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           toolbarHeight: 100,
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//           flexibleSpace: ClipPath(
//             clipper: Customshape(),
//             child: Container(
//               height: 210,
//               width: MediaQuery.of(context).size.width,
//               color: Colors.purple,
//               child: const Center(
//                   child: Text(
//                 "Login",
//                 style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               )),
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Image(
//                   image: AssetImage('assets/Applogo.png'),
//                   height: 280,
//                   width: 200,
//                 ),
//                 Form(
//                   key: _formkey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         decoration: InputDecoration(
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                               color: Colors.red,
//                               width: 1,
//                             ),
//                             borderRadius: BorderRadius.circular(21),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                               color: Colors.purple,
//                               width: 3,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           labelText: 'Email',
//                           prefixIcon: const Icon(Icons.email_rounded),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Enter Email';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       ValueListenableBuilder(
//                           valueListenable: toggle,
//                           builder: (context, value, child) {
//                             return TextFormField(
//                               obscureText: toggle.value,
//                               controller: passwordController,
//                               keyboardType: TextInputType.text,
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               decoration: InputDecoration(
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                     color: Colors.red,
//                                     width: 1,
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                     color: Colors.purple,
//                                     width: 3,
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 //obscureText: true,
//                                 // decoration: const InputDecoration(
//                                 labelText: 'Password',
//                                 // helperText: 'enter strong password',

//                                 prefixIcon: const Icon(Icons.lock),
//                                 suffix: InkWell(
//                                     onTap: () {
//                                       toggle.value = !toggle.value;
//                                     },
//                                     child: Icon(toggle.value
//                                         ? Icons.visibility_off_outlined
//                                         : Icons.visibility)),
//                               ),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Enter Password';
//                                 }
//                                 return null;
//                               },
//                             );
//                           }),
//                       const SizedBox(
//                         height: 50,
//                       ),
//                       RoundButton(
//                           title: ("Login"),
//                           loading: loading,
//                           onTap: () {
//                             if (_formkey.currentState!.validate()) {
//                               login();
//                             }
//                           }),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const ForgetPasswordScreen()),
//                             );
//                           },
//                           child: const Text(
//                             "Forget Password",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text("Dont have any account"),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => const SignUpScreen()),
//                               );
//                             },
//                             child: const Text(
//                               "Sign up",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routepayapp/admin_mode/admin.dart';
import 'package:routepayapp/ui/appbar_style.dart';
import 'package:routepayapp/ui/auth/sinup_screen.dart';
import 'package:routepayapp/ui/onboarding_screen.dart';
import 'package:routepayapp/ui/utils/utils.dart';
import 'package:routepayapp/widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ValueNotifier<bool> toggle = ValueNotifier<bool>(false);
  bool passenable = true;
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void islogin(BuildContext context) {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());
      if (emailController.text.toString() == 'admin@gmail.com' &&
          passwordController.text.toString() == 'admin123') {
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => MyAppadmin())));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => OnboardingScreen())));
      }
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
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
                "Login",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
        body: Padding(
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
                            borderRadius: BorderRadius.circular(21),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.purple,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: 'Email',
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
                        height: 30,
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
                                //obscureText: true,
                                // decoration: const InputDecoration(
                                labelText: 'Password',
                                // helperText: 'enter strong password',

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
                          title: ("Login"),
                          loading: loading,
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              islogin(context);
                            }
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const ForgetPasswordScreen()),
                            // );
                          },
                          child: const Text(
                            "Forget Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Dont have any account"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
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
