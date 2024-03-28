//packages
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/Activity/signup.dart';
import 'package:project/navigation_menu.dart';
import 'package:project/services/auth.dart';
//utils
import 'package:project/utils/gifs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLogin();
    Timer(const Duration(seconds: 5), () {
      if (isLogin) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const NavigationMenu()));
      } else{
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const SignUp()), (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Gifs.splash,
              width: 300.w,
              height: 250.h,
            ),
            Text(
              "Easy Reaches",
              style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
