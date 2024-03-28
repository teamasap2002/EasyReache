import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../widgets/uihelper.dart';
import 'otp.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});
  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {

  TextEditingController phoneController = TextEditingController();
  String countryCode = "+91";

  String getPhoneNumber(){
      return phoneController.text;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(15).r,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 50.h, horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                      "Hi!,",
                      style:
                          TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500),
                    ),
                Row(
                  children: [
                    Text(
                      "Welcome to,",
                      style:
                      TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500),
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
                    style: TextStyle(fontSize: 15.sp)),
                SizedBox(
                  height: 25.h,
                ),
                Container(
                  // margin: EdgeInsets.all(20).r,
                  child: IntlPhoneField(
                    controller: phoneController,
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
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Container(
                  width: 700.w,
                  child: UiHelper.CustomButton(() async {
                    String phoneNum = "+91${phoneController.text}";
                    FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: phoneNum,
                        verificationCompleted:
                            (PhoneAuthCredential credential){},
                        verificationFailed: (FirebaseAuthException e) {
                          // const SnackBar(content: null,)
                        },
                        codeSent: (String verificationId, int? resentToken,) {

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OTPScreen(
                                        verificationId: verificationId,
                                        phone: phoneNum,
                                      )
                              ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                  }, "Get OTP", const Color.fromRGBO(0, 191, 166, 1), Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
