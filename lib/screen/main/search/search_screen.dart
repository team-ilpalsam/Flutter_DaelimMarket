import 'package:cached_network_image/cached_network_image.dart';
import 'package:daelim_market/const/common.dart';
import 'package:daelim_market/screen/main/search/search_controller.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../styles/input_deco.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchGetXController controller =
        Get.put(SearchGetXController(context));
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: dmWhite,
        body: SafeArea(
          child: Column(
            children: [
              topPadding,
              SizedBox(
                height: 13.25.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w), // 양쪽 간격
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go('/main');
                      },
                      child: Image.asset(
                        'assets/images/icons/icon_back.png',
                        alignment: Alignment.topLeft,
                        height: 18.h,
                      ),
                    ),
                    SizedBox(
                      width: 20.h,
                    ),
                    Expanded(
                      child: TextField(
                        style: mainInputTextDeco,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: '검색한 내용을 입력하세요.',
                          hintStyle: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18.sp,
                            fontWeight: medium,
                            color: dmBlack,
                          ),
                          contentPadding: EdgeInsets.only(
                            bottom: 4.h,
                            left: 3.w,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                        ),
                        cursorHeight: 18.h,
                        cursorColor: dmBlack,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) {
                          controller.text.value = value;
                          controller.getData();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Image.asset(
                      'assets/images/icons/icon_search_black.png',
                      width: 26.5.w,
                      height: 26.5.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.75.h,
              ),
              divider,

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  child: Obx(
                    () => ScrollConfiguration(
                        behavior: MyBehavior(),
                        child:
                            // 데이터가 존재한다면
                            controller.list.isNotEmpty
                                ? NotificationListener(
                                    child: ListView.separated(
                                      controller:
                                          controller.scrollController.value,
                                      scrollDirection: Axis.vertical,
                                      itemCount: controller.list.length,
                                      separatorBuilder: (context, index) =>
                                          divider,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          // 첫번째 요소에만 윗부분 padding을 추가적으로 줌
                                          padding: index == 0
                                              ? EdgeInsets.only(
                                                  top: 30.5.h, bottom: 17.5.h)
                                              : EdgeInsets.symmetric(
                                                  vertical: 17.5.h),
                                          child: GestureDetector(
                                            // 요소 클릭 시 요소의 product_id를 DetailScreen으로 넘겨 이동
                                            onTap: () {
                                              context.pushNamed('detail',
                                                  queryParams: {
                                                    'productId':
                                                        controller.list[index]
                                                            ['product_id']
                                                  });
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  color: dmWhite,
                                                  // 기존 113.w에서 디바이스의 0.312배의 너비 값으로 변경
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.312,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          CachedNetworkImage(
                                                            fadeInDuration:
                                                                Duration.zero,
                                                            fadeOutDuration:
                                                                Duration.zero,
                                                            imageUrl: controller
                                                                    .list[index]
                                                                ['images'][0],
                                                            fit: BoxFit.cover,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.312,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.312,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.r),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                color: dmGrey,
                                                              ),
                                                            ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CupertinoActivityIndicator(),
                                                          ),
                                                          controller.list[index]
                                                                          [
                                                                          'status'] ==
                                                                      1 ||
                                                                  controller.list[
                                                                              index]
                                                                          [
                                                                          'status'] ==
                                                                      2
                                                              ? Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.312,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.312,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.r),
                                                                    color: dmBlack
                                                                        .withOpacity(
                                                                            0.75),
                                                                  ),
                                                                  child: Center(
                                                                    child: controller.list[index]['status'] ==
                                                                            1
                                                                        ? Image.asset(
                                                                            'assets/images/status/status_1.png',
                                                                            width: MediaQuery.of(context).size.width *
                                                                                0.312 *
                                                                                0.9)
                                                                        : Image.asset(
                                                                            'assets/images/status/status_2.png',
                                                                            width: MediaQuery.of(context).size.width *
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
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                child: Text(
                                                                  controller.list[
                                                                          index]
                                                                      ['title'],
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis, // Text가 overflow 현상이 일어나면 뒷부분을 ...으로 생략한다
                                                                  maxLines: 2,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Pretendard',
                                                                    fontSize:
                                                                        17.sp,
                                                                    fontWeight:
                                                                        medium,
                                                                    color:
                                                                        dmBlack,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 11.h,
                                                              ),
                                                              Text(
                                                                '${controller.list[index]['location']} | ${DateFormat('yy.MM.dd').format((controller.list[index]['uploadTime'].toDate()))}',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Pretendard',
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      medium,
                                                                  color: dmGrey,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 9.h,
                                                              ),
                                                              Text(
                                                                formatPrice(controller
                                                                            .list[
                                                                        index]
                                                                    ['price']),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Pretendard',
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      bold,
                                                                  color: dmBlue,
                                                                ),
                                                              ),
                                                              const Expanded(
                                                                  child:
                                                                      SizedBox()),
                                                              // likes가 1개 이상일 때만 표시
                                                              Visibility(
                                                                maintainSize:
                                                                    true,
                                                                maintainAnimation:
                                                                    true,
                                                                maintainState:
                                                                    true,
                                                                visible: controller
                                                                            .list[index]['likes']
                                                                            .length >
                                                                        0
                                                                    ? true
                                                                    : false,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        'assets/images/icons/icon_heart.png',
                                                                        width:
                                                                            13.w,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5.5.w,
                                                                      ),
                                                                      Text(
                                                                        '${controller.list[index]['likes'].length}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Pretendard',
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontWeight:
                                                                              bold,
                                                                          color:
                                                                              dmGrey,
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
                                                if (controller.isMore.value &&
                                                    controller.list.length ==
                                                        index + 1) ...[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 40.h,
                                                    ),
                                                    child:
                                                        const CupertinoActivityIndicator(),
                                                  )
                                                ]
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      '등록된 게시글이 없어요.',
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 14.sp,
                                        fontWeight: bold,
                                        color: dmLightGrey,
                                      ),
                                    ),
                                  )),
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
