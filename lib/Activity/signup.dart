import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/Activity/phoneauth.dart';
import 'package:project/navigation_menu.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:project/services/auth.dart';
import 'package:project/widgets/uihelper.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.h),
              Image.asset(
                "assets/images/signup.png",
                height: 200.h,
                width: 200.w,
              ),
              SizedBox(height: 40.h),
              isloading
                  ? CircularProgressIndicator() // Show loading indicator when loading
                  : Container(
                height: 56.h,
                width: 256.w,
                child: SignInButton(
                  Buttons.googleDark,
                  text: "Sign up with Google",
                  onPressed: () async {
                    setState(() {
                      isloading = true; // Set loading to true when initiating sign-in
                    });
                    try {
                      if (isLogin) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavigationMenu(),
                          ),
                        );
                      } else {
                        await signInWithGoogle();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavigationMenu(),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed SignIn: $e"),
                        ),
                      );
                    } finally {
                      setState(() {
                        isloading = false; // Set loading to false after sign-in attempt
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 20.h),
              UiHelper.CustomIconButton(
                    () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PhoneAuth()),
                  );
                },
                Icons.phone,
                Colors.white,
                "Sign up with Mobile",
                const Color.fromRGBO(0, 191, 166, 1),
                Colors.white,
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a User?",
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: const Color.fromRGBO(0, 191, 166, 1),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
