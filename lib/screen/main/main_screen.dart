import 'package:daelim_market/screen/main/chat/chat_list_screen.dart';
import 'package:daelim_market/screen/main/home/home_screen.dart';
import 'package:daelim_market/screen/main/main_contoller.dart';
import 'package:daelim_market/screen/main/mypage/mypage_screen.dart';
import 'package:daelim_market/screen/main/search/search_screen.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget?> _widgetOptions = [
    HomeScreen(),
    const SearchScreen(),
    null,
    const ChatListScreen(),
    const MypageScreen(),
  ];

  final MainController _controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: _widgetOptions.elementAt(_controller.page.value)!,
        ),
      ),
      floatingActionButton: SizedBox(
        width: 62.w,
        height: 62.h,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              context.go('/main/upload');
            },
            elevation: 0,
            backgroundColor: dmBlue,
            child: Icon(
              Icons.add,
              size: 30.h,
              color: dmWhite,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: dmGrey, width: 1.w),
            ),
          ),
          child: Obx(
            () => BottomNavigationBar(
              currentIndex: _controller.page.value,
              selectedItemColor: Colors.lightGreen,
              onTap: (int index) {
                if (index != 2) {
                  _controller.page.value = index;
                }
              },
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: dmWhite,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: [
                // 홈
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/icons/icon_home.png',
                      width: 30.w,
                      height: 30.h,
                    ),
                    activeIcon: Image.asset(
                      'assets/images/icons/icon_home_fill.png',
                      width: 30.w,
                      height: 30.h,
                    ),
                    label: ''),
                // 검색
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/icons/icon_search.png',
                      width: 30.w,
                      height: 30.h,
                    ),
                    activeIcon: Image.asset(
                      'assets/images/icons/icon_search_selected.png',
                      width: 30.w,
                      height: 30.h,
                    ),
                    label: ''),
                // 빈공간
                BottomNavigationBarItem(
                    icon: SizedBox(
                      width: 62.w,
                    ),
                    label: ''),
                // 채팅
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/icons/icon_chat.png',
                      width: 30.w,
                      height: 30.h,
                    ),
                    activeIcon: Image.asset(
                      'assets/images/icons/icon_chat_fill.png',
                      width: 30.w,
                      height: 30.h,
                    ),
                    label: ''),
                // 마이페이지
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/icons/icon_mypage.png',
                      width: 30.w,
                      height: 30.h,
                    ),
                    activeIcon: Image.asset(
                      'assets/images/icons/icon_mypage_fill.png',
                      width: 30.w,
                      height: 30.h,
                    ),
                    label: ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
