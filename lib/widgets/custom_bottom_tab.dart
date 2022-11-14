import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/screens/home_screen.dart';

class CustomBottomTab extends StatefulWidget {
  const CustomBottomTab({super.key});

  @override
  State<CustomBottomTab> createState() => _CustomBottomTabState();
}

class _CustomBottomTabState extends State<CustomBottomTab> {
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      selectedIndex = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
          backgroundColor: bgColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
              Icons.home,
              color: (selectedIndex == 0) ? primaryColor : secondaryColor,
            )),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_outlined,
                color: (selectedIndex == 1) ? primaryColor : secondaryColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: (selectedIndex == 2) ? primaryColor : secondaryColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: (selectedIndex == 3) ? primaryColor : secondaryColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: (selectedIndex == 4) ? primaryColor : secondaryColor,
              ),
            ),
          ],
          currentIndex: selectedIndex,
          onTap: navigationTapped),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          HomeScreen(),
          HomeScreen(),
          HomeScreen(),
          HomeScreen(),
          HomeScreen(),
        ],
      ),
    );
  }
}
