import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../widgets/named_widget.dart';

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
            topPadding,
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
            divider,
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: RefreshIndicator(
                  onRefresh: () async {
                    return Future.delayed(const Duration(milliseconds: 1000),
                        () {
                      setState(() {});
                    });
                  },
                  backgroundColor: dmWhite,
                  color: dmDarkGrey,
                  strokeWidth: 2.w,
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('product')
                        .where('location',
                            isEqualTo: _selectedLocation == '전체'
                                ? null
                                : _selectedLocation)
                        .orderBy("uploadTime", descending: true)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        return ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.docs.length,
                            separatorBuilder: (context, index) => divider,
                            itemBuilder: (context, index) {
                              // 가격 포맷
                              String price = '';
                              if (int.parse(
                                      snapshot.data!.docs[index]['price']) >=
                                  10000) {
                                if (int.parse(snapshot.data!.docs[index]
                                            ['price']) %
                                        10000 ==
                                    0) {
                                  price =
                                      '${NumberFormat('#,###').format(int.parse(snapshot.data!.docs[index]['price']) ~/ 10000)}만원';
                                } else {
                                  price =
                                      '${NumberFormat('#,###').format(int.parse(snapshot.data!.docs[index]['price']) ~/ 10000)}만 ${NumberFormat('#,###').format(int.parse(snapshot.data!.docs[index]['price']) % 10000)}원';
                                }
                              } else {
                                price =
                                    '${NumberFormat('#,###').format(int.parse(snapshot.data!.docs[index]['price']))}원';
                              }

                              return Padding(
                                padding: index == 0
                                    ? EdgeInsets.only(
                                        top: 30.5.h, bottom: 17.5.h)
                                    : EdgeInsets.symmetric(vertical: 17.5.h),
                                child: GestureDetector(
                                  onTap: () {
                                    context.pushNamed('detail', queryParams: {
                                      'productId': snapshot.data!.docs[index]
                                          ['product_id']
                                    });
                                  },
                                  child: Container(
                                    color: dmWhite,
                                    height: MediaQuery.of(context).size.width *
                                        0.312,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.312,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.312,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(snapshot.data!
                                                  .docs[index]['images'][0]),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            color: dmGrey,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 17.w,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 222.w,
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        ['title'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 17.sp,
                                                      fontWeight: medium,
                                                      color: dmBlack,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 11.h,
                                                ),
                                                Text(
                                                  '${snapshot.data!.docs[index]['location']} | ${DateFormat('yy.MM.dd').format((snapshot.data!.docs[index]['uploadTime'].toDate()))}',
                                                  style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: 14.sp,
                                                    fontWeight: medium,
                                                    color: dmGrey,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 9.h,
                                                ),
                                                Text(
                                                  price,
                                                  style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: 16.sp,
                                                    fontWeight: bold,
                                                    color: dmBlue,
                                                  ),
                                                ),
                                                const Expanded(
                                                    child: SizedBox()),
                                                Visibility(
                                                  maintainSize: true,
                                                  maintainAnimation: true,
                                                  maintainState: true,
                                                  visible: snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['likes']
                                                              .length >
                                                          0
                                                      ? true
                                                      : false,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/icons/icon_heart.png',
                                                          width: 13.w,
                                                        ),
                                                        SizedBox(
                                                          width: 5.5.w,
                                                        ),
                                                        Text(
                                                          '${snapshot.data!.docs[index]['likes'].length}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontSize: 14.sp,
                                                            fontWeight: bold,
                                                            color: dmGrey,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            '등록된 게시글이 없어요.',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 14.sp,
                              fontWeight: bold,
                              color: dmLightGrey,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
