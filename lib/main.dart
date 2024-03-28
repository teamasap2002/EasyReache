import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Activities
import 'package:project/Activity/signup.dart';
import 'Activity/splashpage.dart';
import 'Activity/phoneauth.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      const EasyReachesApp(),
  );
}
class EasyReachesApp extends StatelessWidget {
  const EasyReachesApp({super.key});


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize: Size(width, height),
      splitScreenMode: true,
      builder: (context, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context)=> const SplashScreen(),
            '/signup': (context)=>const SignUp(),
            '/phone': (context)=>const PhoneAuth(),
          },
        );
      },
    );
  }
}
