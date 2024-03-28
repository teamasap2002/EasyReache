import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UiHelper{
  static CustomTextField(TextEditingController controller, String text, IconData iconData, bool toHide, Color borderColor){
    return TextField(
      style: TextStyle(fontSize: 20.sp),
      controller: controller,
      obscureText: toHide,
      decoration: InputDecoration(
        hintText: text,
        prefixIcon: Icon(iconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color:borderColor, width: 4),
        ),
      ),
    );
  }

  static CustomIconButton(VoidCallback voidCallback,IconData iconData,Color iconColor, String text, Color buttonColor, Color textColor){
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 48).w,
      width: 256.w,
      height: 56.h,
      child: ElevatedButton(
          onPressed:(){
            voidCallback();
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: buttonColor,
          ),
          child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(iconData, color: iconColor),
                    SizedBox(width: 15.w,),
                    Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  static CustomButton(VoidCallback voidCallback, String text, Color buttonColor, Color textColor){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20).w,
      child: ElevatedButton(
        onPressed:(){
          voidCallback();
        },
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: buttonColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.fromLTRB(10, 25, 5, 25)),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}