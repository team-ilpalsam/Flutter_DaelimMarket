import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../styles/input_deco.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: dmWhite,
        body: SafeArea(
          child: Column(
            children: [
              topPadding,
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), //양쪽 간격
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: mainInputTextDeco,
                        decoration: searchInputDeco(hintText: '검색할 내용을 입력하세요.'),
                        cursorHeight: 18.h,
                        cursorColor: dmBlack,
                        onChanged: (value) {
                          setState(
                            () {},
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.5.h,
              ),
              divider,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('product') // product 컬렉션으로부터
                        .where('title',
                            isGreaterThanOrEqualTo: searchController.text)
                        .where('title',
                            isLessThanOrEqualTo:
                                '${searchController.text}\uf8ff')
                        .orderBy('title')
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
                                        CachedNetworkImage(
                                          fadeInDuration: Duration.zero,
                                          fadeOutDuration: Duration.zero,
                                          imageUrl: snapshot.data!.docs[index]
                                              ['images'][0],
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
                                                  BorderRadius.circular(5.r),
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
                            '검색과 일치하는 게시글이 없어요.',
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
            ],
          ),
        ),
      ),
    );
  }
}
