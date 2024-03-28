import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  String gender = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        // preferredSize: Size.fromHeight(0),
        AppBar(
          title: Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.sp,),),
          backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
          centerTitle: true,
        ),

      // resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").doc("${user?.uid}").snapshots(),
        builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.active){
            if(snapshot.hasData) {
              name.text = "${snapshot.data?['name']}";
              email.text = "${snapshot.data?['email']}";
              phone.text = "+91${snapshot.data?['phoneno']}".substring(3);
            }
            else if(snapshot.hasError){
              return Center(child: Text(snapshot.hasError.toString()),);
            }
            else{
              return const Center(child: Text("No data found!!"),);
            }
          }
          return SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(left: 26, top: 10, right: 20),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment:CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10.h,),
                          Container(
                            width: 100.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4.w,
                                  //color: Theme.of(context).scaffoldBackgroundColor
                                color: const Color.fromRGBO(0, 191, 166, 1),
                              ),
                              boxShadow:[
                                BoxShadow(
                                  spreadRadius: 2.r,
                                  blurRadius: 10.r,
                                  color: Colors.black.withOpacity(0.3),
                                )
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image:NetworkImage(snapshot.data?['profilePhoto']??"https://cdn-icons-png.flaticon.com/128/1144/1144760.png"),
                              ),
                            ),
                          ),
                          Container(
                            height: 30.h,
                            width: 30.w,
                              decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                     color: Color.fromRGBO(0, 191, 166, 1),
                          ),

                            child: const Icon(Icons.edit, color:Colors.black),
                          ),
                        ],
                      ),
                      TextField(
                        controller: name,
                          cursorColor: const Color.fromRGBO(0, 191, 166, 1),
                        decoration: InputDecoration(
                            focusedBorder:const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(0, 191, 166, 1))
                            ),
                          // hintText: Text(),
                          labelText: "Name",
                            labelStyle: TextStyle(color: const Color.fromRGBO(0, 191, 166, 1),fontWeight: FontWeight.bold, fontSize: 20.sp)
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black,fontSize: 18.sp),
                      ),
                      SizedBox(height: 20.h,),
                      Container(
                        width: 500.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Gender", style: TextStyle(color: const Color.fromRGBO(0, 191, 166, 1),fontWeight: FontWeight.bold, fontSize: 20.sp),),
                            Expanded(
                              child: RadioListTile(
                                title: const Text("M"),
                                  value: "Male",
                                  groupValue: gender,
                                  onChanged: (value){
                                    setState(() {
                                      gender = value.toString();
                                    });
                                  }
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: const Text("F"),
                                  value: "Female",
                                  groupValue: gender,
                                  onChanged: (value){
                                    setState(() {
                                      gender = value.toString();
                                    });
                                  }
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      TextField(
                        controller: phone,
                        cursorColor: const Color.fromRGBO(0, 191, 166, 1),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            focusedBorder:UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(0, 191, 166, 1))
                            ),
                          labelText: "Mobile no.",
                            labelStyle: TextStyle(color: Color.fromRGBO(0, 191, 166, 1),fontWeight: FontWeight.bold, fontSize: 20)
                        ),
                        style: TextStyle(color: Colors.black,fontSize: 18.sp),
                        textAlign: TextAlign.start,
                        showCursor: true,
                        maxLength: 10,
                      ),
                      SizedBox(height: 5.sp,),
                      TextField(
                        controller: email,
                          cursorColor: const Color.fromRGBO(0, 191, 166, 1),
                        decoration: InputDecoration(
                          focusedBorder:const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(0, 191, 166, 1))
                          ),
                          labelText: "Email id",
                            labelStyle: TextStyle(color: const Color.fromRGBO(0, 191, 166, 1),fontWeight: FontWeight.bold, fontSize: 20.sp)
                        ),
                        style: TextStyle(color: Colors.black,fontSize: 18.sp),
                        textAlign: TextAlign.start,
                        showCursor: true,
                      ),
                      SizedBox(height: 40.h,),
                      Center(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(0, 191, 166, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(const Radius.circular(10).r))
                          ),
                          onPressed: () async{
                            await FirebaseFirestore.instance.collection("Users").doc("${user?.uid}").update(
                                {
                                  'name': name.text,
                                  'email': email.text,
                                  'phoneno': phone.text,
                                  'gender': gender
                                });

                          },
                          child: Text("SAVE", style: TextStyle(
                              fontSize: 16.sp, letterSpacing: 2.2, color: Colors.black)),
                        ),
                      ),
                      SizedBox(height: 250.h),
                  ],
                ),
              ),
                  ),
            ),
          );
        }
      ),
    );
  }
}
