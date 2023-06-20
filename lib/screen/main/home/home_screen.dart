import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/controller/main_screen_index_controller.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            // Title
            topPadding,
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 거래 장소 선택
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
                        // Dropdown의 값을 _selectedLocation에 대입
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
                  BlocProvider(
                    create: (_) => MainScreenIndexController(),
                    child: GestureDetector(
                      onTap: () {
                        context.read<MainScreenIndexController>().setIndex(1);
                      },
                      child: Image.asset(
                        'assets/images/icons/icon_search_black.png',
                        width: 26.5.w,
                        height: 26.5.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 17.5.h),
            divider,

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                // ListView를 아래로 스와이프할 경우 Refresh
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  backgroundColor: dmWhite,
                  color: dmDarkGrey,
                  strokeWidth: 2.w,
                  child:
                      // Firebase의 Firestore 데이터 불러오기
                      FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('product') // product 컬렉션으로부터
                        .where('location', // Dropdown의 장소 값의 조건으로
                            isEqualTo: _selectedLocation == '전체'
                                ? null
                                : _selectedLocation)
                        .where('status', isLessThan: 2)
                        .orderBy('status')
                        .orderBy("uploadTime",
                            descending: true) // uploadTime 정렬은 내림차순으로
                        .get(), // 데이터를 불러온다
                    builder: (context, snapshot) {
                      // 만약 불러오는 상태라면 로딩 인디케이터를 중앙에 배치
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      // 데이터가 존재한다면
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        // 안드로이드 스와이프 Glow 애니메이션 제거
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
                                // 첫번째 요소에만 윗부분 padding을 추가적으로 줌
                                padding: index == 0
                                    ? EdgeInsets.only(
                                        top: 30.5.h, bottom: 17.5.h)
                                    : EdgeInsets.symmetric(vertical: 17.5.h),
                                child: GestureDetector(
                                  // 요소 클릭 시 요소의 product_id를 DetailScreen으로 넘겨 이동
                                  onTap: () {
                                    context.pushNamed('detail', queryParams: {
                                      'productId': snapshot.data!.docs[index]
                                          ['product_id']
                                    });
                                  },
                                  child: Container(
                                    color: dmWhite,
                                    // 기존 113.w에서 디바이스의 0.312배의 너비 값으로 변경
                                    height: MediaQuery.of(context).size.width *
                                        0.312,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            CachedNetworkImage(
                                              fadeInDuration: Duration.zero,
                                              fadeOutDuration: Duration.zero,
                                              imageUrl: snapshot.data!
                                                  .docs[index]['images'][0],
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.312,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.312,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  color: dmGrey,
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  const CupertinoActivityIndicator(),
                                            ),
                                            snapshot.data!.docs[index]
                                                            ['status'] ==
                                                        1 ||
                                                    snapshot.data!.docs[index]
                                                            ['status'] ==
                                                        2
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.312,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.312,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.r),
                                                      color: dmBlack
                                                          .withOpacity(0.75),
                                                    ),
                                                    child: Center(
                                                      child: snapshot.data!
                                                                      .docs[index]
                                                                  ['status'] ==
                                                              1
                                                          ? Image.asset(
                                                              'assets/images/status/status_1.png',
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.312 *
                                                                  0.9)
                                                          : Image.asset(
                                                              'assets/images/status/status_2.png',
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.312 *
                                                                  0.9),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
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
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        ['title'],
                                                    overflow: TextOverflow
                                                        .ellipsis, // Text가 overflow 현상이 일어나면 뒷부분을 ...으로 생략한다
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
                                                // likes가 1개 이상일 때만 표시
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
                      }
                      // 데이터가 존재하지 않는다면
                      else {
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

  // 새로고침 메소드
  Future<void> onRefresh() async {
    // 1초 뒤에 setState를 이용하여 새로고침
    return Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }
}
