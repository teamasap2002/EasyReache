import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/Activity/address.dart';
import 'package:project/Activity/edit.dart';
import 'package:project/Activity/orders_page.dart';
import 'package:project/Activity/signup.dart';
import 'package:project/Activity/used_sevices_page.dart';
import 'package:project/services/auth.dart';
class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  bool notify = true;
  onChangeFunction(bool newval){
    setState(() {
      notify = newval;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(0, 191, 166, 1),

        ),
      ),
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 25.w),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc("${user?.uid}")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    String profilePhotoUrl =
                        snapshot.data?['profilePhoto'];
                            // "https://cdn-icons-png.flaticon.com/128/1144/1144760.png";
                    String name = snapshot.data?['name'] ?? "Edit your Profile";

                    return Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: const Color.fromRGBO(0, 191, 166, 1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.3),
                              )
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(profilePhotoUrl),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hey!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromRGBO(0, 191, 166, 1),
                                  fontSize: 20.sp),
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: const Color.fromRGBO(0, 191, 166, 1),
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 25.h,
                ),
                Text(
                  "Account",
                  style: TextStyle(
                      fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                Divider(
                  height: 15.h,
                  thickness: 2.r,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 25.r,
                      color: const Color.fromRGBO(0, 191, 166, 1),
                    ),
                    // SizedBox(width: 20.w,),
                    Text("Edit Profile", style: TextStyle(fontSize: 20.sp)),
                    // SizedBox(width: 115.w),

                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => EditProfile()));
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 25.r,
                        color: const Color.fromRGBO(0, 191, 166, 1),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 25.r,
                      color: const Color.fromRGBO(0, 191, 166, 1),
                    ),
                    // SizedBox(width: 20.w,),
                    Text("Saved Address", style: TextStyle(fontSize: 20.sp)),
                    // SizedBox(width: 79.w,),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Address()));
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 25.r,
                        color: const Color.fromRGBO(0, 191, 166, 1),
                      ),
                    ),

                  ],
                ),
                SizedBox(
                  height: 25.h,
                ),
                Text(
                  "My Activities",
                  style: TextStyle(
                      fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                Divider(
                  height: 15.h,
                  thickness: 2.r,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {

                      },
                      icon: Icon(
                        Icons.add_shopping_cart,
                        size: 25.r,
                        color: const Color.fromRGBO(0, 191, 166, 1),
                      ),
                    ),

                    // SizedBox(width: 20.w,),
                    Text("Your Orders", style: TextStyle(fontSize: 20.sp)),
                    // SizedBox(width: 85.w,),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => OrdersPage()));
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 25.r,
                        color: const Color.fromRGBO(0, 191, 166, 1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.check_circle_outline,
                        size: 25.r,
                        color: const Color.fromRGBO(0, 191, 166, 1),
                      ),
                    ),

                    // SizedBox(width: 20.w,),
                    Text("Used Services", style: TextStyle(fontSize: 20.sp)),
                    // SizedBox(width: 85.w,),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => UsedServicesPage()));
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 25.r,
                        color: const Color.fromRGBO(0, 191, 166, 1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h,),
                Text(
                  "Notifications",
                  style: TextStyle(
                      fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                Divider(
                  height: 15.h,
                  thickness: 2.r,
                ),
                SizedBox(
                  height: 10.h,
                ),
                buildNotificationOptionRow("New for you", notify, onChangeFunction ),

                SizedBox(
                  height: 50.h,
                ),
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(const Radius
                                .circular(10)
                                .r))
                    ),
                    onPressed: () {
                      signOut();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (builder) =>
                          SignUp()));
                    },
                    child: Text("SIGN OUT", style: TextStyle(
                        fontSize: 16.sp,
                        letterSpacing: 2.2,
                        color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool value, Function onChangeMethod) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.circle_notifications,
          size: 25.r,
          color: const Color.fromRGBO(0, 191, 166, 1),
        ),
        // SizedBox(width: 20.w,),
        Text(
          title,
          style: TextStyle(
              fontSize: 20.sp,
              color: Colors.black),
        ),
        // SizedBox(width: 120.w,),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Color.fromRGBO(0, 191, 166, 1),
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newVal) {
                onChangeMethod(newVal);
              },
            ))
      ],
    );
  }


}