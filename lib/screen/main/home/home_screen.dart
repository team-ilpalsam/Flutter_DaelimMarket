import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _locationList = [
    '전체',
    '다산관',
    '생활관',
    '수암관',
    '율곡관',
    '임곡관',
    '자동차관',
    '전산관',
    '정보통신관',
    '퇴계관',
    '한림관',
    '홍지관',
  ];

  String _selectedLocation = '전체';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      menuItemStyleData: MenuItemStyleData(
                        padding: EdgeInsets.zero,
                        height: 33.h,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        elevation: 0,
                        width: 101.w,
                        decoration: BoxDecoration(
                          color: dmWhite,
                          border: Border.all(color: dmBlack),
                        ),
                        offset: Offset(0, -10.h),
                      ),
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.zero,
                      ),
                      iconStyleData: IconStyleData(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 14.37.w),
                          child: Image.asset(
                            'assets/images/icons/icon_arrow_down.png',
                            height: 11.5.h,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value!;
                        });
                      },
                      value: _selectedLocation,
                      selectedItemBuilder: (BuildContext context) {
                        return _locationList.map((value) {
                          return Text(
                            _selectedLocation,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 28.sp,
                              fontWeight: bold,
                              color: dmBlack,
                            ),
                          );
                        }).toList();
                      },
                      items: _locationList.map(
                        (value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 16.sp,
                                  fontWeight: medium,
                                  color: dmBlack,
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Image.asset(
                    'assets/images/icons/icon_search_black.png',
                    width: 26.5.w,
                    height: 26.5.h,
                  ),
                ],
              ),
            ),
            SizedBox(height: 17.5.h),
            Divider(
              thickness: 1.w,
              color: dmGrey,
            ),
          ],
        ),
      ),
    );
  }
}
