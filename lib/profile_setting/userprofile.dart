import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:routepayapp/ui/appbar_style.dart';
import 'package:routepayapp/ui/utils/utils.dart';
import 'package:routepayapp/widgets/round_button.dart';

class MyAppfrontup extends StatefulWidget {
  MyAppfrontup({Key? key}) : super(key: key);

  @override
  _MyAppfrontupState createState() => _MyAppfrontupState();
}

class _MyAppfrontupState extends State<MyAppfrontup> {
  bool loading = false;
  final firestore = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phonoController = TextEditingController();
  final addressController = TextEditingController();
  final authen = FirebaseAuth.instance;

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<String> uploadImage(File image) async {
    String url = '';
    String filename = Path.basename(image.path);
    var reference =
        FirebaseStorage.instance.ref('userreg').child('userreg_$filename');

    // Compress the image using flutter_image_compress
    Uint8List? compressedData = await FlutterImageCompress.compressWithFile(
      image.path,
      minWidth: 1024, // Minimum width of the output image
      minHeight: 1024, // Minimum height of the output image
      quality: 85, // Image quality (0 - 100)
    );

    // Upload the compressed image to Firebase Storage
    UploadTask uploadTask = reference.putData(compressedData!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    url = await taskSnapshot.ref.getDownloadURL();
    print('Download url: $url');
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                "User Registration",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 120,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () {
                                getImage(ImageSource.gallery);
                              },
                              child: selectedImage == null
                                  ? Container(
                                      width: 120,
                                      height: 120,
                                      margin: EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffD6D6D6),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 120,
                                      height: 120,
                                      margin: EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(selectedImage!),
                                          fit: BoxFit.fill,
                                        ),
                                        shape: BoxShape.circle,
                                        color: Color(0xffD6D6D6),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      prefixIcon: Icon(
                        Icons.person_2_outlined,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Home Address',
                      prefixIcon:
                          Icon(Icons.email_outlined, color: Colors.purple),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: phonoController,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Phno',
                      prefixIcon: Icon(Icons.phone_android_outlined,
                          color: Colors.purple),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: addressController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: ' Other address',
                      prefixIcon: Icon(Icons.local_activity_outlined,
                          color: Colors.purple),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  RoundButton(
                    title: 'Submit',
                    loading: loading,
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      if (selectedImage == null) {
                        Utils().toastMessage('Please select an image');
                        return;
                      }
                      String urlim = await uploadImage(selectedImage!);
                      String id =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      String userId = FirebaseAuth.instance.currentUser!
                          .uid; // Get the current user's ID
                      await firestore
                          .collection(
                              'user') // Reference to the 'user' collection
                          .doc(
                              userId) // Reference to the document with the user's ID
                          .collection(
                              'userreg') // Create 'userreg' subcollection
                          .doc(id) // Set document ID within the subcollection
                          .set({
                        'image': urlim,
                        'id': id,
                        'Name': nameController.text,
                        'Homeaddr': emailController.text,
                        'Phono': phonoController.text,
                        'Otheraddr': addressController.text,
                      }).then((_) {
                        Utils().toastMessage('User Registered Successfully');
                        setState(() {
                          loading = false;
                        });
                      }).catchError((error) {
                        Utils().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
