import 'package:flutter/material.dart';
import 'package:project/Activity/Home.dart';
import 'package:project/Activity/profile.dart';
import 'package:project/Activity/services.dart';
import 'package:project/Activity/store_screen.dart';
class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int myIdx = 0;
  List<Widget> widgetList = [
    Home(),
    StoreScreen(),
    Profile()
  ];
  List<Color> colorList = const[
    Color.fromRGBO(0, 176, 255, 1),
    Color.fromRGBO(108, 99, 255, 1),
    Color.fromRGBO(0, 191, 166, 1),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: myIdx,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        selectedItemColor: colorList[myIdx],
        unselectedItemColor: Colors.black,
        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
        iconSize: 40,
        onTap: (index){
          setState(() {
            myIdx = index;
          });
        },
        currentIndex: myIdx,

        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home,), label: 'Home',),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'Account'),
        ],

      ),
    );
  }
}
