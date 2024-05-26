import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project/Activity/recommended_services.dart';
import 'package:project/services/notification_services.dart';
import 'package:project/widgets/banner_carousel.dart';
import 'package:project/widgets/home_category_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../navigation_menu.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String apiUrlWithUserId = '';
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.getDeviceToken().then((value){
      print('devive token');
      print(value);
    });
    // If user is not null, construct the API URL with the user ID
    if (user != null) {
      apiUrlWithUserId =
      'https://4a9fda99-5ce7-4cbb-adbc-6837483887b3-00-3dbj6hsj63267.kirk.replit.dev:5000/recommendations/${user.uid}';
    }
  }

  Future<void> _refresh()async {
      return Future.delayed(const Duration(seconds: 2),(){
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const NavigationMenu()));
            });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "EasyReaches",
          style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 176, 255, 1),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.message,
            ),
          )
        ],
        leading: const CircleAvatar(
          backgroundImage: AssetImage("assets/images/logo.png"),
          radius: 15,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              BannerCarousel(),
              SizedBox(
                height: 15,
              ),
              ApiDataFetcher(apiUrl: apiUrlWithUserId, heading: 'Top Picks For You'),
              ApiDataFetcher(apiUrl: 'https://4a9fda99-5ce7-4cbb-adbc-6837483887b3-00-3dbj6hsj63267.kirk.replit.dev:5000/', heading: 'Popular Products'),
              HomeCategoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
