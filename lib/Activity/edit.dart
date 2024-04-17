import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String gender = '';
  late ImagePicker _picker;
  String? profilePhotoUrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getUserData();
    _picker = ImagePicker();
  }

  void getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      setState(() {
        nameController.text = userData['name'];
        mobileController.text = userData['phoneno'].substring(3);
        gender = userData['gender'];
        emailController.text = userData['email'];
        profilePhotoUrl = userData['profilePhoto'] ??
            'https://cdn-icons-png.flaticon.com/128/1144/1144760.png';
      });
    }
  }

  void editPhoto() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = path.basename(imageFile.path);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        firebase_storage.Reference userFolderRef =
        firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profilePhoto')
            .child(user.uid)
            .child(fileName);

        firebase_storage.UploadTask uploadTask =
        userFolderRef.putFile(imageFile);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
          'profilePhoto': downloadUrl,
        });
        setState(() {
          profilePhotoUrl = downloadUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23.sp,
          ),
        ),
        backgroundColor: Color.fromRGBO(0, 191, 166, 1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60.w,
                      backgroundImage: NetworkImage(profilePhotoUrl!),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          editPhoto();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(0, 191, 166, 1),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: nameController,
                cursorColor: const Color.fromRGBO(0, 191, 166, 1),
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: Color.fromRGBO(0, 191, 166, 1)),
                  ),
                  labelText: "Name",
                  labelStyle: TextStyle(
                    color: const Color.fromRGBO(0, 191, 166, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
                textAlign: TextAlign.start,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: mobileController,
                cursorColor: const Color.fromRGBO(0, 191, 166, 1),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: Color.fromRGBO(0, 191, 166, 1)),
                  ),
                  labelText: "Mobile Number",
                  labelStyle: TextStyle(
                    color: const Color.fromRGBO(0, 191, 166, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
                textAlign: TextAlign.start,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  } else if (value.length != 10) {
                    return 'Mobile number must be 10 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              Text(
                "Gender",
                style: TextStyle(
                  color: const Color.fromRGBO(0, 191, 166, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: "Male",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  Text(
                    "Male",
                    style: TextStyle(color: Colors.black, fontSize: 18.sp),
                  ),
                  Radio(
                    value: "Female",
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  Text("Female",
                      style: TextStyle(color: Colors.black, fontSize: 18.sp)),
                ],
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: emailController,
                cursorColor: const Color.fromRGBO(0, 191, 166, 1),
                decoration: InputDecoration(
                  focusedBorder: const UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: Color.fromRGBO(0, 191, 166, 1)),
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: const Color.fromRGBO(0, 191, 166, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
                textAlign: TextAlign.start,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await saveProfileChanges();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(const Radius.circular(10).r),
                  ),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 17.sp,
                    letterSpacing: 2.2,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveProfileChanges() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
        'name': nameController.text,
        'phoneno': "+91" + mobileController.text,
        'gender': gender,
        'email': emailController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Updated"),
        ),
      );
    }
  }
}
