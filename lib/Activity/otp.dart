import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:project/navigation_menu.dart';
import 'package:project/widgets/uihelper.dart';

class OTPScreen extends StatefulWidget {
  String verificationId;
  String phone;
  OTPScreen({super.key, required this.verificationId, required this.phone});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  int resentToken = 0;
  TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.all(20).r,
          padding: const EdgeInsets.all(10).r,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "OTP sent to Mobile Number",
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
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
              UiHelper.CustomTextField(otpController, "Enter Verification Code",
                  Icons.lock, true, const Color.fromRGBO(108, 99, 255, 1)),
              SizedBox(
                height: 50.h,
              ),
              UiHelper.CustomButton(() async {
                final user = _auth.currentUser;
                final FirebaseFirestore db = FirebaseFirestore.instance;
                if(user!=null){
                  await db.collection('Users').doc(user.uid).set({
                    'uid': user.uid,
                    'name': "",
                    'gender': "",
                    'phoneno': widget.phone,
                    'email':  "",
                    'profilePhoto':
                    "https://cdn-icons-png.flaticon.com/128/1144/1144760.png",
                  }) ;
                }


                // await doc.update({'uid':_auth.currentUser?.uid});
                // final DocumentSnapshot snapshot = await users.doc(user?.uid).get();
                // final userFields = snapshot.data() as Map<String,dynamic>?;
                // if (user != null){
                //   users.doc(user.uid).set({
                //     'uid': user.uid,
                //     'name': userFields?['name'] ?? "",
                //     'gender': userFields?['gender']??"",
                //     'phoneno': userFields?['phoneno'] ?? widget.phone,
                //     'email': userFields?['email'] ?? "",
                //     'profilePhoto': userFields?['profilePhoto'] ??
                //         "https://cdn-icons-png.flaticon.com/128/1144/1144760.png",
                //   });
                // }
                // // if (user != null){
                // //   users.doc(user.uid).set({
                // //     'uid': user.uid,
                // //     'name': "",
                // //     'gender': userFields?['gender']??"",
                // //     'phoneno': userFields?['phoneno'] ?? widget.phone,
                // //     'email': userFields?['email'] ?? "",
                // //     'profilePhoto': userFields?['profilePhoto'] ??
                // //         "https://cdn-icons-png.flaticon.com/128/1144/1144760.png",
                // //   });
                // }
                // final FirebaseStorage _storage = FirebaseStorage.instance;
                // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                // Reference ref = _storage.ref().child('Users').child(_auth.currentUser!.uid);
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpController.text.toString()
                        );
                       await FirebaseAuth.instance.signInWithCredential(credential).then((value){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NavigationMenu()));
                        });


                    }, "Verify", const Color.fromRGBO(108, 99, 255, 1),
                        Colors.white
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
                    FirebaseAuth.instance.verifyPhoneNumber(
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseException e) {},
                      codeSent:
                          (String verificationId, int? forceResendingToken) {
                        verificationId = verificationId;
                        resentToken = forceResendingToken!;
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                      phoneNumber: widget.phone.toString(),
                    );
                  },
                  text: Text("Resend OTP ", style: TextStyle(fontSize: 20.sp)),
                  buttonType: ButtonType.text_button,
                  backgroundColor: const Color.fromRGBO(108, 99, 255, 1),
                  duration: 45),
            ],
          ),
        ),
      ),
    );
  }
}
