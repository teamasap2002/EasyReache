import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:project/navigation_menu.dart';

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  TextEditingController _phoneNumberController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _name = '';
  String _email = '';
  String _gender = '';
  bool _loading = false; // Loading indicator variable

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(15.0).r,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 50.h, horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi!,",
                  style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Text(
                      "Welcome to,",
                      style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "EasyReaches",
                      style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(0, 191, 166, 1)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text("Let's know each other.",
                    style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(0, 191, 166, 1))),
                Text(
                  "Explore our app and get required services at your place",
                  style: TextStyle(
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Text(
                  "Enter Mobile Data",
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "EasyReaches never share your personal data, your data is safe with us.",
                  style: TextStyle(fontSize: 15.sp),
                ),
                SizedBox(
                  height: 25.h,
                ),
                IntlPhoneField(
                  keyboardType: TextInputType.phone,
                  showDropdownIcon: false,
                  dropdownTextStyle: TextStyle(fontSize: 20.sp),
                  style: TextStyle(fontSize: 20.sp),
                  flagsButtonMargin: const EdgeInsets.fromLTRB(15, 12, 12, 12),
                  decoration: InputDecoration(
                    hintText: "Enter Phone Number",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(0, 191, 166, 1), width: 2),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(0, 191, 166, 1),
                        )),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(0, 191, 166, 1), width: 4),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    _phoneNumberController.text =
                    '${phone.countryCode}${phone.number}';
                  },
                ),
                SizedBox(height: 20.h),
                _loading // Show loading indicator if loading is true
                    ? CircularProgressIndicator()
                    : Center(
                  child: Container(
                    width: 300.w,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Color.fromRGBO(0, 191, 166, 1),
                      ),
                      onPressed: () async {
                        setState(() {
                          _loading = true; // Set loading to true when sending OTP
                        });
                        await _verifyPhoneNumber();
                        setState(() {
                          _loading = false; // Set loading to false after OTP sent
                        });
                      },
                      child: Text(
                        'Send OTP',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumberController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavigationMenu()),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        _showAlertDialog('Verification Failed', e.message ?? 'Unknown error occurred');
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationPage(
              verificationId: verificationId,
              phoneNumber: _phoneNumberController.text,
              name: _name,
              email: _email,
              gender: _gender,
              onResend: () async {
                await _verifyPhoneNumber();
              },
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Do something when auto retrieval times out
      },
    );
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class OTPVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String name;
  final String email;
  final String gender;
  final Function() onResend;

  OTPVerificationPage({
    required this.verificationId,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.gender,
    required this.onResend,
  });

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  TextEditingController _otpController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _loading = false; // Loading indicator variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.all(20).r,
        padding: EdgeInsets.all(10).r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "OTP sent to Mobile Number",
              style:
              TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30.h,
            ),
            Text(
              "Enter OTP to verify your Mobile Number",
              style: TextStyle(
                  color: const Color.fromRGBO(108, 99, 255, 1),
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50.h,
            ),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Enter Verification Code",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25).r,
                      borderSide: BorderSide(
                          color: Color.fromRGBO(108, 99, 255, 1), width: 2)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25).r,
                    borderSide: BorderSide(
                        color: Color.fromRGBO(108, 99, 255, 1), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25).r,
                    borderSide: BorderSide(
                        color: Color.fromRGBO(108, 99, 255, 1), width: 4),
                  )),
            ),
            SizedBox(
              height: 50.h,
            ),
            _loading // Show loading indicator if loading is true
                ? CircularProgressIndicator()
                : Container(
              width: 250.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color.fromRGBO(108, 99, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero)),
                onPressed: () async {
                  setState(() {
                    _loading = true; // Set loading to true when verifying OTP
                  });
                  await _verifyOtp();
                  setState(() {
                    _loading = false; // Set loading to false after OTP verification
                  });
                },
                child: Text(
                  'Verify',
                  style: TextStyle(
                      color: Colors.white, fontSize: 20.sp),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Didn't receive any code?",
              style: TextStyle(fontSize: 20.sp, color: Colors.grey),
            ),
            OtpTimerButton(
              height: 40.h,
              onPressed: () async {
                widget.onResend();
              },
              text: Text("Resend OTP",
                  style: TextStyle(fontSize: 20.sp)),
              buttonType: ButtonType.text_button,
              backgroundColor: const Color.fromRGBO(108, 99, 255, 1),
              duration: 45,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _otpController.text,
    );

    try {
      await _auth.signInWithCredential(credential);
      _saveUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationMenu()),
      );
    } catch (e) {
      print(e.toString());
      _showAlertDialog('Verification Failed', e.toString());
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userRef =
      _firestore.collection('Users').doc(user.uid);

      DocumentSnapshot userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>;

        Map<String, dynamic> updatedData = {
          if (widget.name.isNotEmpty && !userData.containsKey('name'))
            'name': widget.name,
          if (widget.email.isNotEmpty && !userData.containsKey('email'))
            'email': widget.email,
          if (widget.gender.isNotEmpty && !userData.containsKey('gender'))
            'gender': widget.gender,
          'phoneno': widget.phoneNumber,
        };

        if (userData.containsKey('profilePhoto')) {
          updatedData['profilePhoto'] = userData['profilePhoto'];
        } else {
          updatedData['profilePhoto'] =
          'https://cdn-icons-png.flaticon.com/128/1144/1144760.png';
        }

        await userRef.set(updatedData, SetOptions(merge: true));
      } else {
        await userRef.set({
          'name': widget.name,
          'email': widget.email,
          'gender': widget.gender,
          'phoneno': widget.phoneNumber,
          'profilePhoto':
          'https://cdn-icons-png.flaticon.com/128/1144/1144760.png',
        });
      }
    }
  }
}
