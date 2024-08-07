import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:routepayapp/ui/appbar_style.dart';
import 'package:routepayapp/ui/utils/utils.dart';
import 'package:routepayapp/widgets/round_button.dart'; // Import the flutter_image_compress package

class MyAppvehc extends StatefulWidget {
  MyAppvehc({super.key});

  @override
  _MyAppvehc createState() => _MyAppvehc();
}

class _MyAppvehc extends State<MyAppvehc> {
  bool loading = false;
  final firestore = FirebaseFirestore.instance;
  final NameController = TextEditingController();
  final driverController = TextEditingController();
  final noController = TextEditingController();
  final modelController = TextEditingController();
  final typeController = TextEditingController();
  final authen = FirebaseAuth.instance;

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  Future<String> uploadImage(File image) async {
    String url = '';
    String filename = Path.basename(image.path);
    var reference =
        FirebaseStorage.instance.ref('Vehical').child('Vehical_$filename');

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

  String dropdownvalue = 'Mehran';

  var items = [
    'Mehran',
    'Alto',
    'Civic',
    'Thar',
    'Texi',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                "Vehicle Registration",
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
                                          color: Color(0xffD6D6D6)),
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
                                              fit: BoxFit.fill),
                                          shape: BoxShape.circle,
                                          color: Color(0xffD6D6D6)),
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
                    controller: NameController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Vehical Name',
                      prefixIcon: Icon(
                        Icons.person_2_outlined,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: noController,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'no-plate  chk-2345',
                            prefixIcon: Icon(
                              Icons.phone_android_outlined,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                      DropdownButton(
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: driverController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Driver name',
                      prefixIcon: Icon(
                        Icons.phone_android_outlined,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: modelController,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Vehile Model',
                      prefixIcon: Icon(
                        Icons.local_activity_outlined,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RoundButton(
                      title: 'Submit',
                      loading: loading,
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });
                        if (selectedImage == null) {
                          Utils().toastMessage('Please select an image.');
                          return;
                        }
                        String urlim = await uploadImage(selectedImage!);
                        String userid = FirebaseAuth.instance.currentUser!.uid;
                        String id =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        await firestore
                            .collection('user')
                            .doc(userid)
                            .collection('vehcreg')
                            .doc(id)
                            .set({
                          'image': urlim,
                          'id': id,
                          'Name': NameController.text,
                          'Driver': driverController.text,
                          'NO-Plte': noController.text,
                          'Modle': modelController.text,
                          'Type':
                              dropdownvalue, // Store dropdown selected value in 'Type'
                        }).then((value) {
                          Utils().toastMessage('User Registered Successfully');
                          setState(() {
                            loading = false;
                          });
                        }).onError((error, stackTrace) {
                          Utils().toastMessage(error.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
